import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  buildDrawerTextStyle() => TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TrendingPage(),
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
    bottomNavigationBar: BottomNavigationBar(
      onTap: (index) {
        if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ShoppingPage()));
        else if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupPage()));
        else if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CalenderPage()));
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          title: Text('Einkaufsliste'),
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
    ),
  );
}

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
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

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) => Container(
    child: Text('Einkaufsliste'),
  );
}

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) => Container(
    child: Text('Gruppen'),
  );
}

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  @override
  Widget build(BuildContext context) => Container(
    child: Text('Kalender'),
  );
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
@override
  Widget build(BuildContext context) => Material(
    child: Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            leading: Icon(Icons.dehaze),
            title: Text('Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(height: 100.0),
            Divider(height: 0.0),
            Container(
              height: 70.0,
              child: Row(
                children: <Widget>[
                  Expanded(child: FlutterLogo()),
                  VerticalDivider(),
                  Expanded(child: FlutterLogo()),
                  VerticalDivider(),
                  Expanded(child: FlutterLogo()),
                ],
              ),
            ),
            Divider(height: 0.0),
            Container(
              height: 70.0,
              child: Row(
                children: <Widget>[
                  Expanded(child: Chip(label: Text('- #1 -'))),
                  Expanded(child: Chip(label: Text('- #2 -'))),
                  Expanded(child: Chip(label: Text('- #3 -'))),
                  Expanded(child: Chip(label: Text('- #4 -'))),
                ],
              ),
            ),
            Slider(
              value: 0.5,
              onChanged: null,
            ),
          ],
        ),
      ],
    ),
  );
}