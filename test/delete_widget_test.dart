import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/SellerCenter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });
  testWidgets("Delete success", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SellerCenter(),
    ));
    await tester.pumpAndSettle(Duration(seconds: 3));
    final productName = find.text("unde");
    await tester.tap(productName);

    await tester.pumpAndSettle(Duration(seconds: 3));

    final deleteBtn = find.byKey(const ValueKey("deleteBtn"));

    await tester.tap(deleteBtn);
    await tester.pump(Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text("unde"), findsNothing);
  });
}
