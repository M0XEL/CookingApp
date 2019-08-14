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
                          child: Icon(Icons.list),
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ListView.builder(
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: FlutterLogo(),
                                    title: Text(groups[index]['name']),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: null,
                                    ),
                                  );
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
  
  
  
  
  
  
  
  
  
  
  
  
  /*Scaffold(
    bottomNavigationBar: MyBottomNavigationBar(index: 1),
    body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(snapshot.data.documents[index]['photoUrl']),
                title: FlatButton(
                  child: Text(snapshot.data.documents[index]['name']),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage())),
                ),
              );
            },
          );
        }
        else return CircularProgressIndicator();
      },
    ),
  );*/
}