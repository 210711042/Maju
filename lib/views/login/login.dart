import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/client/UserClient.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/login/register.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const LoginView());

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSecurePassword = true;

  void onLoginTaped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final isAuthenticated =
        await SQLHelper.login(_emailController.text, _passwordController.text);

    if (isAuthenticated.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Selamat Datang di MarketMaju!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 91, 202, 95),
        textColor: Colors.white,
        fontSize: 19.0.px,
      );
      await prefs.setStringList('account', <String>[
        isAuthenticated[0]['id'].toString(),
        isAuthenticated[0]['email'],
        isAuthenticated[0]['username'],
        isAuthenticated[0]['phone'],
        isAuthenticated[0]['address'],
      ]);

      if (context.mounted)
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeView()));
    } else {
      Fluttertoast.showToast(
        msg: "Email atau Password salah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        textColor: Colors.white,
        fontSize: 19.0.px,
      );
    }
  }

  void onLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> res = await UserClient.login(
      _emailController.text,
      _passwordController.text,
    );
    // debugPrint(res['data']['id']);

    // await prefs.setInt('account', res['data']['id']);

    if (res['status'] == false) {
      Fluttertoast.showToast(
        msg: "Username or password incorrect",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        textColor: Colors.white,
        fontSize: 19.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Selamat Datang di MarketMaju!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 91, 202, 95),
        textColor: Colors.white,
        fontSize: 19.0,
      );

      await prefs.setStringList('account', <String>[
        res['data']['id'].toString(),
        res['data']['email'],
        res['data']['username'],
        res['data']['phone'],
        res['data']['address'],
      ]);

      if (context.mounted) Navigator.of(context).push(HomeView.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              // horizontal: 25.5.px,
              // vertical: 50.5.px,
              top: 100.0.px,
              right: 16.0.px,
              left: 16.0.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Maju",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 36.0.px,
                    color: Palette.n900,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8.0.px,
              ),
              Text(
                  "Lorem ipsum dolor sit amet consectetur. In magnis adipiscing suspendisse risus eget elit dolor.",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12.0.px, fontWeight: FontWeight.normal)),
              SizedBox(
                height: 40.0.px,
              ),
              TextFormField(
                key: const ValueKey("emailKey"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.px),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0.px,
              ),
              TextFormField(
                key: const ValueKey("passwordKey"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController,
                obscureText: _isSecurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.px),
                  ),
                  suffixIcon: togglePassword(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20.0.px,
              ),
              MajuBasicButton(
                key: ValueKey("loginButton"),
                textButton: "Sign in",
                onPressed: () {
                  // onLoginTaped();
                  onLogin();
                },
              ),
              const SizedBox(
                height: 64,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 32.px),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(RegisterView.route());
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't have any account? ",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Palette.n400),
                ),
                TextSpan(
                  text: "Sign up",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Palette.n900,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
