import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// CalendarRow class
/// renders an event
class CalendarRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const CalendarRow({
    @required this.event,
  });

  // ignore: public_member_api_docs
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(event.dateString(
                    AppTranslations.of(context).locale.languageCode)),
              ],
            ),
          ),
        ),
      );
}
