import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'RecipePage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

enum BodyType{filter, categorie, recipe}

class _SearchPageState extends State<SearchPage> {
  Future<List<QuerySnapshot>> future = Future.wait([
    Firestore.instance.collection('categories').getDocuments(),
    Firestore.instance.collection('recipes').getDocuments(),
  ]);
  List<String> completeList = List<String>();
  List<String> displayList = List<String>();
  bool initList = true;
  TextEditingController textEditingController = TextEditingController();
  BodyType bodyType = BodyType.filter;
  String searchString = '';
  Widget body = Container();

  changeSearchResults(string) {
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
                            ),
                          ],
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
                onPressed: () => Navigator.of(context).pop(),
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
                        autofocus: true,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
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