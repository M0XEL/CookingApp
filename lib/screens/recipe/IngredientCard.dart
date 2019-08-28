import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class Ingredient {
  String name;
  int amount;
}

class IngredientCard extends StatefulWidget {
  final recipeId;
  IngredientCard(this.recipeId);

  @override
  _IngredientCardState createState() => _IngredientCardState(recipeId);
}

class _IngredientCardState extends State<IngredientCard> {
  String recipeId = '';
  int servings = 0;
  List<Ingredient> ingredients = List<Ingredient>();

  _IngredientCardState(this.recipeId);

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        buildCardHeadline('Zutaten'),
        FutureBuilder(
          future: Future.wait([
            Firestore.instance.collection('recipes').document(recipeId).collection('ingredients').getDocuments(),
            Firestore.instance.collection('ingredients').getDocuments(),
            Firestore.instance.collection('recipes').getDocuments(),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:

              case ConnectionState.waiting:
                return Container(
                  height: 100.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                break;

              case ConnectionState.done:
                if (snapshot.data[0].documents.length == 0) {
                  return Container();
                }
                else {
                  ingredients.clear();
                  snapshot.data[0].documents.forEach((document) {
                    Ingredient ingredient = Ingredient();
                    ingredient.amount = document['amount'];
                    DocumentSnapshot document3 = snapshot.data[1].documents.firstWhere((document2) {
                      return document2.documentID == document['ingredientId'];
                    });
                    ingredient.name = document3['name'];
                    ingredients.add(ingredient);
                  });
                  if (servings == 0) {
                    DocumentSnapshot document5 = snapshot.data[2].documents.firstWhere((document4) {
                      return document4.documentID == recipeId;
                    });
                    servings = document5['servings'];
                  }

                  List<Widget> ingredientList = List<Widget>();
                  ingredients.forEach((ingredient) {
                    ingredientList.add(
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 8.0),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text((servings * ingredient.amount).toString() + 'g',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(ingredient.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    ingredientList.add(Container(height: 8.0));
                  });

                  return Column(
                    children: <Widget>[
                      Column(
                        children: ingredientList,
                      ),
                      ListTile(
                        leading: Container(width: 40),
                        title: Row(
                          children: <Widget>[
                            buildText('für'),
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.orangeAccent),
                              onPressed: () => setState(() => servings > 1 ? servings-- : servings),
                            ),
                            Container(
                              child: buildText(servings.toString()),
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.orangeAccent),
                              onPressed: () => setState(() => servings++),
                            ),
                            buildText('Portionen'),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                break;

              case ConnectionState.none:
                return Center(child: Text('Bad state :('));
                break;
            }
            return Container();
          },
        ),
      ],
    ),
  );

  buildText(String text) => Text(text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 1.4,
    ),
  );

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
}