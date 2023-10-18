import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail(
      {super.key,
      required this.id,
      required this.productName,
      required this.price,
      required this.stock,
      required this.image});

  final int? id;
  final String? productName, image;
  final int? stock;
  final double? price;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  TextEditingController controllerProductName = TextEditingController();
  TextEditingController controllerStock = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerImage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerProductName.text = widget.productName!;
      controllerStock.text = widget.stock!.toString();
      controllerPrice.text = widget.price!.toStringAsFixed(2);
      controllerImage.text = widget.image!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
      ),
      body: Text(controllerProductName.text),
    );
  }
}
