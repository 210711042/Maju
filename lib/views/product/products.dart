import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maju/core/utils/currency.dart';
import 'package:maju/data/entity/products.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/pdf/pdf_view.dart';
import 'package:maju/views/profile/profile.dart';
import 'package:maju/views/seller/inputForm.dart';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> foundProducts = [];
  int _selectedIndex = 1;
  String id = const Uuid().v1();

  List<Products> tempProducts = [
    Products(
        id: 1,
        productName: "Mie ayam",
        stock: 2,
        price: 22,
        image:
            "https://lh3.googleusercontent.com/ivhjnKf86AcJ2mrCOYckh0UhW9y4uWdUE91x_SoW0J9-kvnhZbiQ6QId5C4i5HkEdsHaqHqukZ2fLeMpZwtdcy1mfjw=w640-h400-e365-rj-sc0x00ffffff")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProductsView()));
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfileView()),
        );
        break;
    }
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/products.json');
    final data = await json.decode(response);
    print(data['products']);
    setState(() {
      products = data['products'];
    });
  }

  void refresh() async {
//     final String response = await rootBundle.loadString('assets/sample.json');
// final data = await json.decode(response);
    final data = await SQLHelper.getProducts();

    setState(() {
      products = data;
      foundProducts = products;
    });
  }

  void filterSearch(String key) {
    List<Map<String, dynamic>> results = [];

    if (key.isEmpty) {
      results = products;
    } else {
      results = products
          .where(
              (product) => product['product_name'].toLowerCase().contains(key))
          .toList();
    }
    setState(() {
      foundProducts = results;
    });
  }

  Future<void> deleteProduct(int id) async {
    await SQLHelper.deleteProduct(id);
    refresh();
  }

  @override
  void initState() {
    refresh();
    foundProducts = products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (foundProducts.isEmpty) {
    //   foundProducts = products;
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InputProduct(
                            id: null,
                            productName: null,
                            stock: null,
                            price: null,
                            image: null))).then((_) => refresh());
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) => filterSearch(value),
              decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
            ElevatedButton(
                onPressed: () {
                  readJson();
                },
                child: Text("Test")),
            ElevatedButton(
                onPressed: () {
                  debugPrint(tempProducts.toString());
                  // createPdf("Mie Ayam", "20000", id, context, tempProducts);
                  setState(() {
                    const uuid = Uuid();
                    id = uuid.v1();
                  });
                },
                child: const Text("Create PDF")),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Our Products",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 16.0,
                  color: Palette.n900,
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: foundProducts.isEmpty
                  ? const Column(
                      children: [
                        SizedBox(
                          height: 16.0,
                        ),
                        Text("No products found...")
                      ],
                    )
                  : ListView.builder(
                      itemCount: foundProducts.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: const SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Update',
                              color: Colors.blue,
                              icon: Icons.update,
                              onTap: () async {
                                if (products[index]['product_name'] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputProduct(
                                        id: products[index]['id'],
                                        productName: products[index]
                                            ['product_name'],
                                        stock: products[index]['stock'],
                                        price: products[index]['price'],
                                        image: products[index]['image'],
                                      ),
                                    ),
                                  ).then((_) => refresh());
                                } else {
                                  print(
                                      "Data produk memiliki nilai null  $products, $index");
                                }
                              },
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () async {
                                await deleteProduct(products[index]['id']);
                              },
                            )
                          ],
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(foundProducts[index]['image']),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foundProducts[index]['product_name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              fontSize: 14.0,
                                              color: Palette.n900,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        CurrencyFormat.convertToIdr(
                                            foundProducts[index]['price'], 2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              fontSize: 16.0,
                                              color: Palette.n900,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "${foundProducts[index]['stock'].toString()} items left",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              fontSize: 14.0,
                                              color: Palette.n900,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Palette.n900,
        unselectedItemColor: Palette.n600,
        onTap: _onItemTapped,
      ),
    );
  }
}
