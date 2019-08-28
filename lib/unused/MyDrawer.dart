/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                FlutterLogo(),
                _handleAuthentification(),
              ],
            ),
          ),
          _buildDrawerChildren(Icons.book, 'Kochbuch'),
          _buildDrawerChildren(Icons.assignment_turned_in, 'Ziele'),
          _buildDrawerChildren(Icons.show_chart, 'Statistiken'),
          Expanded(child: Container()),
          _buildDrawerChildren(Icons.person_add, 'Einladen'),
          _buildDrawerChildren(Icons.settings, 'Einstellungen')
        ],
      ),
  );

  _buildDrawerChildren(IconData icon, String text) => ListTile(
    leading: Icon(icon),
    title: Text(text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _handleAuthentification() => StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        var user = snapshot.data;
        return Text(user.uid);
      }
      else {
        return Text('Signing in...');
      }
    },
  );
}*/