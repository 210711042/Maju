import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/main.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/login/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  testWidgets("Login Success Temp", (WidgetTester tester) async {
    await tester.pumpWidget(
        ResponsiveSizer(builder: (context, orientation, deviceType) {
      Device.orientation == Orientation.portrait
          ? Container(
              width: 100.w,
              height: 20.5.h,
            )
          : Container(
              width: 100.w,
              height: 12.5.h,
            );
      Device.screenType == ScreenType.tablet
          ? Container(
              width: 100.w,
              height: 20.5.h,
            )
          : Container(
              width: 100.w,
              height: 12.5.h,
            );
      return MaterialApp(
        title: 'Maju',
        // theme: ThemeData(fontFamily: "Inter"),
        home: LoginView(),
      );
    }));

    // Find input fields and login button
    final emailField = find.byKey(const ValueKey("emailKey"));
    final passwordField = find.byKey(const ValueKey("passwordKey"));
    final loginButton = find.byKey(const ValueKey("loginButton"));

    // Enter email and password
    await tester.enterText(emailField, "nathan4@gmail.com");
    await tester.enterText(passwordField, "nathan123");

    // Tap login button
    await tester.tap(loginButton);
    await tester.pump();
    await tester.pumpAndSettle();

    // expect(find.text("Selamat Datang di MarketMaju!"), findsOneWidget);
  });

  
}
