import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'MyDrawer.dart';

class RecipePage extends StatefulWidget {
  final String documentId;
  RecipePage(this.documentId);

  @override
  _RecipePageState createState() => _RecipePageState(documentId);
}

class Ingredient {
  String name;
  int amount;
}

class _RecipePageState extends State<RecipePage> {
  final String recipeId;
  String recipeName = '';
  List<Ingredient> ingredients = List<Ingredient>();
  Future<List<Ingredient>> i;

  _RecipePageState(this.recipeId) {
    Firestore.instance.collection('recipes').document(recipeId).get().then((document) {
      recipeName = document['name'];
    });
  }

  buildIngredientColumn() {
    List<Widget> ingredientList = List<Widget>();
    ingredients.forEach((ingredient) {
      ingredientList.add(Row(
        children: <Widget>[
          Text(ingredient.amount.toString()),
          Text(ingredient.name),
        ],
      ));
    });
    return Column(
      children: ingredientList,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List<QuerySnapshot>>(
            future: Future.wait([
              Firestore.instance.collection('recipes').document(recipeId).collection('ingredients').getDocuments(),
              Firestore.instance.collection('ingredients').getDocuments(),
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) { 
                if (snapshot.hasData) {
                  snapshot.data[0].documents.forEach((document) {
                    Ingredient ingredient = Ingredient();
                    ingredient.amount = document['amount'];
                    String ingredientId = document.data['ingredientId'];
                    var d = snapshot.data[1].documents.firstWhere((document2) {
                      return document2.documentID == ingredientId;
                    });
                    ingredient.name = d.data['name'];
                    ingredients.add(ingredient);
                  });
                  return CustomScrollView(
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
                          title: Text(recipeName,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          background: Image.asset('images/pizza.jpg'),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ButtonBar(
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
                                onPressed: null,
                              ),
                            ],
                          ),
                          buildIngredientColumn(),
                        ]),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
        Row(
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
        ),
      ],
    ),
  );
}