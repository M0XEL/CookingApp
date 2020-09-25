import 'package:flutter/material.dart';
import 'HomePage.dart';

class BottomNavigation extends StatelessWidget {
  final int index;
  BottomNavigation({this.index});

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (index) {
          if (index == 0)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
          else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            title: Text('Rezepte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            title: Text('Rezepte'),
          ),
        ],
      );
}
