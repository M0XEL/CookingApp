import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';
import 'SearchPage.dart';
import 'RecipePage.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: MyBottomNavigationBar(index: 0),
    body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<DocumentSnapshot> recipes = snapshot.data.documents;
          return Container(
            child: Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: recipes.length + 1,
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
                      index--;
                      return MaterialButton(
                        padding: EdgeInsets.all(0.0),
                        child: Card(
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
                                        child: Text(recipes[index].data['name'],
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
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RecipePage(recipes[index].documentID))),
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
                      onPressed: null, //() => Scaffold.of(context).openDrawer(),
                    ),
                    title: Text('Search for recipes...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}