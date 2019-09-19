import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget buildRecipeCard(BuildContext context, DocumentSnapshot recipe) => Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Container(
      height: MediaQuery.of(context).size.width * (9/16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(recipe.data['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: recipe.data['imageUrl'] != null ? NetworkImage(recipe.data['imageUrl']) : AssetImage('images/pizza.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
);