import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String recipeName;
  List<Ingredient> ingredients;

  _RecipePageState(this.recipeId) {
    Firestore.instance.collection('recipes').document(recipeId).get().then((document) {
      recipeName = document['name'];
    });
    Firestore.instance.collection('recipes').document(recipeId).collection('ingredients').getDocuments().then((documents) {
      documents.documents.forEach((document) {
        Ingredient ingredient;
        ingredient.amount = document.data['amount'];
        String id = document.data['id'];
        Firestore.instance.collection('ingredients').document(id).get().then((document) {
          ingredient.name = document['name'];
          ingredients.add(ingredient);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    body: Column(
        children: <Widget>[
          Expanded(
            child:
          CustomScrollView(
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
              title: Text('Pizza',
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
            ]),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index.isEven) {
                return Container(
                  child: Text('100g'),
                );
              } else {
                return Container(
                  child: Text('Teig'),
                );
              }
            },
            childCount: 4
            )//ingredients.length)
          ),
        ],
      ),),
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
      )
  );
}