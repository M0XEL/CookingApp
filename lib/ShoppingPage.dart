import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: MyDrawer(),
    bottomNavigationBar: MyBottomNavigationBar(index: 1),
    body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Rezepte').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        var list = snapshot.data.documents;
        return ListView(
          children: list.map((data) => _buildListTile(data, context)).toList(),
        );
      },
    ),
  );



  Widget _buildListTile(DocumentSnapshot data, BuildContext context) => ListTile(
    leading: FlutterLogo(),
    title: Text(data['Name']),
    trailing: IconButton(
      icon: data['Lecker'] ? Icon(Icons.check, color: Colors.green) : Icon(Icons.check),
      onPressed:() =>  Firestore.instance.runTransaction((transaction) async {
        try {
          final freshSnapshot = await transaction.get(data.reference);
          await transaction.update(data.reference, {'Lecker': freshSnapshot.data['Lecker'] ? false : true});
        }
        catch(e) {
          print(e);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('No internet connection'),));
        }
      }),
    ),
  );
}

