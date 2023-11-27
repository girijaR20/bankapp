import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAccountsPage extends StatelessWidget {
  Future<Map<String, List<String>>> _getAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> accounts = {};
    List<String>? users = prefs.getStringList('users');
    if (users != null) {
      for (String user in users) {
        List<String>? wallets = prefs.getStringList(user);
        if (wallets != null) {
          accounts[user] = wallets;
        }
      }
    }
    return accounts;
  }

  Future<void> _createUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? users = prefs.getStringList('users');
    if (users == null) {
      users = [];
    }
    if (users.contains(username)) {
      Text("User already exists");
    } else {
      users.add(username);
      await prefs.setStringList(username, []);
      await prefs.setStringList('users', users);
      Text("User created successfully");
    }
  }

  Future<void> _createWallet(String user, String wallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wallets = prefs.getStringList(user);
    if (wallets == null) {
      wallets = [];
    }
    wallets.add(wallet);
    await prefs.setStringList(user, wallets);
    Text("Wallet created successfully");
  }

  void _showInputDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Access the input values
                String username = usernameController.text;
                String password = passwordController.text;

                // Perform actions with username and password here
                _createUser(username, password);
                // Close the dialog
                Navigator.pop(context);
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Accounts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
      ),
      body: FutureBuilder(
        future: _getAccounts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, List<String>> accounts =
            snapshot.data as Map<String, List<String>>;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                String user = accounts.keys.elementAt(index);
                List<String> wallets = accounts[user]!;
                return ListTile(
                  title: Text('User: $user'),
                  subtitle: Text('Wallets: ${wallets.length}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Create Wallet'),
                            content: TextField(
                              onChanged: (value) =>
                              wallets = value.split(','),
                              decoration: InputDecoration(
                                labelText: 'Enter comma-separated wallets',
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  wallets.forEach((wallet) {
                                    _createWallet(user, wallet);
                                  });
                                },
                                child: Text('Create'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Create Wallet'),
                  ),
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
