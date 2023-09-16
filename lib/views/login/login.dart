import 'package:flutter/material.dart';

import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/home/home.dart';
import 'package:maju/views/login/register.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static route() => MaterialPageRoute(builder: (context) => const LoginView());

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
              SizedBox(
                height: 8,
              ),
              Text(
                  "Lorem ipsum dolor sit amet consectetur. In magnis adipiscing suspendisse risus eget elit dolor.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12.0, fontWeight: FontWeight.normal)),
              SizedBox(
                height: 40,
              ),
              MajuBasicButton(
                textButton: "Sign in",
                onPressed: () {
                  Navigator.of(context).push(HomeView.route());
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
}
