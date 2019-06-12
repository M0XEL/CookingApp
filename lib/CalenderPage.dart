import 'package:flutter/material.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: Text('Kalender'),
    bottomNavigationBar: MyBottomNavigationBar(index: 3),
  );
}