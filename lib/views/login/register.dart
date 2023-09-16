import 'package:flutter/material.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/login/login.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const RegisterView());

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your account",
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
              MajuBasicButton(textButton: "Sign up", onPressed: () {})
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(LoginView.route());
            },
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Palette.n400),
                    ),
                    TextSpan(
                      text: "Sign in",
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
