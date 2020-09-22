import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Sign out'),
          color: Colors.red,
          onPressed: _signOut,
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }
}
