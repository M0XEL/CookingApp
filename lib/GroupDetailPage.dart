import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDetailPage extends StatefulWidget {
  DocumentSnapshot group;
  GroupDetailPage(this.group);
  @override
  _GroupDetailPageState createState() => _GroupDetailPageState(group);
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  DocumentSnapshot group;
  List<String> member;
  _GroupDetailPageState(this.group);
  @override
  Widget build(BuildContext context) {
    List<String> memberIds = group['memberIds'].cast<String>();

    return Scaffold(
      appBar: AppBar(
        title:Text(group['name']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller = TextEditingController();
                controller.text = 'ernijo67@gmail.com';

                return Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: controller,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text('Apply'),
                            onPressed: () {
                              Firestore.instance.collection('users').getDocuments().then((users) {
                                DocumentSnapshot user = users.documents.firstWhere((user) => user['emailAddress'] == controller.text);
                                addUser(user);
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
                        removeUser(snapshot.data);
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
    
  addUser(DocumentSnapshot user) {
    Firestore.instance.runTransaction((transaction) async {
      try {
        DocumentSnapshot freshUserSnapshot = await transaction.get(user.reference);
        List<String> groupIds = List<String>();
        groupIds.addAll(freshUserSnapshot['groupIds'].cast<String>());
        if (groupIds.any((id) => id == group.documentID)) {
          transaction.update(user.reference, {'groupIds': groupIds});
        }
        else {
          groupIds.add(group.documentID);
          transaction.update(user.reference, {'groupIds': groupIds});
        }
      }
      catch(e) {
        print(e);
      }
    });
    Firestore.instance.runTransaction((transaction) async {
      try {
        DocumentSnapshot freshGroupSnapshot = await transaction.get(group.reference);
        List<String> memberIds = List<String>();
        memberIds.addAll(freshGroupSnapshot['memberIds'].cast<String>());
        if (memberIds.any((id) => id == user.documentID)) {
          transaction.update(group.reference, {'memberIds': memberIds});
        }
        else {
          memberIds.add(user.documentID);
          transaction.update(group.reference, {'memberIds': memberIds});
        }
      }
      catch(e) {
        print(e);
      }
    });
  }

  removeUser(DocumentSnapshot member) {
    Firestore.instance.runTransaction((transaction) async {
      try {
        DocumentSnapshot freshUserSnapshot = await transaction.get(member.reference);
        List<String> groupIds = List<String>();
        groupIds.addAll(freshUserSnapshot['groupIds'].cast<String>());
        if (groupIds.any((id) => id == group.documentID)) {
          groupIds.removeWhere((id) => id == group.documentID);
          transaction.update(member.reference, {'groupIds': groupIds});
        }
        else {
          transaction.update(member.reference, {'groupIds': groupIds});
        }
      }
      catch(e) {
        print(e);
      }
    });
    Firestore.instance.runTransaction((transaction) async {
      try {
        DocumentSnapshot freshGroupSnapshot = await transaction.get(group.reference);
        List<String> memberIds = List<String>();
        memberIds.addAll(freshGroupSnapshot['memberIds'].cast<String>());
        if (memberIds.any((id) => id == member.documentID)) {
          memberIds.removeWhere((id) => id == member.documentID);
          if (memberIds.isEmpty) {
            transaction.delete(group.reference);
          }
          else {
            transaction.update(group.reference, {'memberIds': memberIds});
          }
        }
        else {
          transaction.update(group.reference, {'memberIds': memberIds});
        }
      }
      catch(e) {
        print(e);
      }
    });
  }
}