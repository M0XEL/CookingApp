import 'package:CookingApp/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'RecipePage.dart';
import 'MyBottomNavigationBar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

enum BodyType{trending, filter, categorie, recipe}

class _SearchPageState extends State<SearchPage> {
  Future<List<QuerySnapshot>> future = Future.wait([
    Firestore.instance.collection('categories').getDocuments(),
    Firestore.instance.collection('recipes').getDocuments(),
  ]);
  List<String> completeList = List<String>();
  List<String> displayList = List<String>();
  bool initList = true;
  TextEditingController textEditingController = TextEditingController();
  BodyType bodyType = BodyType.trending;
  String searchString = '';
  Widget body = Container();

  changeSearchResults(string) {
    print(textEditingController.text);
    if (string.isNotEmpty) {
      List<String> newList = List<String>();
      completeList.forEach((item) {
        if (item.contains(string)) {
          newList.add(item);
        }
      });
      setState(() {
        displayList.clear();
        displayList.addAll(newList);
        bodyType = BodyType.categorie;
      });
    } 
    else {
      setState(() {
        displayList.clear();
        displayList.addAll(completeList);
        bodyType = BodyType.filter;
      });
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<QuerySnapshot>>(
    future: future,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
          break;

        case ConnectionState.done:
          if (initList) {
            completeList = snapshot.data[0].documents.first['names'].cast<String>();
            displayList.addAll(completeList);
            initList = false;
          }

          switch (bodyType) {
            case BodyType.trending:
            body = Scaffold(
              bottomNavigationBar: MyBottomNavigationBar(index: 0),
              body: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('recipes').snapshots(),
                builder: (context, snapshot1) {
                  if (!snapshot1.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<DocumentSnapshot> recipes = snapshot1.data.documents;
                    return Container(
                      child: Stack(
                        children: <Widget>[
                          ListView.builder(
                            itemCount: recipes.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Container(
                                  margin: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
                                  child: Text('Beliebt',
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
                                      child: Container(
                                        height: MediaQuery.of(context).size.width * (9/16),
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: recipes[index].data['imageUrl'] != null ? NetworkImage(recipes[index].data['imageUrl']) : AssetImage('images/pizza.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RecipePage(recipes[index].documentID))),
                                );
                              }
                            }
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
              break;

            case BodyType.filter:
              body = Text('Place for filters');;
              break;

            case BodyType.categorie:
              body = ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(displayList[index]),
                        )
                      ],
                    ),
                    onPressed: () => setState(() {
                      bodyType = BodyType.recipe;
                      searchString = displayList[index];
                    }),
                  );
                },
              );
              break;

            case BodyType.recipe:
              List<DocumentSnapshot> recipes = List<DocumentSnapshot>();
              recipes.clear();
              snapshot.data[1].documents.forEach((document) {
                if (document['categorie'] != null) {
                  if (document['categorie'] == searchString) {
                    recipes.add(document);
                  }
                }
              });
              if (recipes.isEmpty) {
                snapshot.data[1].documents.forEach((document) {
                  if (document['name'].contains(searchString)) {
                    recipes.add(document);
                  }
                });
              }

              body = ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                    padding: EdgeInsets.all(0.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width * (9/16),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                child: Text(recipes[index]['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: recipes[index].data['imageUrl'] != null ? NetworkImage(recipes[index].data['imageUrl']) : AssetImage('images/pizza.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RecipePage(recipes[index].documentID))),
                  );
                },
              );
              break;
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  bodyType = BodyType.trending;
                  textEditingController.text = '';
                }),
              ),
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 48.0,
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onTap: () => setState(() {
                          bodyType = BodyType.filter;
                        }),
                        onChanged: (string) => changeSearchResults(string),
                        onSubmitted: (string) => setState(() {
                          bodyType = BodyType.recipe;
                          searchString = string;
                        }),
                      ),
                    ),
                    Container(
                      width: 48.0,
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.clear();
                          changeSearchResults('');
                        }
                      ),
                    ),
                    FutureBuilder<FirebaseUser>(
                      future: FirebaseAuth.instance.currentUser(),
                      builder: (context, user) {
                        if (user.connectionState == ConnectionState.done) {
                          return IconButton(
                            icon: CircleAvatar(
                              backgroundImage: NetworkImage(user.data.photoUrl),
                            ),
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ListView(
                                  children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(user.data.photoUrl),
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(user.data.displayName),
                                          Text(user.data.email),
                                        ],
                                      ),
                                      trailing: FlatButton(
                                        child: Text('Abmelden'),
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          GoogleSignIn().signOut();
                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                                        },
                                      ),
                                    ),
                                    Divider(),
                                    FlatButton(
                                      padding: EdgeInsets.all(0.0),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      child: ListTile(
                                        leading: Icon(Icons.settings),
                                        title: Text('Einstellungen'),
                                      ),
                                      onPressed: null,
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text('Datenschutzerklärung',
                                            textScaleFactor: 0.8,
                                          ),
                                          onPressed: null,
                                        ),
                                        IconButton(
                                          icon: FlutterLogo(),
                                          onPressed: null,
                                        ),
                                        FlatButton(
                                          child: Text('Nutzungsbedingungen',
                                            textScaleFactor: 0.8,
                                          ),
                                          onPressed: null,
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }
                            ),
                          );
                        }
                        else return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: body
          );
          break;
          
        case ConnectionState.none:
          return Text('Bad state :(');
          break;
      }
    },
  );
}