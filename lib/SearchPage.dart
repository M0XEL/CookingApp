import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

enum BodyType{filter, categorie, recipe}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> future = Firestore.instance.collection('categories').getDocuments();
  List<String> completeList = List<String>();
  List<String> displayList = List<String>();
  bool initList = true;
  TextEditingController textEditingController = TextEditingController();
  BodyType bodyType = BodyType.filter;
  String searchString = '';

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
  Widget build(BuildContext context) => FutureBuilder<QuerySnapshot>(
    future: future,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
          break;

        case ConnectionState.done:
          if (initList) {
            completeList = snapshot.data.documents.first['names'].cast<String>();
            displayList.addAll(completeList);
            initList = false;
          }

          Widget filterList = Text('Place for filters');

          Widget categorieList = ListView.builder(
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

          Widget recipeList = ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Text(searchString);
            },
          );

          Widget body = filterList;

          switch (bodyType) {
            case BodyType.filter:
              body = filterList;
              break;

            case BodyType.categorie:
              body = categorieList;
              break;

            case BodyType.recipe:
              body = recipeList;
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