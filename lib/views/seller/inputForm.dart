import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? selectedImage, editImage;
  String? originalProductName;
  int? originalStock;
  double? originalPrice;

  List<String> assetImages = [
    'assets/images/products/product_1.png',
    'assets/images/products/product_2.png',
    'assets/images/products/product_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerProductName.text = widget.productName!;
      controllerStock.text = widget.stock!.toString();
      controllerPrice.text = widget.price!.toStringAsFixed(2);
      selectedImage = widget.image;
    }

    @override
    void initState() {
      originalProductName = controllerProductName.text;
      originalStock = int.parse(controllerStock.text);
      originalPrice = double.parse(controllerPrice.text);
      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("INPUT PRODUCT"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: controllerProductName,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Product Name"),
          ),
          TextField(
            controller: controllerPrice,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Price",
            ),
          ),
          TextField(
            controller: controllerStock,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: "Stock"),
          ),
          const SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField(
            value: selectedImage,
            items: assetImages
                .map((e) => DropdownMenuItem(value: e, child: Image.asset(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedImage = value;
                editImage = value;
                controllerProductName.text = originalProductName!;
                controllerStock.text = originalStock.toString();
                controllerPrice.text = originalPrice!.toStringAsFixed(2);
              });
            },
            decoration: InputDecoration(
              labelText: 'Product',
              border: OutlineInputBorder(),
            ),
            hint: Text('Pilih Gambar'),
          ),
          const SizedBox(
            height: 24.0,
          ),
          MajuBasicButton(
            textButton: "Save",
            onPressed: () async {
              if (widget.id == null) {
                await addProduct();
              } else {
                await editProduct(widget.id!);
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
        selectedImage!);
  }

  Future<void> editProduct(int id) async {
    if (controllerPrice != null && controllerPrice.text != null) {
      if (editImage != null) {
        await SQLHelper.editProduct(
            id,
            controllerProductName.text,
            double.parse(controllerPrice.text),
            int.parse(controllerStock.text),
            editImage!);
      } else {
        await SQLHelper.editProduct(
            id,
            controllerProductName.text,
            double.parse(controllerPrice.text),
            int.parse(controllerStock.text),
            widget.image!);
      }
    } else {
      print('Data Kosong!');
    }
  }
}
