import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';
import 'SearchPage.dart';

class TrendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: TrendingPageBody(),
    bottomNavigationBar: MyBottomNavigationBar(index: 0),
  );
}


class TrendingPageBody extends StatefulWidget {
  @override
  _TrendingPageBodyState createState() => _TrendingPageBodyState();
}

class _TrendingPageBodyState extends State<TrendingPageBody> {
  final dishes = ['Pizza', 'Gericht #2', 'Gericht #3', 'Gericht #4', 'Gericht #5', 'Gericht #6', 'Gericht #7', 'Gericht #8', 'Gericht #9', 'Gericht #10', 'Gericht #11', 'Gericht #12', 'Gericht #13', 'Gericht #14', 'Gericht #15', 'Gericht #16', 'Gericht #17', 'Gericht #18', 'Gericht #19', 'Gericht #20', ];

  @override
  Widget build(BuildContext context) => Container(
    child: Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: dishes.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                margin: EdgeInsets.only(top: 80.0, bottom: 16.0, left: 16.0),
                child: Text('Trending',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5
                  ),
                ),
              );
            }
            else {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: <Widget>[
                      Image.asset('images/pizza.jpg'),
                      Container(
                        height: 210.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(dishes[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage())),
            leading: IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text('Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    ),
  );
}