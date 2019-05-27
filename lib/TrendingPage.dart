import 'package:flutter/material.dart';
import 'MyBottomNavigationBar.dart';
import 'SearchPage.dart';

class TrendingPage extends StatelessWidget {
  buildDrawerTextStyle() => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TrendingPageBody(),
    drawer: Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                FlutterLogo(),
                Text('     Profil'),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Kochbuch',style: buildDrawerTextStyle()),
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: Text('Ziele',style: buildDrawerTextStyle()),
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Statistiken',style: buildDrawerTextStyle()),
          ),
          Expanded(child: Container()),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Einladen',style: buildDrawerTextStyle()),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen',style: buildDrawerTextStyle()),
          ),
        ],
      ),
    ),
    bottomNavigationBar: MyBottomNavigationBar(index: 0),
  );
}


class TrendingPageBody extends StatefulWidget {
  @override
  _TrendingPageBodyState createState() => _TrendingPageBodyState();
}

class _TrendingPageBodyState extends State<TrendingPageBody> {
  final dishes = ['Gericht #1', 'Gericht #2', 'Gericht #3', 'Gericht #4', 'Gericht #5', 'Gericht #6', 'Gericht #7', 'Gericht #8', 'Gericht #9', 'Gericht #10', 'Gericht #11', 'Gericht #12', 'Gericht #13', 'Gericht #14', 'Gericht #15', 'Gericht #16', 'Gericht #17', 'Gericht #18', 'Gericht #19', 'Gericht #20', ];

  List<Widget> buildTrendingList() {
    List<Widget> trendingList = [];
    trendingList.add(Container(height: 80.0));
    trendingList.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('Trending',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5
        ),
      ),
    ));

    for (int i = 0; i < dishes.length; i++) {
      trendingList.add(ListTile(
        leading: FlutterLogo(),
        title: Text(dishes[i],
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        trailing: Icon(Icons.star_border),
      ),);
    }
    return trendingList;
  }

  @override
  Widget build(BuildContext context) => Container(
    child: Stack(
      children: <Widget>[
        ListView(children: buildTrendingList()),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage())),
            leading: Icon(Icons.dehaze),
            title: Text('Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    ),
  );
}