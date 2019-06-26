import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'MyDrawer.dart';

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
    drawer: MyDrawer(),
    body: Stack(children: <Widget>[
    NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool a) {
        return <Widget>[
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
        ];
      },
      body: Column(
        children: <Widget>[
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
          )
        ],
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: Container()),
        Card(
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
      ],
    )
    ],
    ),
  );
}