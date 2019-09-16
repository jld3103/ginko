import 'package:flutter/material.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/views/cafetoria/row.dart';

/// CafetoriaPage class
/// describes the Cafetoria widget
class CafetoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        children: Data.cafetoria.days
            .where((day) => !day.date.isBefore(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                )))
            .map((day) => CafetoriaRow(
                  day: day,
                  showDate: true,
                ))
            .toList()
            .cast<Widget>(),
      );
}
