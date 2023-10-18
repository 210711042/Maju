import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/sql_helper.dart';

class InputProduct extends StatefulWidget {
  const InputProduct(
      {super.key,
      required this.id,
      required this.productName,
      required this.stock,
      required this.price,
      required this.image});

  final String? productName, image;
  final int? id, stock;
  final double? price;

  @override
  State<InputProduct> createState() => _InputProductState();
}

class _InputProductState extends State<InputProduct> {
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
        title: Text("INPUT PRODUCT"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: controllerProductName,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Product Name"),
          ),
          TextField(
            controller: controllerPrice,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Price"),
          ),
          TextField(
            controller: controllerStock,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Stock"),
          ),
          // Untuk image boleh diganti apakah menggunakan upload image / bagaimana
          TextField(
            controller: controllerImage,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Image"),
          ),
          SizedBox(
            height: 24.0,
          ),
          MajuBasicButton(
            textButton: "Save",
            onPressed: () async {
              if (widget.id == null) {
                await addProduct();
              } else {
                // await editEmployee(widget.id!);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> addProduct() async {
    await SQLHelper.addProduct(
        controllerProductName.text,
        double.parse(controllerPrice.text),
        int.parse(controllerStock.text),
        controllerImage.text);
  }
}
