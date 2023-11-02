import 'package:flutter/material.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/core/widgets/maju_basic_input.dart';
import 'package:maju/themes/palette.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MajuBasicAppBar(
        leadingSupport: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    Positioned(
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
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yudas Iskariot",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Palette.n900),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "yudasiskariot@gmail.com",
                      style: TextStyle(
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
            MajuBasicInput(
              hintText: "Nama Lengkap",
              labelText: "Nama Lengkap",
              controller: TextEditingController(text: "Yudas Iskariot"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            MajuBasicInput(
              hintText: "Email",
              labelText: "Email",
              controller:
                  TextEditingController(text: "yudasiskariot@gmail.com"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const MajuBasicInput(
              hintText: "Nomor Telepon",
              labelText: "Nomor Telepon",
            ),
            const SizedBox(
              height: 8.0,
            ),
            const MajuBasicInput(
              hintText: "Alamat",
              labelText: "Alamat",
            ),
            const SizedBox(
              height: 32.0,
            ),
            MajuBasicButton(textButton: "Simpan", onPressed: () {})
          ],
        ),
      ),
    );
  }
}
