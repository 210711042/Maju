import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/product_actions.dart';

void main() {
  testWidgets('Test Update Product', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ProductActions(),
      ),
    ));

    await tester.pump();

    final productNameField = find.widgetWithText(TextFormField, 'Nama Produk');
    final priceField = find.widgetWithText(TextFormField, 'Harga');
    final descriptionField =
        find.widgetWithText(TextFormField, 'Deskripsi Produk');

    expect(productNameField, findsOneWidget);
    expect(priceField, findsOneWidget);
    expect(descriptionField, findsOneWidget);

    await tester.enterText(productNameField, 'Updated Product Name');
    await tester.enterText(priceField, '50');
    await tester.enterText(descriptionField, 'Updated Product Description');

    expect(find.text('Updated Product Name'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
    expect(find.text('Updated Product Description'), findsOneWidget);
  });
}
