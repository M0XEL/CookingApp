import 'package:CookingApp/PreparationCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                      print(snapshot);
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
          onPressed: null,
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