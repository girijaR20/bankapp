import 'package:bankapp/screens/manage_account.dart';
import 'package:bankapp/screens/view_wallet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _role = '';
  bool _isLoading = false;

  Future<void> _checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    if (role != null && role.isNotEmpty) {
      setState(() {
        _role = role;
      });
    } else {
      Text("user not found");

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Wallet App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome, $_role'),
              ElevatedButton(
                onPressed: () {
                  // Perform actions based on user role
                  if (_role == 'manager') {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ManageAccountsPage()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ViewWalletsPage()));
                  }
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
