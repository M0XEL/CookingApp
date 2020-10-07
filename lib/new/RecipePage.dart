import 'package:CookingApp/new/RecipeDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildCategoryGroup(context, 'trend'),
        _buildCategoryGroup(context, 'health'),
        _buildCategoryGroup(context, 'protein')
      ],
    );
  }

  Widget _buildCategoryGroup(BuildContext context, String type) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton(
              padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
              onPressed: () => print(type + ' pressed'),
              child: Row(
                children: [
                  Text(type, style: Theme.of(context).textTheme.headline4),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_forward),
                ],
              )),
          FutureBuilder(
            future: Firestore.instance
                .collection('recipes')
                .where('type', isEqualTo: type)
                .getDocuments(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Container(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return _buildCard(
                            context, snapshot.data.documents[index]);
                      },
                    ),
                  );
                }
              }
              return Container(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, DocumentSnapshot recipe) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return RecipeDetailPage();
        }));
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          height: 300,
          width: 300,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.bottomLeft,
          child: Text(
            recipe['name'],
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
