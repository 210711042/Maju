import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/seller/inputForm.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<Map<String, dynamic>> products = [];

  void refresh() async {
    final data = await SQLHelper.getProducts();
    setState(() {
      products = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
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
            Text(
              "Our Products",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 16.0,
                  color: Palette.n900,
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Update',
                        color: Colors.blue,
                        icon: Icons.update,
                        onTap: () async {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => InputProduct(
                          //       id: products[index]['id'],
                          //       productName: products[index]['productName'],
                          //       stock: stock,
                          //       price: price,
                          //       image: image,
                          //     ),
                          //   ),
                          // ).then((_) => refresh());
                        },
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          // await deleteproducts(products[index]['id']);
                        },
                      )
                    ],
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(products[index]['product_name'] + " | "),
                          Text(products[index]['image']),
                        ],
                      ),
                      subtitle: Text(products[index]['image']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
