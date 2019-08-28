/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'MyBottomNavigationBar.dart';
import 'SearchPage.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  String userId = '';
  final GlobalKey<ScaffoldState> _shoppingPageScaffoldStateKey = GlobalKey<ScaffoldState>();

  _ShoppingPageState() {
    SharedPreferences.getInstance().then((_sharedPreferences) {
      userId = _sharedPreferences.getString('userId');
      /*Firestore.instance.collection('users').document(userId).setData({'name': 'James'});
      Firestore.instance.collection('users').document(userId).collection('shopping_card').document('pasta').setData({'name': 'pasta', 'liked': true});

      Firestore.instance.collection('ingredients').where('name', isEqualTo: 'Nudeln').getDocuments().then((snapshot) {
        Firestore.instance.collection('users').document(userId).collection('shopping_card').document(snapshot.documents.first.documentID).setData({'name': 'Nudeln','done': false});
      });*/
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _shoppingPageScaffoldStateKey,
    drawer: MyDrawer(),
    bottomNavigationBar: MyBottomNavigationBar(index: 1),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.search,
        color: Colors.white,
      ),
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: TextField(),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document(userId).collection('shopping_card').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          List<DocumentSnapshot> dataList = snapshot.data.documents;
          return Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: dataList.length + 1,
                itemBuilder:(BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 80.0, bottom: 16.0, left: 16.0),
                          child: Text('Deine Zutaten',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5
                            ),
                          ),
                        ),
                        ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: null,
                          ),
                          title: TextField(
                            onSubmitted: (String string) => setState(() {
                              Firestore.instance.collection('users').document(userId).collection('shopping_card').add({'name': string, 'done': false});
                            }),
                            controller: TextEditingController(text: ''),
                          ),
                        ),
                      ],
                    );
                  } else {
                    index--;
                    DocumentSnapshot data = dataList[index];
                    return ListTile(
                      title: data['done'] ? Text(data['name'],style: TextStyle(decoration: TextDecoration.lineThrough)) : Text(data['name']),
                      leading: IconButton(
                        icon: data['done'] ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                        onPressed:() =>  Firestore.instance.runTransaction((transaction) async {
                          try {
                            final freshSnapshot = await transaction.get(data.reference);
                            await transaction.update(data.reference, {'done': freshSnapshot.data['done'] ? false : true});
                          } catch(e) {
                            print(e);
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('No internet connection'),));
                          }
                        }),
                      ),
                    );
                  }  
                }
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                child: ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage())),
                  leading: IconButton(
                    icon: Icon(Icons.dehaze),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  title: Text('Search for recipes...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        }
      },
    ),
  );

  void buildBottomSheet(BuildContext context) {
    _shoppingPageScaffoldStateKey.currentState.showBottomSheet((BuildContext context) => BottomSheet(
     //elevation: 1.0,
      builder:(context)  {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: TextField(),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(Icons.add),
                      onPressed: null
                    ),
                  ),
                ],
              ),
          ],
        );
      },
      onClosing: () => null,
    ));
  }
}*/