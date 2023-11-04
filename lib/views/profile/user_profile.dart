import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/UI/maju_basic_tile.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/login/login.dart';
import 'package:maju/views/profile/edit_profile.dart';
import 'package:local_auth/local_auth.dart';
import 'package:maju/views/qr_scanner/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  List foundUser = [];

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

    final List<String>? account = prefs.getStringList('account');
    final users = await SQLHelper.getUserById(int.parse(account![0]));
    setState(() {
      foundUser = users;
    });
    debugPrint(foundUser[0]['profile_image']);
  }

  @override
  void initState() {
    auth = LocalAuthentication();
    _getAvailableBiometrics();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
    // debugPrint(_supportState.toString());
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MajuBasicAppBar(leadingSupport: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Palette.n0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
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
                          foundUser[0]['profile_image'] != null
                              ? CircleAvatar(
                                  radius: 32,
                                  backgroundImage: MemoryImage(
                                      foundUser[0]['profile_image']))
                              : const CircleAvatar(
                                  radius: 32,
                                  backgroundImage:
                                      AssetImage("assets/images/profile.jpg")),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16.0,
                              color: Palette.n900,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foundUser[0]['username'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Palette.n900),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          foundUser[0]['email'],
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Palette.n700),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 32.0,
                ),
                PengaturanAkunTileView(
                    onAuthenticate:
                        _supportState ? _authenticate : _securityIsNotDefined),
                const SizedBox(
                  height: 32.0,
                ),
                const TransaksiTileView(),
                const SizedBox(
                  height: 32.0,
                ),
                const PusatBantuanTileView(),
              ],
            ),
          ),
        ),
      ),
    );
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

  // Future<void> _authenticateFaceID() async {
  //   try {
  //     bool authenticated = await auth.authenticate(
  //         localizedReason: "Use Face ID for authentication",
  //         options: const AuthenticationOptions(
  //             stickyAuth: true, biometricOnly: true));

  //     if (authenticated) {
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const EditProfile()));
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

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
    await SQLHelper.deleteProfileImage(foundUser[0]['id']);
    await _loadUserData();
  }

  Future<void> _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnImage == null) return;

    final selectedImage = File(returnImage.path);
    final imgFile = File(returnImage.path).readAsBytesSync();
    final compressedImage = await compressImage(imgFile);

    await updateProfileImageAndLoadData(selectedImage, compressedImage);
  }

  Future<void> _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    final selectedImage = File(returnImage.path);
    final imgFile = File(returnImage.path).readAsBytesSync();
    final compressedImage = await compressImage(imgFile);

    await updateProfileImageAndLoadData(selectedImage, compressedImage);
  }

  Future<void> updateProfileImageAndLoadData(
      File selectedImage, Uint8List compressedImage) async {
    await SQLHelper.updateProfileImage(foundUser[0]['id'], compressedImage);
    await _loadUserData();

    if (context.mounted) {
      Navigator.of(context).pop();
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
        const Text(
          "Pengaturan Akun",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Palette.n900),
        ),
        const SizedBox(
          height: 16.0,
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
      const Text(
        "Transaksi",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Palette.n900),
      ),
      const SizedBox(
        height: 16.0,
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
        const Text(
          "Pusat Bantuan",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Palette.n900),
        ),
        const SizedBox(
          height: 16.0,
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
      height: 264,
      child: Container(
        decoration: const BoxDecoration(
            color: Palette.n0,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Pilih Foto Profile",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Palette.n900),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              MajuBasicButton(
                  textButton: "Hapus Foto Profile",
                  onPressed: () {
                    deleteImage();
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            color: Palette.n900,
                            width: 1.0,
                          ),
                        ),
                      ),
                      elevation: const MaterialStatePropertyAll(0.0),
                      backgroundColor:
                          const MaterialStatePropertyAll<Color>(Colors.white),
                      foregroundColor:
                          const MaterialStatePropertyAll<Color>(Palette.n900))),
              const SizedBox(
                height: 8.0,
              ),
              MajuBasicButton(
                textButton: "Ambil melalui Gallery",
                onPressed: () {
                  pickFromGallery();
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Palette.n900,
                          width: 1.0,
                        ),
                      ),
                    ),
                    elevation: const MaterialStatePropertyAll(0.0),
                    backgroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.white),
                    foregroundColor:
                        const MaterialStatePropertyAll<Color>(Palette.n900)),
              ),
              const SizedBox(
                height: 8.0,
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
