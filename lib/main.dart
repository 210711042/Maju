import 'package:flutter/material.dart';
import 'package:maju/views/login/login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maju',
      home: LoginView(),
    );
  }
}
