import 'package:flutter/material.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: Text('Recipe'),
    bottomNavigationBar: MyBottomNavigationBar(index: 3),
  );
}