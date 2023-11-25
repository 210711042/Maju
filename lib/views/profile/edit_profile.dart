import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/core/widgets/maju_basic_input.dart';
import 'package:maju/data/client/UserClient.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:image/image.dart' as img;

class EditProfile extends StatefulWidget {
  final int? id;
  final String? username, email, phone, address, image;

  const EditProfile(
      {super.key,
      this.id,
      this.username,
      this.email,
      this.phone,
      this.address,
      this.image});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isSaveMode = true;
  Future<void> onEditHandler() async {
    try {
      User data = User(
          id: widget.id!,
          email: emailController.text,
          username: usernameController.text,
          address: addressController.text,
          phone: phoneController.text);
      var response = await UserClient.update(data);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Failed update: $e");
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

  Future<void> _pickImageFromCamera() async {
    try {
      final returnImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (returnImage == null) return;

      final selectedImage = File(returnImage.path);

      User data = User(
          id: widget.id!,
          email: emailController.text,
          username: usernameController.text,
          address: addressController.text,
          phone: phoneController.text,
          image: selectedImage.path.toString());

      var response = await UserClient.update(data);
      debugPrint(jsonDecode(response.toString()));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Failed update: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      usernameController.text = widget.username!;
      emailController.text = widget.email!;
      phoneController.text = widget.phone!;
      addressController.text = widget.address!;
      debugPrint(widget.image);

      isSaveMode = false;
    }
    return Scaffold(
      appBar: const MajuBasicAppBar(
        leadingSupport: true,
      ),
      body: SingleChildScrollView(
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
                              deleteImage: () {},
                              pickFromCamera: () {
                                _pickImageFromCamera();
                              },
                              pickFromGallery: () {});
                        });
                  },
                  child: Stack(
                    children: [
                      widget.image != null
                          ? CircleAvatar(
                              radius: 48.px,
                              backgroundImage: MemoryImage(
                                  File(widget.image!).readAsBytesSync()))
                          : CircleAvatar(
                              radius: 48.px,
                              backgroundImage: const AssetImage(
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
                      widget.username!,
                      style: TextStyle(
                          fontSize: 20.px,
                          fontWeight: FontWeight.bold,
                          color: Palette.n900),
                    ),
                    SizedBox(
                      height: 8.0.px,
                    ),
                    Text(
                      widget.email!,
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
            MajuBasicInput(
              hintText: "Username",
              labelText: "Username",
              controller: usernameController,
            ),
            SizedBox(
              height: 8.0.px,
            ),
            MajuBasicInput(
              hintText: "Email",
              labelText: "Email",
              controller: emailController,
            ),
            SizedBox(
              height: 8.0.px,
            ),
            MajuBasicInput(
              hintText: "Nomor Telepon",
              labelText: "Nomor Telepon",
              controller: phoneController,
            ),
            SizedBox(
              height: 8.0.px,
            ),
            MajuBasicInput(
              hintText: "Alamat",
              labelText: "Alamat",
              controller: addressController,
            ),
            SizedBox(
              height: 32.0.px,
            ),
            MajuBasicButton(
                textButton:
                    isSaveMode ? "Simpan" : "Saya yakin untuk mengubah data",
                onPressed: () {
                  onEditHandler();
                })
          ],
        ),
      ),
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
