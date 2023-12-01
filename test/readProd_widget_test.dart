import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/product_actions.dart';

void main() {
  testWidgets('Test Read Product', (WidgetTester tester) async {
    
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ProductActions(
          id: 1,
          productName: "Mie Ayam",
          price: 15000.0,
          description: "Enak dan lezat!",
        ),
      ),
    ));

    
    await tester.pump();
    await tester.pumpAndSettle();
    
    expect(find.widgetWithText(TextFormField, 'Nama Produk'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Harga'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Deskripsi Produk'), findsOneWidget);

    TextFormField productNameTextField = tester.widget(find.widgetWithText(TextFormField, 'Nama Produk'));
    TextFormField priceTextField = tester.widget(find.widgetWithText(TextFormField, 'Harga'));
    TextFormField descriptionTextField = tester.widget(find.widgetWithText(TextFormField, 'Deskripsi Produk'));

    expect(productNameTextField.controller!.text, "Mie Ayam");
    expect(priceTextField.controller!.text, "15000.0");
    expect(descriptionTextField.controller!.text, "Enak dan lezat!");
  });
}
