import 'package:flutter/material.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/core/widgets/maju_basic_input.dart';
import 'package:maju/themes/palette.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32.px,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
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
                SizedBox(
                  width: 16.0.px,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yudas Iskariot",
                      style: TextStyle(
                          fontSize: 20.px,
                          fontWeight: FontWeight.bold,
                          color: Palette.n900),
                    ),
                    SizedBox(
                      height: 8.0.px,
                    ),
                    Text(
                      "yudasiskariot@gmail.com",
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
              hintText: "Nama Lengkap",
              labelText: "Nama Lengkap",
              controller: TextEditingController(text: "Yudas Iskariot"),
            ),
             SizedBox(
              height: 8.0.px,
            ),
            MajuBasicInput(
              hintText: "Email",
              labelText: "Email",
              controller:
                  TextEditingController(text: "yudasiskariot@gmail.com"),
            ),
             SizedBox(
              height: 8.0.px,
            ),
            const MajuBasicInput(
              hintText: "Nomor Telepon",
              labelText: "Nomor Telepon",
            ),
             SizedBox(
              height: 8.0.px,
            ),
            const MajuBasicInput(
              hintText: "Alamat",
              labelText: "Alamat",
            ),
             SizedBox(
              height: 32.0.px,
            ),
            MajuBasicButton(textButton: "Simpan", onPressed: () {})
          ],
        ),
      ),
    );
  }
}
