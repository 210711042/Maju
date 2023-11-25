import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/data/client/ProductClient.dart';
import 'package:maju/views/as_seller/product_actions.dart';

class SellerCenter extends StatefulWidget {
  const SellerCenter({super.key});

  @override
  State<SellerCenter> createState() => _SellerCenterState();
}

class _SellerCenterState extends State<SellerCenter> {
  Future<List<Product?>>? _products;

  void _getProducts() async {
    try {
      List<Product> productList = await ProductClient.getAllProducts();
      setState(() {
        _products = Future.value(productList);
      });
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  void _getProductBySlug(slug) async {
    try {
      var productList = await ProductClient.getProductsBySlug(slug);
      var responseBody = jsonDecode(productList.body.toString())['data'];
      List<Product> results =
          List<Product>.from(responseBody.map((item) => Product(
                id: item['id'],
                idSeller: item['id_seller'],
                productName: item['product_name'],
                price: item['price'].toDouble(),
                description: item['description'],
                rating: item['rating'].toDouble(),
                thumbnailUrl: item['thumbnail_url'],
              )));

      setState(() {
        _products = Future.value(results);
      });
    } catch (e) {
      debugPrint("Error fetching products by slug: $e");
    }
  }

  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Center"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const ProductActions()))
                  .then((value) => _getProducts());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("HALO"),
                TextFormField(
                  decoration: const InputDecoration(label: Text("Search")),
                  onFieldSubmitted: (value) =>
                      {debugPrint(value), _getProductBySlug(value)},
                  onChanged: (value) => {value.isEmpty ? _getProducts() : null},
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Product?>>(
                    future: _products,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final data = snapshot.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(data[index]!.productName),
                                subtitle: Text(data[index]!.description),
                                trailing: Text(CurrencyFormat.convertToIdr(
                                    data[index]!.price, 0)),
                                onTap: () {
                                  // debugPrint(data[index]!.id.toString());
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => ProductActions(
                                                id: data[index]!.id,
                                                productName:
                                                    data[index]!.productName,
                                                description:
                                                    data[index]!.description,
                                                price: data[index]!.price,
                                              )))
                                      .then((value) => _getProducts());
                                },
                              ),
                              const Divider(
                                height: 1,
                              )
                            ],
                          );
                        },
                      );
                    }),
              ],
            )),
      ),
    );
  }
}
