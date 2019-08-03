import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> future = Firestore.instance.collection('categories').getDocuments();
  List<String> completeList = List<String>();
  List<String> displayList = List<String>();
  bool initList = true;

  @override
  Widget build(BuildContext context) => FutureBuilder<QuerySnapshot>(
    future: future,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
          break;

        case ConnectionState.done:
          if (initList) {
            completeList = snapshot.data.documents.first['names'].cast<String>();
            displayList.addAll(completeList);
            initList = false;
          }

          return Scaffold(
            appBar: AppBar(
              title: TextField(
                onChanged: (string) {
                  if (string.isNotEmpty) {
                    List<String> newList = List<String>();
                    completeList.forEach((item) {
                      if (item.contains(string)) {
                        newList.add(item);
                      }
                    });
                    setState(() {
                      displayList.clear();
                      displayList.addAll(newList);
                    });
                  } 
                  else {
                    setState(() {
                      displayList.clear();
                      displayList.addAll(completeList); 
                    });
                  }
                },
              ),
            ),
            body: ListView.builder(
             itemCount: displayList.length,
             itemBuilder: (context, index) {
               return ListTile(
                 title: Text(displayList[index]),
               );
             },
            ),
          );
          break;
          
        case ConnectionState.none:
          return Text('Bad state :(');
          break;
      }
    },
  );
}