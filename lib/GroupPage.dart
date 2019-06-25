import 'package:flutter/material.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  String string = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    bottomNavigationBar: MyBottomNavigationBar(index: 2),
    body: Column(
      children: <Widget>[
        Container(height: 100.0),
        /*TabBar(
          tabs: <Widget>[
            Tab(
              text: 'Tab #1',
            ),
            Tab(
              text: 'Tab #2',
            )
          ],
        ),*/
      ],
    )
  );
}