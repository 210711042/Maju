import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/login/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets("Login Success", (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ResponsiveSizer(
              builder: (context, orientation, deviceType) {
                return const MaterialApp(
                  title: 'Maju',
                  home: LoginView(),
                );
              },
            );
          },
        ),
      ),
    );

    tester.binding.window.physicalSizeTestValue = const Size(1280, 768);
    // Find input fields and login button
    final emailField = find.byKey(const ValueKey("emailKey"));
    final passwordField = find.byKey(const ValueKey("passwordKey"));
    final loginButton = find.byKey(const ValueKey("loginButton"));

    // Enter email and password
    await tester.enterText(emailField, "nathan@gmail.com");
    await tester.enterText(passwordField, "nathan123");
    await tester.pumpAndSettle();

    // Tap login button
    await tester.tap(loginButton);
    await tester.pump(Duration(seconds: 3));
    await tester.pumpAndSettle();

    // expect(find.byType(HomeView), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 3));
    expect(find.text("Diskon Spesial"), findsOneWidget);
    await tester.pumpAndSettle();

    // expect(find.widgetWithText(FlutterT, "Selamat Datang di MarketMaju!"),
    //     findsOneWidget);
  });
}
