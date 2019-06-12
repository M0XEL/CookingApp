import 'package:flutter/material.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: Text('Gruppen'),
    bottomNavigationBar: MyBottomNavigationBar(index: 2),
  );
}