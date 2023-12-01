import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/as_seller/product_actions.dart'; // Sesuaikan dengan lokasi file ProductActions

void main() {
  testWidgets('Test Create Product', (WidgetTester tester) async {
    // Bangun widget ProductActions dalam mode tambah (Add)
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ProductActions(),
      ),
    ));

    // Tunggu hingga widget selesai diproses
    await tester.pump();

    // Temukan TextFormField berdasarkan labelnya
    final productNameField = find.widgetWithText(TextFormField, 'Nama Produk');
    final priceField = find.widgetWithText(TextFormField, 'Harga');
    final descriptionField = find.widgetWithText(TextFormField, 'Deskripsi Produk');

    // Verifikasi bahwa TextFormField tidak kosong saat widget dibangun dalam mode tambah
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
