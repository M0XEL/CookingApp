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
    _authenticateUser();
    Future(() {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TrendingPage()));
    });
  }

  void _authenticateUser() async {
    var user = await FirebaseAuth.instance.signInAnonymously();

    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('userId', user.uid);
  }
}