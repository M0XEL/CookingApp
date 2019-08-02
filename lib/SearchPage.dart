import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    return Text('result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    return Text('Suggestions');
  }
}

class _SearchPageState extends State<SearchPage> {
  List<String> items = List<String>.generate(1000, (i) => 'Item $i');

  @override
  Widget build(BuildContext context) => Material(
    child: ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
    ),
    
    
    
    /*IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: MySearchDelegate(),
        );
      },
    ),*/
    



    /*Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: ListTile(
            leading: Icon(Icons.dehaze),
            title: Text('Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(height: 100.0),
            Divider(height: 0.0),
            Container(
              height: 70.0,
              child: Row(
                children: <Widget>[
                  Expanded(child: FlutterLogo()),
                  VerticalDivider(),
                  Expanded(child: FlutterLogo()),
                  VerticalDivider(),
                  Expanded(child: FlutterLogo()),
                ],
              ),
            ),
            Divider(height: 0.0),
            Container(
              height: 70.0,
              child: Row(
                children: <Widget>[
                  Expanded(child: Chip(label: Text('- #1 -'))),
                  Expanded(child: Chip(label: Text('- #2 -'))),
                  Expanded(child: Chip(label: Text('- #3 -'))),
                  Expanded(child: Chip(label: Text('- #4 -'))),
                ],
              ),
            ),
            Slider(
              value: 0.5,
              onChanged: null,
            ),
          ],
        ),
      ],
    ),*/
  );
}