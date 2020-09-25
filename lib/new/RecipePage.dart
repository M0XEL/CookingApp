import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildMealList();
  }

  Widget _buildMealList() {
    return FutureBuilder(
      future: Firestore.instance.collection('recipes').getDocuments(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> recipes = snapshot.data.documents;
            return _buildMealGroup(recipes);
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildMealGroup(List<DocumentSnapshot> recipes) {
    return Container(
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text('Headline'),
              _buildCardList(recipes),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardList(List<DocumentSnapshot> recipes) {
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return _buildCard(recipes[index]);
        },
      ),
    );
  }

  Widget _buildCard(DocumentSnapshot recipe) {
    return Card(
      child: Container(
        height: 300,
        width: 300,
        child: Text(recipe['name']),
      ),
    );
  }
}
