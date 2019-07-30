import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class PreparationCard extends StatefulWidget {
  final recipeId;
  PreparationCard(this.recipeId);

  @override
  _PreparationCardState createState() => _PreparationCardState(recipeId);
}

class _PreparationCardState extends State<PreparationCard> {
  String recipeId = '';
  List<String> steps = List<String>();

  _PreparationCardState(this.recipeId);

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        buildCardHeadline('Preparation'),
        FutureBuilder(
          future: Firestore.instance.collection('recipes').getDocuments(),
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
                DocumentSnapshot document2 = snapshot.data.documents.firstWhere((document) {
                  return document.documentID == recipeId;
                });
                steps = document2['steps'].cast<String>();

                List<Widget> preparationList = List<Widget>();
                for (int i = 0; i < steps.length; i++) {
                  preparationList.add(
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
                    )
                  );
                }

                return Column(
                  children: preparationList,
                );
                break;

              case ConnectionState.none:
                return Center(child: Text('Bad state :('));
                break;
            }
          },
        ),
      ],
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