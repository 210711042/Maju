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
  bool _isSecurePassword = true;
  bool _isSecurePassword2 = true;

   _showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Perhatian!'),
      content: Text('Sudah Yakin Dengan Datamu?'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).push(LoginView.route());
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

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
              TextFormField(
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }if(!value.contains('@'))
                  {
                    return 'Email harus menggunakan @';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                 autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  }if(value.length<5)
                  {
                    return 'Password minimal 5 digit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _isSecurePassword2,
                decoration: InputDecoration(
                    labelText: 'Re-Enter Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isSecurePassword2 = !_isSecurePassword2;
                        });
                      },
                      icon: _isSecurePassword2
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      color: Colors.grey,
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }if(value != _isSecurePassword2 ){
                    return 'Password tidak cocok';
                  }if(value.length<5){
                    return'Password harus minimal 5';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              // ----- DATE PICKER HERE -----
              SizedBox(
                height: 24,
              ),
              MajuBasicButton(textButton: "Sign up", 
              onPressed: () {
                _showAlertDialog(context);
              })
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

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
