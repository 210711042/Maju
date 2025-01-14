import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/data/client/UserClient.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/login/login.dart';
import 'package:maju/data/sql_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(
      {super.key,
      this.id,
      this.email,
      this.username,
      this.password,
      this.phone,
      this.address});

  final String? email, username, password, phone, address;
  final int? id;

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const RegisterView());

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSecurePassword = true;
  bool _isSecurePassword2 = true;
  bool isEmailUsed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    User input = User(
        id: widget.id ?? 1,
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text,
        address: addressController.text,
        phone: phoneNumberController.text);

    try {
      if (widget.id == null) await UserClient.create(input);
      Fluttertoast.showToast(
        msg: "Berhasil Melakukan Registrasi!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 91, 202, 95),
        textColor: Colors.white,
        fontSize: 19.0.px,
      );
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal melakukan registrasi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 19.0.px,
      );
    }
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Perhatian!'),
      content: const Text('Sudah Yakin Dengan Datamu?'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            onRegister();

            // await addUser();

            // Fluttertoast.showToast(
            //   msg: "Berhasil Melakukan Registrasi!",
            //   toastLength: Toast.LENGTH_SHORT,
            //   gravity: ToastGravity.TOP,
            //   backgroundColor: const Color.fromARGB(255, 91, 202, 95),
            //   textColor: Colors.white,
            //   fontSize: 19.0.px,
            // );
            // if (mounted) Navigator.of(context).push(LoginView.route());
          },
        ),
        TextButton(
          child: const Text('Cancel'),
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

  Future<bool> isEmailAlreadyUsed(String email) async {
    final users = await SQLHelper.getUsers();
    return users.any((user) => user['email'] == email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 25.5.px,
              vertical: 50.5.px,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Create your account",
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 12.0.px, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 32.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("usernameKey"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: usernameController,
                    decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                      if (value.length < 5) {
                        return 'Username harus lebih dari 5 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("emailKey"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.px))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Email harus menggunakan @';
                      }
                      if (isEmailUsed) {
                        return 'Email sudah digunakan';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("passwordKey"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _isSecurePassword,
                    controller: passwordController,
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
                      if (value.length < 5) {
                        return 'Password minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("password2Key"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _isSecurePassword2,
                    controller: reEnterPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Re-Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.px),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isSecurePassword2 = !_isSecurePassword2;
                          });
                        },
                        icon: _isSecurePassword2
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        color: Colors.grey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value != passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      if (value.length < 5) {
                        return 'Password harus minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("phoneKey"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                        labelText: 'No.Telepon',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.px))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor Telepon tidak boleh kosong';
                      }
                      if (value.length < 10) {
                        return 'Nomor Telepon harus memiliki minimal 10 digit';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0.px,
                  ),
                  TextFormField(
                    key: const ValueKey("addressKey"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.px))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      if (value.length < 5) {
                        return 'Alamat minimal harus 5 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24.0.px,
                  ),
                  MajuBasicButton(
                    key: const ValueKey("submitBtn"),
                    textButton: "Sign up",
                    onPressed: () async {
                      isEmailUsed =
                          await isEmailAlreadyUsed(emailController.text);

                      setState(() {});

                      if (validateForm() && !isEmailUsed) {
                        if (mounted) showAlertDialog(context);
                      }
                    },
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 32.0.px),
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

  bool validateForm() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        reEnterPasswordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> addUser() async {
    await SQLHelper.addUser(
        emailController.text,
        passwordController.text,
        usernameController.text,
        phoneNumberController.text,
        addressController.text);
  }
}
