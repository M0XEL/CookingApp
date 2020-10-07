import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:CookingApp/screens/recipe/RecipePage.dart';
import 'package:CookingApp/components/MyBottomNavigationBar.dart';
import 'package:CookingApp/new/LoginPage.dart';
import 'package:CookingApp/screens/search/RecipeCard.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

enum BodyType { trending, filter, categorie, recipe }

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
  String recipeType = '';
  bool isHighCarb = false;
  bool isVegetarian = false;
  bool isMeat = false;
  bool searchViaText = true; // false -> via filter
  List<DocumentSnapshot> recipesByFilter = List<DocumentSnapshot>();

  changeSearchResults(String string) {
    if (string.isNotEmpty) {
      List<String> newList = List<String>();
      completeList.forEach((item) {
        if (item.toLowerCase().contains(string.toLowerCase())) {
          newList.add(item);
        }
      });
      setState(() {
        displayList.clear();
        displayList.addAll(newList);
        bodyType = BodyType.categorie;
      });
    } else {
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
                completeList =
                    snapshot.data[0].documents.first['names'].cast<String>();
                displayList.addAll(completeList);
                initList = false;
              }

              switch (bodyType) {
                case BodyType.trending:
                  body = Scaffold(
                    bottomNavigationBar: MyBottomNavigationBar(index: 0),
                    body: StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('recipes').snapshots(),
                      builder: (context, snapshot1) {
                        if (!snapshot1.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<DocumentSnapshot> recipes =
                              snapshot1.data.documents;
                          return Container(
                            child: Stack(
                              children: <Widget>[
                                ListView.builder(
                                    itemCount: recipes.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == 0) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              top: 16.0,
                                              bottom: 16.0,
                                              left: 16.0),
                                          child: Text(
                                            'Beliebt',
                                            style: TextStyle(
                                                fontSize: 32.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.5),
                                          ),
                                        );
                                      } else {
                                        index--;
                                        return MaterialButton(
                                          padding: EdgeInsets.all(0.0),
                                          child: buildRecipeCard(
                                              context, recipes[index]),
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      RecipePage(recipes[index]
                                                          .documentID))),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  );
                  break;

                case BodyType.filter:
                  body = Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 52.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  color: recipeType == 'normal'
                                      ? Colors.orangeAccent
                                      : null,
                                  child: MaterialButton(
                                    child: Text('Gerichte'),
                                    onPressed: () => setState(() => recipeType =
                                        recipeType == 'normal' ? '' : 'normal'),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: recipeType == '2'
                                        ? Colors.orangeAccent
                                        : null,
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey[300],
                                        width: 0.5,
                                      ),
                                      right: BorderSide(
                                        color: Colors.grey[300],
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  height: 52.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: MaterialButton(
                                    child: Text('Desserts'),
                                    onPressed: () => setState(() => recipeType =
                                        recipeType == '2' ? '' : '2'),
                                  ),
                                ),
                                Container(
                                  height: 52.0,
                                  width: MediaQuery.of(context).size.width / 3,
                                  color: recipeType == '3'
                                      ? Colors.orangeAccent
                                      : null,
                                  child: MaterialButton(
                                    child: Text('Getränke'),
                                    onPressed: () => setState(() => recipeType =
                                        recipeType == '3' ? '' : '3'),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 0),
                            Row(
                              children: <Widget>[
                                MaterialButton(
                                  child: Chip(
                                    backgroundColor:
                                        isHighCarb ? Colors.orangeAccent : null,
                                    label: Text('High Carb'),
                                  ),
                                  onPressed: () => setState(() =>
                                      isHighCarb = isHighCarb ? false : true),
                                ),
                                MaterialButton(
                                  child: Chip(
                                    backgroundColor: isVegetarian
                                        ? Colors.orangeAccent
                                        : null,
                                    label: Text('Vegetarisch'),
                                  ),
                                  onPressed: () => setState(() => isVegetarian =
                                      isVegetarian ? false : true),
                                ),
                                MaterialButton(
                                  child: Chip(
                                    backgroundColor:
                                        isMeat ? Colors.orangeAccent : null,
                                    label: Text('Fleisch'),
                                  ),
                                  onPressed: () => setState(
                                      () => isMeat = isMeat ? false : true),
                                ),
                              ],
                            ),
                            Container(
                              height: 100.0,
                              alignment: Alignment.center,
                              child: Text('Weitere Filter in Entwicklung'),
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8.0),
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Center(
                            child: Text(
                              'SUCHEN',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          List<DocumentSnapshot> oldList =
                              List<DocumentSnapshot>();
                          List<DocumentSnapshot> newList =
                              List<DocumentSnapshot>();

                          QuerySnapshot result = await Firestore.instance
                              .collection('recipes')
                              .getDocuments();
                          newList.addAll(result.documents);

                          /// search type
                          if (recipeType != '') {
                            result = await Firestore.instance
                                .collection('recipes')
                                .where('type', isEqualTo: recipeType)
                                .getDocuments();
                            newList.clear();
                            newList.addAll(result.documents);
                          }

                          /// search filter: high carb
                          if (isHighCarb) {
                            QuerySnapshot result = await Firestore.instance
                                .collection('recipes')
                                .where('filter', arrayContains: 'high_carb')
                                .getDocuments();

                            oldList.clear();
                            oldList.addAll(newList);
                            newList.clear();

                            oldList.forEach((query1) {
                              result.documents.forEach((query2) {
                                if (query1.documentID == query2.documentID) {
                                  newList.add(query1);
                                }
                              });
                            });
                          }

                          /// search filter: vegetarian
                          if (isVegetarian) {
                            result = await Firestore.instance
                                .collection('recipes')
                                .where('filter', arrayContains: 'vegetarian')
                                .getDocuments();

                            oldList.clear();
                            oldList.addAll(newList);
                            newList.clear();

                            oldList.forEach((query1) {
                              result.documents.forEach((query2) {
                                if (query1.documentID == query2.documentID) {
                                  newList.add(query1);
                                }
                              });
                            });
                          }

                          /// search filter: meat
                          if (isMeat) {
                            result = await Firestore.instance
                                .collection('recipes')
                                .where('filter', arrayContains: 'meat')
                                .getDocuments();

                            oldList.clear();
                            oldList.addAll(newList);
                            newList.clear();

                            oldList.forEach((query1) {
                              result.documents.forEach((query2) {
                                if (query1.documentID == query2.documentID) {
                                  newList.add(query1);
                                }
                              });
                            });
                          }

                          setState(() {
                            recipesByFilter.clear();
                            recipesByFilter.addAll(newList);
                            bodyType = BodyType.recipe;
                            searchViaText = false;
                          });
                        },
                      ),
                    ],
                  );
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
                          searchViaText = true;
                        }),
                      );
                    },
                  );
                  break;

                case BodyType.recipe:
                  List<DocumentSnapshot> recipes = List<DocumentSnapshot>();

                  if (searchViaText) {
                    recipes.clear();
                    snapshot.data[1].documents.forEach((document) {
                      if (document['categorie'] != null) {
                        if (document['categorie'].toLowerCase() ==
                            searchString.toLowerCase()) {
                          recipes.add(document);
                        }
                      }
                    });
                    if (recipes.isEmpty) {
                      snapshot.data[1].documents.forEach((document) {
                        if (document['name']
                            .toLowerCase()
                            .contains(searchString.toLowerCase())) {
                          recipes.add(document);
                        }
                      });
                    }
                  } else {
                    recipes.clear();
                    recipes.addAll(recipesByFilter);
                  }

                  if (recipes.isEmpty) {
                    body = Center(
                      child: Text('Keine passenden Rezepte gefunden :('),
                    );
                  } else {
                    body = ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MaterialButton(
                          padding: EdgeInsets.all(0.0),
                          child: buildRecipeCard(context, recipes[index]),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RecipePage(recipes[index].documentID))),
                        );
                      },
                    );
                  }
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
                              onChanged: (string) =>
                                  changeSearchResults(string),
                              onSubmitted: (string) => setState(() {
                                bodyType = BodyType.recipe;
                                searchString = string;
                                searchViaText = true;
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
                                }),
                          ),
                          FutureBuilder<FirebaseUser>(
                            future: FirebaseAuth.instance.currentUser(),
                            builder: (context, user) {
                              if (user.connectionState ==
                                  ConnectionState.done) {
                                return IconButton(
                                  icon: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.data.photoUrl),
                                  ),
                                  onPressed: () => showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ListView(
                                          children: <Widget>[
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    user.data.photoUrl),
                                              ),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(user.data.displayName),
                                                  Text(
                                                    user.data.email,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: FlatButton(
                                                child: Text('Abmelden'),
                                                onPressed: () {
                                                  FirebaseAuth.instance
                                                      .signOut();
                                                  GoogleSignIn().signOut();
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              LoginPage()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                },
                                              ),
                                            ),
                                            Divider(),
                                            FlatButton(
                                              padding: EdgeInsets.all(0.0),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              child: ListTile(
                                                leading: Icon(Icons.settings),
                                                title: Text('Einstellungen'),
                                              ),
                                              onPressed: null,
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Datenschutzerklärung',
                                                    textScaleFactor: 0.8,
                                                  ),
                                                  onPressed: null,
                                                ),
                                                IconButton(
                                                  icon: FlutterLogo(),
                                                  onPressed: null,
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    'Nutzungsbedingungen',
                                                    textScaleFactor: 0.8,
                                                  ),
                                                  onPressed: null,
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }),
                                );
                              } else
                                return CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: body);
              break;

            case ConnectionState.none:
              return Text('Bad state :(');
              break;
          }
          return Container();
        },
      );
}
