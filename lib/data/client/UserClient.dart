import 'dart:convert';

import 'package:http/http.dart';

class User {
  int? id;
  String email;
  String username;
  String? password;
  String address;
  String phone;
  String? image;

  User(
      {this.id,
      required this.email,
      required this.username,
      this.password,
      required this.address,
      required this.phone,
      this.image});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      address: json['address'],
      phone: json['phone']);

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "password": password,
        "address": address,
        "phone": phone,
        "image": image
      };
}

class UserClient {
  // static final String url = '10.0.2.2:8000';
  static final String url = '127.0.0.1:8000';
  static final String endpoint = '/api/user';

  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<User> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(json.decode(response.body));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> findById(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return json.decode(response.body);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(User user) async {
    try {
      // print(user.toRawJson());
      // print(Uri.http(url, endpoint));
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(User user) async {
    try {
      // print(user.toRawJson());
      // print(Uri.http(url, endpoint));
      var response = await put(Uri.http(url, "$endpoint/${user.id}"),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());
      print("${response.body.toString()} ${response.statusCode}");
      if (response.statusCode != 201) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      Map<String, dynamic> request = {"email": email, "password": password};

      var response = await post(
        Uri.http(url, '/api/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(request),
      );

      if (response.statusCode != 200) {
        return {
          "status": false,
          "message": "Login failed: ${response.reasonPhrase}",
        };
      }
      print(json.decode(response.body).toString());
      return json.decode(response.body);
    } catch (e) {
      return {
        "status": false,
        "message": "Error: ${e.toString()}",
      };
    }
  }
}
