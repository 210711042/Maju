import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maju/views/login/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    HttpOverrides.global = null;
  });

  testWidgets("Register Success", (WidgetTester tester) async {
    await tester.pumpWidget(
        ResponsiveSizer(builder: (context, orientation, deviceType) {
      return const MaterialApp(
        title: 'Maju',
        home: RegisterView(),
      );
    }));

    final usernameField = find.byKey(const ValueKey("usernameKey"));
    final emailField = find.byKey(const ValueKey("emailKey"));
    final passwordField = find.byKey(const ValueKey("passwordKey"));
    final password2Field = find.byKey(const ValueKey("password2Key"));
    final phoneField = find.byKey(const ValueKey("phoneKey"));
    final addressField = find.byKey(const ValueKey("addressKey"));

    await tester.enterText(usernameField, "thisistester");
    await tester.enterText(emailField, "tester2@gmail.com");
    await tester.enterText(passwordField, "tester");
    await tester.enterText(password2Field, "tester");
    await tester.enterText(phoneField, "12408281712");
    await tester.enterText(addressField, "tester no 5");
    await tester.pumpAndSettle();

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('submitBtn')),
      find.byType(SingleChildScrollView),
      const Offset(0, 50),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('submitBtn')));
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.text("OK"));
    await tester.pump(Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.text("Welcome to Maju"), findsWidgets);
  });
}
