import 'package:CookingApp/PreparationCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'IngredientCard.dart';
import 'PreparationCard.dart';

class RecipePage extends StatefulWidget {
  final String documentId;
  RecipePage(this.documentId);

  @override
  _RecipePageState createState() => _RecipePageState(documentId);
}


class _RecipePageState extends State<RecipePage> {
  final String recipeId;

  _RecipePageState(this.recipeId);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 195.0,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share,
                      color: Colors.white
                    ),
                    onPressed: null,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: FutureBuilder(
                    future: Firestore.instance.collection('recipes').getDocuments(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:

                        case ConnectionState.waiting:
                          return Text('Loading...',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                          break;

                        case ConnectionState.done:
                          DocumentSnapshot document2 = snapshot.data.documents.firstWhere((document) {
                            return document.documentID == recipeId;
                          });

                          return Text(document2['name'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                          break;

                        case ConnectionState.none:
                          break;
                      }
                    },
                  ),
                  background: Image.asset('images/pizza.jpg'),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  buildButtonCard(),
                  IngredientCard(recipeId),
                  buildNutritionInfoCard(),
                  PreparationCard(recipeId),
                ]),
              ),
            ],
          ),
        ),
        buildStartCookingButton(),
      ],
    ),
  );

  buildButtonCard() => Card(
    child: ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.book),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => FirebaseAuth.instance.currentUser().then((user) {
            Firestore.instance.collection('users').document(user.uid).get().then((user) {
              List<String> groupIds = user.data['groupIds'].cast<String>();
              print(groupIds);
              List<DocumentSnapshot> groups = List<DocumentSnapshot>();
              showDialog(
                context: context,
                builder: (context) {
                  return FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance.collection('groups').getDocuments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        groups.clear();
                        snapshot.data.documents.forEach((document) {
                          groupIds.forEach((id) {
                            if (document.documentID == id) {
                              groups.add(document);
                            }
                          });
                        });
                        print(groups);
                        return Material (
                          child: ListView.builder(
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              return MaterialButton(
                                child: ListTile(
                                  title: Text(groups[index].data['name']),
                                ),
                                onPressed: () => Firestore.instance.collection('recipe_votes').document(groups[index].documentID).collection('deadlines').document('today').get().then((document) {
                                  Firestore.instance.runTransaction((transaction) async {
                                    DocumentSnapshot freshSnapshot = await transaction.get(document.reference);
                                    Map<String, int> recipes = Map<String, int>();
                                    recipes.addAll(freshSnapshot['recipes'].cast<String, int>());
                                    List<MapEntry<String, int>> l = List<MapEntry<String, int>>();
                                    l.add(MapEntry(recipeId, 0));
                                    recipes.addEntries(l);
                                    transaction.update(document.reference, {'recipes': recipes});
                                  });
                                  Navigator.pop(context);
                                })
                              );
                            },
                          ),
                        );
                      }
                      else return Container();
                    },
                  );
                }
              );
              
              
              

              /*showDialog(
                context: context,
                builder: (context) => ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('data'),
                    );
                  },
                ),
              );*/
            });
          }),
        ),
      ],
    ),
  );

  buildNutritionInfoCard() {
    return Card(
      child: Column(
        children: <Widget>[
          buildCardHeadline('Nutrition Info'),
        ],
      )
    );
  }

  buildCardHeadline(String title) => ListTile(
    leading: Container(width: 40.0),
    title: Text(title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
        color: Colors.orangeAccent,
      ),
    ),
  );

  buildStartCookingButton() => Row(
    children: <Widget>[
      Expanded(
        child: Card(
          margin: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: Colors.lightGreen,
          child: MaterialButton(
            height: 56.0,
            child: Text('START COOKING',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            onPressed: null,
          ),
        ),
      ),
    ],
  );
}