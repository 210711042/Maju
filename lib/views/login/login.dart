import 'package:flutter/material.dart';
import 'package:maju/core/widgets/maju_basic_button.dart';

class LoginView extends StatefulWidget {
  /*const*/ LoginView({super.key});

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signIn(){
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Successfully Sign In')),
      );
    }
  }

  static route() => MaterialPageRoute(builder: (context) => /*const*/ LoginView());

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSecurePassword = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
        //  key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Username here', 
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                ),
                SizedBox(height: 16.0),
                
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _isSecurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password here', 
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                      suffixIcon: togglePassword(),
                      ),
                      validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  ),
                SizedBox(height: 16.0),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton  (
                    onPressed: /*_signIn*/ (){}, child: Text("SIGN IN")
                    // onPressed: () {
                    //   if (_formKey.currentState!.validate()) {
                    //     ScaffoldMessenger.of(context.showSnackBar(
                    //       const SnackBar(content: Text('Successfully Sign In!'),
                    //       ),
                    //     )
                    //   );
                    //   }
                    // }
                    ))    
                    
                ],)),
      )
      
      
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Text("Halo"),
      //       MajuBasicButton(textButton: "Login", onPressed: (){})
      //     ],
      //   ),
      // ),
    );
  }
  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecurePassword = !_isSecurePassword;
      });
      
    }, icon: _isSecurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
    color: Colors.grey,);
  }
}
