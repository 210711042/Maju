import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/views/qr_scanner/success_payment.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  BarcodeCapture? barcodeCapture;
  double currentBrightness = 0;
  List<Map<String, dynamic>> dummyProducts = [];

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to reset brightness';
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  Future<double> getBrightness() async {
    try {
      return await ScreenBrightness().current;
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to get brightness';
    }
  }

  Future<void> setBrightnessToMax() async {
    await setBrightness(1.0);
  }

  Future<void> returnBrightness() async {
    await setBrightness(currentBrightness);
  }

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

  @override
  void initState() {
    debugPrint("=====================${currentBrightness.toString()}");
    getBrightness().then((brightness) {
      setState(() {
        currentBrightness = brightness;
      });
    });
    setBrightnessToMax();
    super.initState();
    readJson();
    debugPrint("=====================${currentBrightness.toString()}");
  }

  @override
  void dispose() {
    resetBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MajuProductAppBar(),
      body: PageView(
        children: [cameraView()],
      ),
    );
  }

  Widget cameraView() {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              startDelay: false,
              controller: MobileScannerController(torchEnabled: false),
              fit: BoxFit.fill,
              // errorBuilder: (context, error, child) {
              //   return ScannerErrorWidget(error: error);
              // },
              onDetect: (capture) => setBarcodeCapture(capture),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 25,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 50,
                        child: FittedBox(
                            child: GestureDetector(
                          onTap: () => getURLResult(),
                          child: barcodeCaptureTextResult(context),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget barcodeCaptureTextResult(BuildContext context) {
    if (barcodeCapture != null && barcodeCapture!.barcodes.isNotEmpty) {
      String productId = barcodeCapture!.barcodes.first.rawValue!;
      for (Map<String, dynamic> product in dummyProducts) {
        if (product['id'].toString() == productId) {
          debugPrint(product.toString());
          debugPrint("BERHASIL");
          Future.delayed(const Duration(milliseconds: 25), () {
            resetBrightness();
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SuccessPayment(
                        productName: product['title'].toString(),
                        price: product['price'].toString(),
                      )),
            );
          });

          break;
        }
      }
      // for (Map<String, dynamic> product in dummyProducts) {
      //   if (product['id'] == barcodeCapture!.barcodes.first.rawValue!) {
      //     debugPrint("found: $product['id]");
      //     Future.delayed(const Duration(milliseconds: 25), () {
      //       resetBrightness();
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const SuccessPayment()),
      //       );
      //     });
      //     break;
      //   }
      // }
    }
    //   if (barcodeCapture!.barcodes.first.rawValue!.startsWith("Product:")) {
    //     Future.delayed(const Duration(milliseconds: 25), () {
    //       resetBrightness();
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const SuccessPayment()),
    //       );
    //     });
    //     // return Text(
    //     //   barcodeCapture!.barcodes.first.rawValue!,
    //     //   overflow: TextOverflow.fade,
    //     //   style: Theme.of(context)
    //     //       .textTheme
    //     //       .headlineMedium!
    //     //       .copyWith(color: Colors.white),
    //     // );
    //   }
    // } else {
    //   return Text(
    //     'Click me',
    //     overflow: TextOverflow.fade,
    //     style: Theme.of(context)
    //         .textTheme
    //         .headlineMedium!
    //         .copyWith(color: Colors.white),
    //   );
    // }
    return Text(
      "Invalid QR for MAJU Payment",
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(color: Colors.white),
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    setState(() {
      barcodeCapture = capture;
    });
  }

  void getURLResult() {
    final qrCode = barcodeCapture?.barcodes.first.rawValue;
    if (qrCode != null) {
      // copyToClipboard(qrCode);
      debugPrint(qrCode);
    }
  }
}
