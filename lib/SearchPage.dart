import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
@override
  Widget build(BuildContext context) => Material(
    child: Stack(
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
    ),
  );
}