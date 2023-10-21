import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/login/register.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  // const LoginView({super.key});

  // static route() => MaterialPageRoute(builder: (context) => const LoginView());

  const LoginView({Key? key});

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const LoginView());

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSecurePassword = true;

  // String _email = '';
  // String _password = '';

  void onLoginTaped() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isAuthenticated =
        await SQLHelper.login(_emailController.text, _passwordController.text);

    if (isAuthenticated.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Selamat Data di MarketMaju!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 91, 202, 95),
        textColor: Colors.white,
        fontSize: 19.0,
      );

      Navigator.of(context).push(HomeView.route());
    } else {
      Fluttertoast.showToast(
        msg: "Email atau Password salah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        textColor: Colors.white,
        fontSize: 19.0,
      );
    }
    await prefs.setStringList('account', <String>[
      isAuthenticated[0]['id'].toString(),
      isAuthenticated[0]['email'],
      isAuthenticated[0]['username'],
      isAuthenticated[0]['phone'],
      isAuthenticated[0]['address']
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to Maju",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 36.0,
                    color: Palette.n900,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  "Lorem ipsum dolor sit amet consectetur. In magnis adipiscing suspendisse risus eget elit dolor.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal)),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _emailController, // Hubungkan controller
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController, // Hubungkan controller
                obscureText: _isSecurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  suffixIcon: togglePassword(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 24,
              ),
              MajuBasicButton(
                textButton: "Sign in",
                onPressed: () {
                  // Navigator.of(context).push(HomeView.route());
                  onLoginTaped();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
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
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )),
          )),
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
