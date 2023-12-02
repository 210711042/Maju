import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/client/ProductClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductActions extends StatefulWidget {
  final String? productName, description;
  final double? price;
  final int? id;

  const ProductActions(
      {super.key, this.id, this.productName, this.price, this.description});

  @override
  State<ProductActions> createState() => _ProductActionsState();
}

class _ProductActionsState extends State<ProductActions> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _createProduct() async {
    try {
      Product data = Product(
          idSeller: 1,
          productName: _productNameController.text,
          price: double.parse(_priceController.text),
          description: _descriptionController.text,
          rating: 4);
      var response = await ProductClient.create(data);

      if (mounted) Navigator.pop(context);

      debugPrint(response.toString());
    } catch (e) {
      debugPrint("Error create products: $e");
    }
  }

  Future<void> _updateProduct() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String>? users = prefs.getStringList('account');

      Product data = Product(
          id: widget.id!,
          idSeller: int.parse(users![0].toString()),
          productName: _productNameController.text,
          price: double.parse(_priceController.text),
          description: _descriptionController.text,
          rating: 4);

      var response = await ProductClient.update(data);

      if (mounted) Navigator.pop(context);

      debugPrint(response.toString());
    } catch (e) {
      debugPrint("Error updating products: $e");
    }
  }

  Future<void> _deleteProduct(id) async {
    try {
      debugPrint(id.toString());
      var response = await ProductClient.destroy(id.toString());
      debugPrint(response.body);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error deleting products: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id == null) {
      debugPrint("ADD MODE");
    } else {
      debugPrint("EDIT MODE ${widget.id}");
      _productNameController.text = widget.productName.toString();
      _descriptionController.text = widget.description.toString();
      _priceController.text = widget.price.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.id == null ? "Add" : "Read",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                    label: const Text("Nama Produk"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: const Text("Harga"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    label: const Text("Deskripsi Produk"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Visibility(
                visible: widget.id != null,
                child: Column(
                  children: [
                    MajuBasicButton(
                        textButton: "Hapus",
                        onPressed: () async {
                          if (widget.id != null) {
                            // debugPrint(widget.id.toString());
                            await _deleteProduct(widget.id);
                          }
                        }),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
              MajuBasicButton(
                  textButton: widget.id == null ? "Tambah" : "Edit",
                  onPressed: () async {
                    if (widget.id != null) {
                      await _updateProduct();
                    } else {
                      await _createProduct();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
