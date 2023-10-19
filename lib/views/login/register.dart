import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';
import 'package:maju/themes/palette.dart';
import 'package:maju/views/login/login.dart';
import 'package:maju/data/sql_helper.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const RegisterView());

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSecurePassword = true;
  bool _isSecurePassword2 = true;

  DateTime? _selectedDate;
  String _date = '';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reEnterPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // void _showDatePicker() async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(2000),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.dark(),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (pickedDate != null) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _date = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
  //     });
  //   }
  // }

  void _showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Perhatian!'),
      content: Text('Sudah Yakin Dengan Datamu?'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () async{
            // Tambahkan pengguna baru ke database
            await SQLHelper.addUser(_emailController.text, _passwordController.text, _usernameController.text, _phoneNumberController.text, _addressController.text );
          Fluttertoast.showToast(
            msg: "Berhasil Melakukan Registrasi!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Color.fromARGB(255, 91, 202, 95),
            textColor: Colors.white,
            fontSize: 19.0,
          );
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

  // bool _isEmailAlreadyUsed(String email) {
  //   final usedEmails = ['user1@example.com', 'user2@example.com'];
  //   return usedEmails.contains(email);
  // }
    Future<bool> _isEmailAlreadyUsed(String email) async {
      final List<User> users = await SQLHelper.getUsers();
      return users.any((user) => user.email == email);
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
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 36.0,
                    color: Palette.n900,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Lorem ipsum dolor sit amet consectetur. In magnis adipiscing suspendisse risus eget elit dolor.",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 12.0, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus menggunakan @';
                  }
                  if (value.contains(value)) {
                    return 'Email sudah digunakan';
                  }
  //              if (await isEmailAlreadyUsed(value)) {
  //                return 'Email sudah digunakan';
  //              } >> harusnya pake ini tapi error? 
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _isSecurePassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
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
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: _isSecurePassword2,
                controller: _reEnterPasswordController,
                decoration: InputDecoration(
                  labelText: 'Re-Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value != _passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  if (value.length < 5) {
                    return 'Password harus minimal 5 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _phoneNumberController,
                decoration: InputDecoration(
                    labelText: 'No.Telepon',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
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
                height: 16,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _addressController,
                decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0))),
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
              // SizedBox(
              //   height: 16,
              // ),
              // GestureDetector(
              //   onTap: _showDatePicker,
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       labelText: 'Select Date',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8.0),
              //       ),
              //     ),
              //     child: Text(
              //       _selectedDate == null ? 'Select a date' : _date,
              //       style: TextStyle(fontSize: 16.0),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 24,
              ),
              MajuBasicButton(
                textButton: "Sign up",
                onPressed: () {
                  if (_validateForm()) {
                    _showAlertDialog(context);
                  }
                
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
                      .subtitle2!
                      .copyWith(color: Palette.n400),
                ),
                TextSpan(
                  text: "Sign in",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Palette.n900, decoration: TextDecoration.underline),
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
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  bool _validateForm() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _reEnterPasswordController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}