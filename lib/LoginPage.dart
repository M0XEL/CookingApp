import 'package:CookingApp/TrendingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) => Container();
  
  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously().then((user) {
      SharedPreferences.getInstance().then((sharedPreferences) {
        sharedPreferences.setString('userId', user.uid).then((next) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TrendingPage()));
        });
      });
    });
  }
}