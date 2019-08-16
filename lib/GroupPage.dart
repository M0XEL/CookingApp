import 'package:CookingApp/GroupDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MyBottomNavigationBar.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<DocumentSnapshot> groups = List<DocumentSnapshot>();

  @override
  Widget build(BuildContext context) => FutureBuilder<FirebaseUser>(
    future: FirebaseAuth.instance.currentUser(),
    builder: (context, user) {
      if (user.connectionState == ConnectionState.done) {
        return StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(user.data.uid).snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.active) {
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('groups').snapshots(),
                builder: (context, groupSnapshot) {
                  if (groupSnapshot.connectionState == ConnectionState.active) {
                    groups.clear();
                    groupSnapshot.data.documents.forEach((document) {
                      userSnapshot.data['groupIds'].forEach((id) {
                        if (document.documentID == id) {
                          groups.add(document);
                        }
                      });
                    });
                    return DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        bottomNavigationBar: MyBottomNavigationBar(index: 1),
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                          title: Text(groups.first['name']),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.group_add),
                              onPressed: null,
                            ),
                          ],
                          bottom: TabBar(
                            tabs: <Widget>[
                              Tab(
                                text: 'Abstimmung',
                              ),
                              Tab(
                                text: 'Chat',
                              ),
                            ],
                          ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          child: Icon(Icons.keyboard_arrow_up),
                          onPressed: () => showModalBottomSheet(//DraggableScrollSheet
                            context: context,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                            builder: (context) {
                              return ListView.builder(
                                itemCount: groups.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == groups.length) {
                                    return MaterialButton(
                                      child: ListTile(
                                        leading: Icon(Icons.add),
                                        title: Text('Neue Gruppe erstellen'),
                                      ),
                                      onPressed: () {
                                        Firestore.instance.collection('groups').add({'name': '-'}).then((groupReference) {
                                          Firestore.instance.runTransaction((transaction) async {
                                            transaction.set(groupReference, {
                                              'name': 'Neue Gruppe',
                                              'memberIds': [userSnapshot.data.documentID],
                                            });
                                          });
                                          Firestore.instance.runTransaction((transaction) async {
                                            DocumentSnapshot freshUserSnapshot = await transaction.get(userSnapshot.data.reference);
                                            List<String> groupIds = List<String>();
                                            groupIds.addAll(freshUserSnapshot['groupIds'].cast<String>());
                                            groupIds.add(groupReference.documentID);
                                            transaction.update(userSnapshot.data.reference, {'groupIds': groupIds});
                                          });
                                        });
                                        
                                      }
                                    );
                                  }
                                  else {
                                    return ListTile(
                                      leading: FlutterLogo(),
                                      title: Text(groups[index]['name']),
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => GroupDetailPage(groups[index]))),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        body: TabBarView(
                          children: <Widget>[
                            Text('Abstimmungen :)'),
                            ListView.builder(
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Chip(
                                  label: Text('data'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  else return Center(child: CircularProgressIndicator());
                },
              );
            }
            else return Center(child: CircularProgressIndicator());
          }
        );
      }
      else return Center(child: CircularProgressIndicator());
    }
  );
}