import 'package:flutter/material.dart';
import 'TrendingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CookingApp',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: TrendingPage(),
  );
}






