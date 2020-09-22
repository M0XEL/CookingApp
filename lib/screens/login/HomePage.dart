import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.phone_locked),
            onPressed: _signOut,
          )
        ],
      ),
      body: Center(),
    );
  }

  Future<void> _signOut() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }
}
