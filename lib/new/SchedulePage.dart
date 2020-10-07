import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildDay(context, 'MO'),
        _buildDay(context, 'DI'),
        _buildDay(context, 'MI'),
        _buildDay(context, 'DO'),
        _buildDay(context, 'FR'),
        _buildDay(context, 'SA'),
        _buildDay(context, 'SO'),
      ],
    );
  }

  Widget _buildDay(BuildContext context, String day) {
    return Column(
      children: [
        Container(child: Text(day)),
        _buildCard(context),
        Divider(),
        _buildCard(context),
        Divider(),
        _buildCard(context)
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      child: Container(
        height: 200,
        width: 200,
      ),
    );
  }
}
