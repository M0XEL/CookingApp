import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'PreparationCard.dart';
import 'IngredientCard.dart';
import 'package:CookingApp/services/firestore_add_recipe_to_group.dart';

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
                expandedHeight: MediaQuery.of(context).size.width * (9/16),
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
                    future: Firestore.instance.collection('recipes').document(recipeId).get(),
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

                          return Text(snapshot.data['name'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                          break;

                        case ConnectionState.none:
                          break;
                      }
                      return Container();
                    },
                  ),
                  background: FutureBuilder(
                    future: Firestore.instance.collection('recipes').document(recipeId).get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: snapshot.data['imageUrl'] != null ? NetworkImage(snapshot.data['imageUrl']) : AssetImage('images/pizza.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  buildButtonCard(),
                  IngredientCard(recipeId),
                  //buildNutritionInfoCard(),
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
          onPressed: () => showGroupSelection()
        ),
      ],
    ),
  );

  showGroupSelection() => FirebaseAuth.instance.currentUser().then((user) {
    Firestore.instance.collection('users').document(user.uid).get().then((user) {
      List<String> groupIds = user.data['groupIds'] != null ? user.data['groupIds'].cast<String>() : [];
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
                return SimpleDialog(
                  title: Text('Gruppe auswählen'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  children: <Widget>[
                    Container(
                      height: groups.length < 5 ? groups.length * 64.0 : 320.0,
                      width: 100,
                      child: ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          return MaterialButton(
                            child: ListTile(
                              title: Text(groups[index].data['name'] != null ? groups[index].data['name'] : []),
                            ),
                            onPressed: () {
                              addRecipeToGroup(recipeId, groups[index]);
                              Navigator.pop(context);
                            }
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              else return Center(child: CircularProgressIndicator());
            },
          );
        }
      );
    });
  });

  buildNutritionInfoCard() {
    return Card(
      child: Column(
        children: <Widget>[
          buildCardHeadline('Nährwerte'),
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