import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/entity/products.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/pdf/pdf_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment(
      {super.key, required this.productName, required this.price});
  final String productName;
  final String price;

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  String id = const Uuid().v1();
  List<Map<String, dynamic>> dummyProducts = [];
  late String productName = widget.productName;
  late String price = widget.price;
  List foundUser = [];

  List<Products> tempProducts = [
    Products(
        id: 1,
        productName: "Nasi Goreng",
        stock: 2,
        price: 22,
        image:
            "https://lh3.googleusercontent.com/ivhjnKf86AcJ2mrCOYckh0UhW9y4uWdUE91x_SoW0J9-kvnhZbiQ6QId5C4i5HkEdsHaqHqukZ2fLeMpZwtdcy1mfjw=w640-h400-e365-rj-sc0x00ffffff")
  ];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/products.json');
    final data = await json.decode(response);
    final fakeProducts = List<Map<String, dynamic>>.from(data['products']);

    setState(() {
      dummyProducts = fakeProducts;
      debugPrint(dummyProducts.toString());
    });
  }

  // Future<void> findProductById(String id) async {
  //   debugPrint("HAIII $id");
  //   for (Map<String, dynamic> product in dummyProducts) {
  //     debugPrint(product['id']);
  //     if (product['id'].toString() == id) {
  //       debugPrint("AWDAWD ${product['id'].toString()}");
  //     }
  //   }
  // }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? account = prefs.getStringList('account');
    final users = await SQLHelper.getUserById(int.parse(account![0]));
    setState(() {
      foundUser = users;
    });
    debugPrint(foundUser[0]['profile_image'].toString());
  }

  @override
  void initState() {
    debugPrint('PRODUCT ID IS ${widget.productName} ${widget.price}');
    readJson();
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MajuBasicAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pembayaran berhasil",
                style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    color: Palette.g400),
              ),
              // LottieBuilder.asset('assets/lottie/success.json')
              Lottie.asset('assets/lottie/success.json'),
              const SizedBox(
                height: 32.0,
              ),
              MajuBasicButton(
                textButton: "Kembali",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeView()));
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              MajuBasicButton(
                textButton: "Cetak Invoice",
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
                onPressed: () {
                  createPdf(widget.productName, widget.price, id,
                      foundUser[0]['profile_image'], context, tempProducts);
                  setState(() {
                    const uuid = Uuid();
                    id = uuid.v1();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
