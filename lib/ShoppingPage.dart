import 'package:flutter/material.dart';
import 'MyBottomNavigationBar.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Text('Einkaufsliste'),
    bottomNavigationBar: MyBottomNavigationBar(index: 1),
  );
}