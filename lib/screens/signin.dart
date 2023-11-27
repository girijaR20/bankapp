import 'package:bankapp/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  Future<bool> _login(String username, String password) async {

    if (username == 'manager' && password == 'password') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('role', 'manager');
      return true;
    } else {
      return false;
    }
  }
  // bool isPasswordCompliant(String password, [int minLength = 6]) {
  //   if (password == null || password.isEmpty) {
  //     return false;
  //   }
  //
  //   bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  //   bool hasDigits = password.contains(new RegExp(r'[0-9]'));
  //   bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
  //   bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  //   bool hasMinLength = password.length > minLength;
  //
  //   return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
  // }
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  // bool validatePassword(String pass){
  //   //6 characters
  //   String _password = pass.trim();
  //   if(pass.length != 6){
  //     return false;
  //   }
  //   //one upperclass
  //   bool hasUpperCase = false;
  //   for(int i =0,)
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextFormField(
            validator: (value){
              if(value!.isEmpty){
                return "Please enter password";
              }else{
                //call function to check password
                bool result = validatePassword(value);
                if(result){
                  // create account event
                  return null;
                }else{
                  return " Password should contain Capital, small letter & Number & Special";
                }
              }
            },

            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await _login(
                  _usernameController.text, _passwordController.text);
              if (success) {
                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Home()));
              } else {
                const snackBar = SnackBar(
                  content: Text('Invalid username and password'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
