import 'package:flutter/material.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CafetoriaPage class
/// describes the Cafetoria widget
class CafetoriaPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const CafetoriaPage({
    @required this.cafetoria,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Cafetoria cafetoria;

  // ignore: public_member_api_docs
  final User user;

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        children: [
          if (cafetoria.days.isEmpty)
            Center(
              child: Text(
                AppTranslations.of(context).cafetoriaNoMenus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ...cafetoria.days
              .map((day) => CafetoriaRow(
                    day: day,
                    showDate: true,
                    user: user,
                  ))
              .toList()
              .cast<Widget>()
        ]
            .map((widget) => SizeLimit(
                  child: widget,
                ))
            .toList()
            .cast<Widget>(),
      );
}
