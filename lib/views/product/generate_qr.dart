import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:maju/views/home/home.dart';

class GenerateQRPage extends StatelessWidget {
  final int id;
  final String productName;
  final double price;

  GenerateQRPage({
    required this.id,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = '$id';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('QR Generate $id'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Silahkan lakukan pembayaran dengan menscan QR di bawah ini",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 400,
                // embeddedImage: NetworkImage(
                //     "https://i.pinimg.com/736x/ed/a9/aa/eda9aabed661a98d62c5df2df6879258.jpg"),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
              //   },
              //   child: Text('Bayar Sekarang'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
