import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<String> steps = List<String>();

  _RecipePageState(this.recipeId) {
    Firestore.instance.collection('recipes').document(recipeId).get().then((document) {
      recipeName = document['name'];
    });
  }

  buildIngredientColumn() {
    List<Widget> ingredientList = List<Widget>();
    ingredients.forEach((ingredient) {
      ingredientList.add(
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 8.0),
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(ingredient.amount.toString(),
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
      //ingredientList.add(Divider());
    });
    return Column(
      children: ingredientList,
    );
  }

  buildSteps() {
    List<Widget> stepsList = List<Widget>();
    for (int i = 0; i < steps.length; i++) {
      stepsList.add(
        ListTile(
          leading: Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Center(
              child: Text(i.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: Text(steps[i]),
          //subtitle: Container(height: 8.0),
        )
      );
    }
    return Column(
      children: stepsList,
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
              Firestore.instance.collection('recipes').getDocuments(),
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
                  var d5 = snapshot.data[2].documents.firstWhere((d4) {
                    return d4.documentID == recipeId;
                  });
                  steps = d5['steps'].cast<String>();
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
                          Card(
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
                                  onPressed: null,
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(width: 40.0),
                                  title: Text('Ingredients',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.4,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                ),
                                buildIngredientColumn(),
                                ListTile(
                                  leading: Container(width: 40),
                                  title: Row(
                                    children: <Widget>[
                                      Text('for'),
                                      Text(' - 2 + '),
                                      Text('servings'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: Container(width: 40.0),
                              title: Text('Nutrition Info',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.4,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(width: 40.0),
                                  title: Text('Preparation',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.4,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                ),
                                buildSteps(),
                              ],
                            ),
                          ),
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