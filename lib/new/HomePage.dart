import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'RecipePage.dart';
import 'BottomNavigation.dart';

class HomePage extends StatelessWidget {
  final controller = StreamController<int>();

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
      body: StreamBuilder(
        stream: controller.stream,
        builder: (context, snapshot) {
          print(controller.stream);
          return Column(
            children: [
              RaisedButton(onPressed: () => controller.add(1)),
              RaisedButton(onPressed: () => controller.add(2)),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(index: 0),
    );
  }

  Future<void> _signOut() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }
}
