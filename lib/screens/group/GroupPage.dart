import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:CookingApp/screens/recipe/RecipePage.dart';
import 'package:CookingApp/screens/group_detail/GroupDetailPage.dart';
import 'package:CookingApp/components/MyBottomNavigationBar.dart';
import 'package:CookingApp/services/firestore_vote.dart';
import 'package:CookingApp/services/firestore_add_group.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  FirebaseUser firebaseUser;
  List<DocumentSnapshot> groups = List<DocumentSnapshot>();
  DocumentSnapshot selectedGroup;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          firebaseUser = snapshot.data;
          return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(firebaseUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ??
                  snapshot.hasData) {
                DocumentSnapshot user = snapshot.data;
                List<String> groupIds = user.data['groupIds'] != null
                    ? user.data['groupIds'].cast<String>()
                    : [];
                Future future = Future(() async {
                  if (groupIds.isEmpty) {
                    selectedGroup = await Firestore.instance
                        .collection('info')
                        .document('no_group')
                        .get();
                  } else {
                    groups.clear();
                    await Future.forEach(
                        groupIds,
                        (id) => Firestore.instance
                            .collection('groups')
                            .document(id)
                            .get()
                            .then((group) => groups.add(group)));
                    selectedGroup ?? groups.first;
                  }
                });

                return FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (selectedGroup == null) selectedGroup = groups.first;
                      return DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          bottomNavigationBar: MyBottomNavigationBar(index: 1),
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            centerTitle: true,
                            title: Text(selectedGroup['name']),
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
                              onPressed: () => showGroupSelectionSheet(user)),
                          body: TabBarView(
                            children: <Widget>[
                              buildVotingPage(firebaseUser),
                              buildChatPage(),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Material(
                          child: Center(child: CircularProgressIndicator()));
                  },
                );
              } else
                return Material(
                    child: Center(child: CircularProgressIndicator()));
            },
          );
        } else
          return Material(child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  buildVotingPage(FirebaseUser user) => StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('recipe_votes')
            .document(selectedGroup.documentID)
            .collection('deadlines')
            .document('today')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data.exists) {
              Map<String, num> recipeIds = snapshot.data.data['recipes'] != null
                  ? snapshot.data.data['recipes'].cast<String, num>()
                  : [];
              return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('recipes').snapshots(),
                  builder: (context, snapshot1) {
                    if (!snapshot1.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<DocumentSnapshot> recipes = List<DocumentSnapshot>();
                      snapshot1.data.documents.forEach((d) {
                        recipeIds.keys.forEach((key) {
                          if (d.documentID == key) {
                            recipes.add(d);
                          }
                        });
                      });
                      return Container(
                        child: Stack(
                          children: <Widget>[
                            ListView.builder(
                                itemCount: recipes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MaterialButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (9 / 16),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.0,
                                                            vertical: 8.0),
                                                    child: Text(
                                                      recipes[index].data[
                                                                  'name'] !=
                                                              null
                                                          ? recipes[index]
                                                              .data['name']
                                                          : '',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          100, 0, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                32.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                32.0),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      16.0),
                                                          child: Text(
                                                            recipeIds[recipes[
                                                                        index]
                                                                    .documentID]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 24.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            icon: Icon(
                                                                Icons.thumb_up,
                                                                color: Colors
                                                                    .green),
                                                            onPressed: () => vote(
                                                                snapshot.data
                                                                    .reference,
                                                                recipes[index]
                                                                    .documentID)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: recipes[index]
                                                          .data['imageUrl'] !=
                                                      null
                                                  ? NetworkImage(recipes[index]
                                                      .data['imageUrl'])
                                                  : AssetImage(
                                                      'images/pizza.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                RecipePage(recipes[index]
                                                    .documentID))),
                                  );
                                }),
                          ],
                        ),
                      );
                    }
                  });
            } else
              return Center(
                child: Text('Keine Abstimmung verfügbar'),
              );
          } else
            return Center(child: CircularProgressIndicator());
        },
      );

  buildChatPage() => ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Chip(
            label: Text('In Entwicklung'),
          );
        },
      );

  showGroupSelectionSheet(DocumentSnapshot user) => showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        builder: (context) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(firebaseUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                DocumentSnapshot user = snapshot.data;
                List<String> groupIds = user.data['groupIds'] != null
                    ? user.data['groupIds'].cast<String>()
                    : [];
                List<DocumentSnapshot> groups = List<DocumentSnapshot>();
                Future future = Future(() async => Future.forEach(
                    groupIds,
                    (id) => Firestore.instance
                        .collection('groups')
                        .document(id)
                        .get()
                        .then((group) => groups.add(group))));
                return FutureBuilder(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          itemCount: groups.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                height: 56.0,
                                alignment: Alignment.center,
                                child: Text(
                                  'Gruppe auswählen',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            } else if (index == groups.length + 1) {
                              return ListTile(
                                  leading: Icon(Icons.add),
                                  title: Text('Neue Gruppe erstellen'),
                                  onTap: () async {
                                    DocumentReference groupReference =
                                        await addGroup(user);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GroupDetailPage(
                                                    groupReference)));
                                  });
                            } else {
                              index--;
                              return Container(
                                decoration: BoxDecoration(
                                  color: selectedGroup.documentID ==
                                          groups[index].documentID
                                      ? Colors.orangeAccent[100]
                                      : null,
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                child: ListTile(
                                  leading: Container(width: 40),
                                  title: Text(groups[index]['name'] != null
                                      ? groups[index]['name']
                                      : ''),
                                  onTap: () => setState(() {
                                    selectedGroup = groups[index];
                                    Navigator.pop(context);
                                  }),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GroupDetailPage(
                                                    groups[index].reference))),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      } else
                        return Center(child: CircularProgressIndicator());
                    });
              } else
                return Center(child: CircularProgressIndicator());
            },
          );
        },
      );
}
