import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String userId;

  _ShoppingPageState() {
    SharedPreferences.getInstance().then((_sharedPreferences) {
      userId = _sharedPreferences.getString('userId');
      Firestore.instance.collection('users').document(userId).setData({'name': 'James'});
      Firestore.instance.collection('users').document(userId).collection('shopping_card').document('pasta').setData({'name': 'pasta', 'liked': true});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    bottomNavigationBar: MyBottomNavigationBar(index: 1),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: null,
    ),
    body: StreamBuilder<QuerySnapshot>(
      //stream: Firestore.instance.collection('Rezepte').snapshots(),
      stream: Firestore.instance.collection('users').document(userId).collection('shopping_card').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        if (snapshot.data.documents.isEmpty) return CircularProgressIndicator();

        if (snapshot.data.documents.isNotEmpty) {
          return Text("snapshot.data.documents[0]['name']");
        }
        /*var list = snapshot.data.documents;
        return ListView(
          children: list.map((data) => _buildListTile(data, context)).toList(),
        );*/
      },
    ),
  );



  Widget _buildListTile(DocumentSnapshot data, BuildContext context) => ListTile(
    leading: FlutterLogo(),
    title: Text(data['name']),
    trailing: IconButton(
      icon: data['liked'] ? Icon(Icons.check, color: Colors.green) : Icon(Icons.check),
      onPressed:() =>  Firestore.instance.runTransaction((transaction) async {
        try {
          final freshSnapshot = await transaction.get(data.reference);
          await transaction.update(data.reference, {'liked': freshSnapshot.data['liked'] ? false : true});
        }
        catch(e) {
          print(e);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('No internet connection'),));
        }
      }),
    ),
  );
}

