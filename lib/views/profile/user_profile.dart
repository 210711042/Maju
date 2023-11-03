import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/UI/maju_basic_tile.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/profile/edit_profile.dart';
import 'package:local_auth/local_auth.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MajuBasicAppBar(leadingSupport: true),
      body: Padding(
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
                          return const BottomSheetOptions();
                        });
                  },
                  child: const Stack(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
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
                ),
                const SizedBox(
                  width: 16.0,
                ),
                const Column(
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
            PengaturanAkunTileView(onAuthenticate: _authenticate),
            const SizedBox(
              height: 32.0,
            ),
            const TransaksiTileView(),
            const SizedBox(
              height: 32.0,
            ),
            const PusatBantuanTileView()
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Put your finger on sensor",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: false));

      if (authenticated) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditProfile()));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _authenticateFaceID() async {
  try {
    bool authenticated = await auth.authenticate(
        localizedReason: "Use Face ID for authentication",
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: true));

    if (authenticated) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EditProfile()));
    }
  } on PlatformException catch (e) {
    print(e);
  }
}
  

  // Future<void> _getAvailableBiometrics() async {
  //   List<BiometricType> availableBiometrics =
  //       await auth.getAvailableBiometrics();

  //   print("List of availableBiometrics: $availableBiometrics");

  //   if (!mounted) return;

  //   setState(() {
  //     _supportState = true;
  //   });
  // }
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
      ],
    );
  }
}

class BottomSheetOptions extends StatelessWidget {
  const BottomSheetOptions({super.key});

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  const Text(
                    "Pilih Foto Profile",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Palette.n900),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              MajuBasicButton(
                  textButton: "Hapus Foto Profile",
                  onPressed: () {},
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
                textButton: "Ambil melalui Galery",
                onPressed: () {},
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
                  textButton: "Ambil dengan Kamera", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
