import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/UI/maju_basic_tile.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/client/UserClient.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/login/login.dart';
import 'package:maju/views/profile/edit_profile.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maju/views/qr_scanner/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:image/image.dart' as img;

File? shownImage;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  Map<String, dynamic> foundUser = {};

  // Image picker variable
  final ImagePicker picker = ImagePicker();
  Uint8List? imgFile;
  File? selectedImage;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  TextEditingController? addressController;
  int? id;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? users = prefs.getStringList('account');

    User user = await UserClient.find(users![0]);

    Map<String, dynamic> userMap = user.toJson();
    debugPrint(userMap.toString());
    setState(() {
      foundUser = userMap;
    });

    debugPrint(foundUser.toString());
    // debugPrint(foundUser[0]['profile_image']);
  }

  @override
  void initState() {
    auth = LocalAuthentication();
    _getAvailableBiometrics();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, ScreenType) {
      return Scaffold(
        appBar: const MajuBasicAppBar(leadingSupport: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Palette.n0,
            child: Padding(
              padding: EdgeInsets.all(16.0.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0.px),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return BottomSheetOptions(
                                    deleteImage: _deleteImage,
                                    pickFromCamera: _pickImageFromCamera,
                                    pickFromGallery: _pickImageFromGallery);
                              });
                        },
                        child: Stack(
                          children: [
                            foundUser['image'] != null
                                ? CircleAvatar(
                                    radius: 48.px,
                                    backgroundImage:
                                        MemoryImage(foundUser['image']))
                                : CircleAvatar(
                                    radius: 48.px,
                                    backgroundImage: AssetImage(
                                        "assets/images/profile.jpg")),
                            Positioned(
                              bottom: 0.px,
                              right: 0.px,
                              child: Icon(
                                Icons.camera_alt,
                                size: 16.0.px,
                                color: Palette.n900,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16.0.px,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foundUser['username'],
                            style: TextStyle(
                                fontSize: 20.px,
                                fontWeight: FontWeight.bold,
                                color: Palette.n900),
                          ),
                          SizedBox(
                            height: 8.0.px,
                          ),
                          Text(
                            foundUser['email'],
                            style: TextStyle(
                                fontSize: 16.0.px,
                                fontWeight: FontWeight.normal,
                                color: Palette.n700),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.0.px,
                  ),
                  PengaturanAkunTileView(
                      onAuthenticate: _supportState
                          ? _authenticate
                          : _securityIsNotDefined),
                  SizedBox(
                    height: 32.0.px,
                  ),
                  TransaksiTileView(),
                  SizedBox(
                    height: 32.0.px,
                  ),
                  PusatBantuanTileView(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _securityIsNotDefined() async {
    if (context.mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EditProfile()));
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Put your finger on sensor",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: false));

      if (authenticated) {
        if (context.mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfile()));
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    debugPrint("List of availableBiometrics: $availableBiometrics");

    if (!mounted) return;

    setState(() {
      _supportState = true;
    });
  }

  Future<void> _deleteImage() async {
    await SQLHelper.deleteProfileImage(foundUser[0]);
    await _loadUserData();
  }

  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;

    final selectedImage = File(returnImage.path);
    final imgFile = File(returnImage.path).readAsBytesSync();
    final compressedImage = await compressImage(Uint8List.fromList(imgFile));

    await updateProfileImageAndLoadData(selectedImage, compressedImage);
  }

  Future<void> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    final selectedImage = File(returnImage.path);
    final imgFile = File(returnImage.path).readAsBytesSync();
    final compressedImage = await compressImage(Uint8List.fromList(imgFile));

    await updateProfileImageAndLoadData(selectedImage, compressedImage);
  }

  Future<void> updateProfileImageAndLoadData(
      File selectedImage, Uint8List compressedImage) async {
     String email = foundUser['email'];
    String username = foundUser['username'];
    String password = foundUser['password'];
    String address = foundUser['address'];
    String phone = foundUser['phone'];

    User userToUpdate = User(
      id: foundUser['id'],
      email: email,
      username: username,
      password: password,
      address: address,
      phone: phone,
      profile_image: compressedImage,
    );
    try {
      await UserClient.update(userToUpdate);
      await _loadUserData();

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error updating profile image: $e");
    }
  }

  Future<Uint8List> compressImage(Uint8List imageData,
      {int quality = 70}) async {
    final image = img.decodeImage(imageData);

    if (image == null) {
      return imageData;
    }

    final compressedImageData = img.encodeJpg(image, quality: quality);

    return Uint8List.fromList(compressedImageData);
  }
}

class PengaturanAkunTileView extends StatelessWidget {
  const PengaturanAkunTileView({super.key, this.onAuthenticate});
  final VoidCallback? onAuthenticate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pengaturan Akun",
          style: TextStyle(
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: Palette.n900),
        ),
        SizedBox(
          height: 16.0.px,
        ),
        MajuBasicTile(
            icon: Icons.person,
            title: "Informasi Pengguna",
            onTap: () {
              onAuthenticate!();
            }),
        MajuBasicTile(
            icon: Icons.home_rounded, title: "Daftar Alamat", onTap: () {}),
        MajuBasicTile(icon: Icons.money, title: "Rekening Bank", onTap: () {}),
      ],
    );
  }
}

