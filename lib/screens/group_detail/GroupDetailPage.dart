import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:CookingApp/services/firestore_change_group_name.dart';
import 'package:CookingApp/services/firestore_add_user_to_group.dart';
import 'package:CookingApp/services/firestore_remove_user_from_group.dart';

class GroupDetailPage extends StatefulWidget {
  final DocumentReference groupReference;
  GroupDetailPage(this.groupReference);
  @override
  _GroupDetailPageState createState() => _GroupDetailPageState(groupReference);
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  _GroupDetailPageState(this.groupReference);
  DocumentReference groupReference;
  DocumentSnapshot group;
  List<String> member;
  Stream stream;

  @override
  Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance.collection('groups').document(groupReference.documentID).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active && snapshot.hasData && snapshot.data.exists) {
        group = snapshot.data;
        List<String> memberIds = group['memberIds'] == null ? [] : group['memberIds'].cast<String>();
        String groupName = '';
        if (group['name'] != null) groupName = group['name'];
        return Scaffold(
          appBar: AppBar(
            title: Text(groupName),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    controller.text = group['name'] ?? '';
                    return SimpleDialog(
                      title: Text('Gruppennamen ändern'),
                      contentPadding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          controller: controller,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text('Schließen'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                changeGroupName(group.reference, controller.text);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ),
              IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    return SimpleDialog(
                      title: Text('Teilnehmer hinzufügen'),
                      contentPadding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: controller,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'email',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text('Schließen'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Firestore.instance.collection('users').getDocuments().then((users) {
                                  DocumentSnapshot user = users.documents.firstWhere((user) => user['emailAddress'] == controller.text);
                                  addUserToGroup(user, group);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              )
            ],
          ),
          body: ListView.builder(
            itemCount: memberIds.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: FutureBuilder<DocumentSnapshot>(
                  future: Firestore.instance.collection('users').document(memberIds[index]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListTile(
                        title: Text(snapshot.data['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            removeUserFromGroup(snapshot.data, group, context);
                          },
                        ),
                      );
                    }
                    else return Text('Loading...');
                  },
                ),
              );
            },
          )
        );
      }
      else {
        return Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    },
  );
}