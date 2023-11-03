import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:maju/views/home/home.dart';

class GenerateQRPage extends StatelessWidget {
  final String productName;
  final double price;

  GenerateQRPage({
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = 'Product: $productName, Price: $price';
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('QR Generate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
              },
              child: Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}