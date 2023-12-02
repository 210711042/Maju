import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/SellerCenter.dart';
import 'package:maju/views/as_seller/product_actions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets("Read Success", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SellerCenter(),
    ));

    await tester.pumpAndSettle(Duration(seconds: 3));

    expect(find.text("iPhone 14 Pro Max"), findsOneWidget);
  });

  // testWidgets("Create success", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: SellerCenter(),
  //   ));
  //   final addBtn = find.byKey(const ValueKey("addBtn"));
  //   await tester.tap(addBtn);

  //   await tester.pumpAndSettle(Duration(seconds: 3));

  //   final namaField = find.byKey(const ValueKey("namaKey"));
  //   final hargaField = find.byKey(const ValueKey("hargaKey"));
  //   final deskripsiField = find.byKey(const ValueKey("deskripsiKey"));
  //   final actionBtn = find.byKey(const ValueKey("actionBtn"));

  //   // Enter email and password
  //   await tester.enterText(namaField, "Tester Product 2");
  //   await tester.enterText(hargaField, "1000000");
  //   await tester.enterText(deskripsiField, "Tester deskripsi");
  //   await tester.tap(actionBtn);
  //   await tester.pump(Duration(seconds: 3));
  //   await tester.pumpAndSettle();

  //   expect(find.text("Tester Product 2"), findsWidgets);
  // });

  // testWidgets("Update success", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: SellerCenter(),
  //   ));
  //   await tester.pumpAndSettle(Duration(seconds: 3));
  //   final productName = find.text("fugiat");
  //   await tester.tap(productName);

  //   await tester.pumpAndSettle(Duration(seconds: 3));

  //   final namaField = find.byKey(const ValueKey("namaKey"));
  //   final hargaField = find.byKey(const ValueKey("hargaKey"));
  //   final deskripsiField = find.byKey(const ValueKey("deskripsiKey"));
  //   final actionBtn = find.byKey(const ValueKey("actionBtn"));

  //   // Enter email and password
  //   await tester.enterText(namaField, "2");
  //   await tester.enterText(hargaField, "2");
  //   await tester.enterText(deskripsiField, "2");
  //   await tester.tap(actionBtn);
  //   await tester.pump(Duration(seconds: 3));
  //   await tester.pumpAndSettle();

  //   expect(find.text("fugiat2"), findsOneWidget);
  // });

  // testWidgets("Delete success", (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     home: SellerCenter(),
  //   ));
  //   final productName = find.text("unde");
  //   await tester.tap(productName);

  //   await tester.pumpAndSettle(Duration(seconds: 3));

  //   final deleteBtn = find.byKey(const ValueKey("deleteBtn"));

  //   await tester.tap(deleteBtn);
  //   await tester.pump(Duration(seconds: 3));
  //   await tester.pumpAndSettle();

  //   expect(find.text("unde"), findsNothing);
  // });
}