class TransaksiTileView extends StatelessWidget {
  const TransaksiTileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Transaksi",
        style: TextStyle(
            fontSize: 16.px, fontWeight: FontWeight.w600, color: Palette.n900),
      ),
      SizedBox(
        height: 16.0.px,
      ),
      MajuBasicTile(
          icon: Icons.shopping_cart, title: "Keranjang", onTap: () {}),
      MajuBasicTile(
          icon: Icons.attach_money,
          title: "Traktir",
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BarcodeScanner()));
          }),
      MajuBasicTile(
          icon: Icons.shopping_bag, title: "Riwayat Transaksi", onTap: () {}),
    ]);
  }
}

class PusatBantuanTileView extends StatelessWidget {
  const PusatBantuanTileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pusat Bantuan",
          style: TextStyle(
              fontSize: 16.px,
              fontWeight: FontWeight.w600,
              color: Palette.n900),
        ),
        SizedBox(
          height: 16.0.px,
        ),
        MajuBasicTile(icon: Icons.delete, title: "Hapus Akun", onTap: () {}),
        MajuBasicTile(
            icon: Icons.logout,
            title: "Keluar",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginView()));
            }),
      ],
    );
  }
}

class BottomSheetOptions extends StatelessWidget {
  const BottomSheetOptions(
      {super.key,
      required this.pickFromCamera,
      required this.pickFromGallery,
      required this.deleteImage});
  final VoidCallback pickFromCamera, pickFromGallery, deleteImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Device.orientation == Orientation.portrait ? 264.0.px : 400.0.px,
      child: Container(
        decoration: BoxDecoration(
            color: Palette.n0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0.px),
                topRight: Radius.circular(16.0.px))),
        child: Padding(
          padding: EdgeInsets.all(16.0.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.close),
                    SizedBox(
                      width: 8.0.px,
                    ),
                    Text(
                      "Pilih Foto Profile",
                      style: TextStyle(
                          fontSize: 20.0.px,
                          fontWeight: FontWeight.w600,
                          color: Palette.n900),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24.0.px,
              ),
              MajuBasicButton(
                  textButton: "Hapus Foto Profile",
                  onPressed: () {
                    deleteImage();
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.px),
                          side: BorderSide(
                            color: Palette.n900,
                            width: 1.0.px,
                          ),
                        ),
                      ),
                      elevation: MaterialStatePropertyAll(0.0.px),
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.white),
                      foregroundColor:
                          const MaterialStatePropertyAll<Color>(Palette.n900))),
              SizedBox(
                height: 8.0.px,
              ),
              MajuBasicButton(
                textButton: "Ambil melalui Gallery",
                onPressed: () {
                  pickFromGallery();
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0.px),
                        side: BorderSide(
                          color: Palette.n900,
                          width: 1.0.px,
                        ),
                      ),
                    ),
                    elevation: MaterialStatePropertyAll(0.0.px),
                    backgroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.white),
                    foregroundColor:
                        const MaterialStatePropertyAll<Color>(Palette.n900)),
              ),
              SizedBox(
                height: 8.0.px,
              ),
              MajuBasicButton(
                  textButton: "Ambil dengan Kamera",
                  onPressed: () {
                    pickFromCamera();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
