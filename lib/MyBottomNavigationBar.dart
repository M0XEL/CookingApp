import 'package:flutter/material.dart';
import 'TrendingPage.dart';
import 'ShoppingPage.dart';
import 'GroupPage.dart';
import 'CalenderPage.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int index;
  MyBottomNavigationBar({this.index});

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedFontSize: 13.0,
    unselectedFontSize: 13.0,
    currentIndex: index,
    onTap: (index) {
      if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TrendingPage()));
      else if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ShoppingPage()));
      else if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupPage()));
      else if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CalenderPage()));
    },
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.whatshot),
        title: Text('Trend'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_basket),
        title: Text('Einkauf'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        title: Text('Gruppen'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        title: Text('Kalender'),
      ),
    ],
  );
}