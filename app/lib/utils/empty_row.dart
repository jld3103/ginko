import 'package:flutter/material.dart';

// ignore: public_member_api_docs
class EmptyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 60,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          'Keine Einträge vorhanden',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
}
