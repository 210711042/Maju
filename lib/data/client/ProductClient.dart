import 'dart:convert';

import 'package:http/http.dart';

class Product {
  int? id;
  int idSeller;
  String productName, description;
  double price, rating;
  String? thumbnailUrl;

  Product(
      {this.id,
      required this.idSeller,
      required this.productName,
      required this.price,
      required this.description,
      required this.rating,
      this.thumbnailUrl});

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "price": price,
        "description": description,
        "id_seller": idSeller
      };
}

class ProductClient {
  static String url = '10.0.2.2:8000';
  static String endpoint = '/api/product';

  // static Future<Map<String, dynamic>> getProducts() async {
  //   try {
  //     var response = await get(Uri.http(url, endpoint));

  //     if (response.statusCode != 200) throw Exception(response.reasonPhrase);

  //     return json.decode(response.body);
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  static Future<List<Product>> getAllProducts() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      List<dynamic> productList = json.decode(response.body)['data'];

      List<Product> products = productList
          .map((product) => Product(
                id: product['id'],
                idSeller: product['id_seller'],
                productName: product['product_name'],
                price: product['price'].toDouble(),
                description: product['description'] ?? "",
                rating: product['rating'].toDouble(),
                thumbnailUrl: product['thumbnail_url'] ?? "",
              ))
          .toList();
      return products;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<Response> getProductsBySlug(slug) async {
    try {
      var response = await get(Uri.http(url, "$endpoint/q=$slug"));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      // print(response.body);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Product product) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(product));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Product product) async {
    try {
      var response = await put(Uri.http(url, "$endpoint/${product.id}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(product));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(id) async {
    try {
      print(Uri.http(url, "$endpoint/$id"));
      var response = await delete(Uri.http(url, "$endpoint/$id"));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      // print(response.body);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
