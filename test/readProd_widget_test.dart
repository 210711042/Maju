import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/data/client/ProductClient.dart';
import 'package:maju/views/as_seller/SellerCenter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets('Test Read Product', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          double containerHeight =
              orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return Material(
            child: Container(
              width: 100.w,
              height: containerHeight,
              color: Colors.blue,
              child: SellerCenter(
                key: Key('sellerCenterKey'), 
                products: Future.value([
                  Product(
                    id: 1,
                    idSeller: 1,
                    productName: "Mie Ayam",
                    price: 15000.0,
                    description: "Enak dan lezat!",
                    rating: 4,
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();

  // Find the SellerCenter widget
  final Finder sellerCenterFinder = find.byKey(Key('sellerCenterKey'));
  expect(sellerCenterFinder, findsOneWidget);

  // Now, find the Scaffold widget inside the SellerCenter using a different key
  final Finder scaffoldFinder = find.byKey(Key('sellerCenterScaffoldKey'));
  expect(scaffoldFinder, findsOneWidget);

  // Add additional expectations if needed
});

}
