import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/SellerCenter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets("Create success", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SellerCenter(),
    ));
    final addBtn = find.byKey(const ValueKey("addBtn"));
    await tester.tap(addBtn);

    await tester.pumpAndSettle(Duration(seconds: 3));

    final namaField = find.byKey(const ValueKey("namaKey"));
    final hargaField = find.byKey(const ValueKey("hargaKey"));
    final deskripsiField = find.byKey(const ValueKey("deskripsiKey"));
    final actionBtn = find.byKey(const ValueKey("actionBtn"));

    // Enter email and password
    await tester.enterText(namaField, "Tester Product 3");
    await tester.enterText(hargaField, "1000000");
    await tester.enterText(deskripsiField, "Tester deskripsi");
    await tester.tap(actionBtn);
    await tester.pump(Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text("Tester Product 3"), findsWidgets);
  });
}
