import 'package:flutter/material.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaPage class
/// describes the Cafetoria widget
class CafetoriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        children: [
          if (Data.cafetoria.days.isEmpty)
            Center(
              child: Text(
                AppTranslations.of(context).cafetoriaNoMenus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ...Data.cafetoria.days
              .map((day) => CafetoriaRow(
                    day: day,
                    showDate: true,
                  ))
              .toList()
              .cast<Widget>()
        ],
      );
}
