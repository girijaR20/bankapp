import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewWalletsPage extends StatefulWidget {
  @override
  _ViewWalletsPageState createState() => _ViewWalletsPageState();
}

class _ViewWalletsPageState extends State<ViewWalletsPage> {
  Future<Map<String, double>> _getWallets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, double> wallets = {};
    List<String>? userWallets = prefs.getStringList('userWallets');
    if (userWallets != null) {
      for (String userWallet in userWallets) {
        List<String> parts = userWallet.split(':');
        wallets[parts[0]] = double.parse(parts[1]);
      }
    }
    return wallets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Wallets')),
      body: FutureBuilder(
        future: _getWallets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, double> wallets =
            snapshot.data as Map<String, double>;
            return ListView.builder(
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                String wallet = wallets.keys.elementAt(index);
                double balance = wallets[wallet]!;
                return ListTile(
                  title: Text('Wallet: $wallet'),
                  subtitle: Text('Balance: \$$balance'),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
