import 'package:flutter/material.dart';
import 'screens/login/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CookingApp',
    theme: ThemeData(primarySwatch: Colors.orange),
    home: LoginPage(),
  );
}






