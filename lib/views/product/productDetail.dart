import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/core/widgets/UI/maju_basic_appbar.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/product/generate_qr.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key,
      required this.id,
      required this.productName,
      required this.price,
      required this.stock,
      required this.images,
      required this.thumbnail,
      required this.description});

  final int? id;
  final String? productName, thumbnail, description;
  final List<dynamic> images;
  final int? stock;
  final double? price;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController controllerProductName = TextEditingController();
  TextEditingController controllerStock = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerThumbnail = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerProductName.text = widget.productName!;
      controllerStock.text = widget.stock!.toString();
      controllerPrice.text = widget.price!.toStringAsFixed(2);
      controllerThumbnail.text = widget.thumbnail!;
      controllerDescription.text = widget.description!;
    }
    return Scaffold(
      appBar: const MajuProductAppBar(title: "Cari produk..."),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: double.infinity,
            //   height: 339,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.black.withOpacity(0.3),
            //         Colors.black.withOpacity(0),
            //         Colors.black.withOpacity(0),
            //         Colors.white.withOpacity(0),
            //       ],
            //     ),
            //   ),
            //   child: Stack(
            //     children: [
            //       Image.network(
            //         widget.image.toString(),
            //         width: double.infinity,
            //         fit: BoxFit.cover,
            //         filterQuality: FilterQuality.high,
            //       ),
            //       MajuProductAppBar(
            //         title: "Halo",
            //         // backSupport: false,
            //       ),
            //     ],
            //   ),
            // ),
            // Positioned(
            //   top: 0,
            //   child: Image.network(
            //     widget.thumbnail.toString(),
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //     filterQuality: FilterQuality.high,
            //   ),
            // ),
            CarouselSlider(
              options: CarouselOptions(
                height: 400,
                // aspectRatio: 16 / 9,
                // autoPlay: true,
                // autoPlayInterval: Duration(seconds: 5),
                // autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                viewportFraction: 1,
              ),
              items: widget.images.map((imageURL) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      // decoration: BoxDecoration(border: Border.all(width: 1)),
                      width: double.infinity,
                      height: 600,
                      child: Image.network(
                        imageURL.toString(),
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controllerProductName.text,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Palette.n900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    CurrencyFormat.convertToIdr(widget.price, 0),
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    controllerDescription.text,
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Palette.n900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateQRPage(
                        productName: controllerProductName.text,
                        price:  double.parse(controllerPrice.text),
                      ),
                    ),
                  );
                },
                child: Text('Buat QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
