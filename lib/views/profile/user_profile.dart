import 'package:flutter/material.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/themes/palette.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MajuBasicAppBar(leadingSupport: true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    Positioned(
                      child: Icon(
                        Icons.camera_alt,
                        size: 16.0,
                        color: Palette.n900,
                      ),
                      bottom: 0,
                      right: 0,
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
            SizedBox(
              height: 32.0,
            ),
            Text(
              "Pengaturan Akun",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Palette.n900),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    print("Personal information is tapped");
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Expanded(child: Text("Personal Informasion"))
                    ],
                  ),
                )),
            const SizedBox(
              height: 8.0,
            ),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    print("Daftar Alamat is tapped");
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.home_rounded,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Expanded(child: Text("Daftar Alamat"))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
