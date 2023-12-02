import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/SellerCenter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets("Update success", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SellerCenter(),
    ));
    await tester.pumpAndSettle(Duration(seconds: 3));
    final productName = find.text("fugiat");
    await tester.tap(productName);

    await tester.pumpAndSettle(Duration(seconds: 3));

    final namaField = find.byKey(const ValueKey("namaKey"));
    final hargaField = find.byKey(const ValueKey("hargaKey"));
    final deskripsiField = find.byKey(const ValueKey("deskripsiKey"));
    final actionBtn = find.byKey(const ValueKey("actionBtn"));

    // Enter email and password
    await tester.enterText(namaField, "2");
    await tester.enterText(hargaField, "2");
    await tester.enterText(deskripsiField, "2");
    await tester.tap(actionBtn);
    await tester.pump(Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text("2"), findsWidgets);
  });
}
