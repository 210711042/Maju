import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/product_actions.dart'; // Sesuaikan dengan lokasi file ProductActions

void main() {
  testWidgets('Test Create Product', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ProductActions(),
      ),
    ));

    await tester.pump();
    
    final productNameField = find.widgetWithText(TextFormField, 'Nama Produk');
    final priceField = find.widgetWithText(TextFormField, 'Harga');
    final descriptionField = find.widgetWithText(TextFormField, 'Deskripsi Produk');

    expect(find.widgetWithText(TextFormField, 'Nama Produk'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Harga'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Deskripsi Produk'), findsOneWidget);

    TextFormField productNameTextField = tester.widget(productNameField);
    TextFormField priceTextField = tester.widget(priceField);
    TextFormField descriptionTextField = tester.widget(descriptionField);

    expect(productNameTextField.controller!.text.isEmpty, true);
    expect(priceTextField.controller!.text.isEmpty, true);
    expect(descriptionTextField.controller!.text.isEmpty, true);
  });
}
