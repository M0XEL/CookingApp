import 'package:flutter/material.dart';
import 'MyBottomNavigationBar.dart';

class GroupDetailPage extends StatefulWidget {
  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(index: 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: null,
        ),
        title: Text('Familie'),
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
    
    
    
    /*StreamBuilder<QuerySnapshot>(
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
    ),*/
}