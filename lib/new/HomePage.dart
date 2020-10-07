import 'dart:async';

import 'package:CookingApp/new/SchedulePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'RecipePage.dart';

class HomePage extends StatelessWidget {
  final controller = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) {
        Widget body;
        if (snapshot.data == 0 || snapshot.data == null) {
          body = Container(
            color: Colors.blue,
          );
          body = RecipePage();
        } else if (snapshot.data == 1) {
          body = Container(
            color: Colors.purple,
          );
          body = SchedulePage();
        } else {
          body = Container(
            color: Colors.green,
          );
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.phone_locked),
                onPressed: _signOut,
              )
            ],
          ),
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: snapshot.data ?? 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.whatshot),
                label: 'Rezepte',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Planen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Sozial',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                controller.add(0);
              } else if (index == 1) {
                controller.add(1);
              } else {
                controller.add(2);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete();
  }
}
