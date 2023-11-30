import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:maju/data/client/UserClient.dart';

void main() {
  test("Success Login", () async {
    final hasil = await UserClient.login("nathan4@gmail.com", "nathan123");
    expect(hasil['status'], equals(true));
  });
  test("Failed Login", () async {
    final hasil = await UserClient.login("nathan41@gmail.com", "nathan123");
    expect(hasil['status'], equals(false));
  });

  test("Success Register", () async {
    User user = User(
        email: "testing",
        username: "testing",
        password: "123",
        address: "testing",
        phone: "12312521");
    // print(user);
    final hasil = await UserClient.create(user);
    // print(jsonDecode(hasil.body)['status']);
    expect(jsonDecode(hasil.body)['status'], equals(true));
  });
}
