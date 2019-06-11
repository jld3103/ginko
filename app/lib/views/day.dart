import 'package:app/utils/localizations.dart';
import 'package:app/views/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:models/models.dart';

/// Day class
/// renders a day
class Day {
  // ignore: public_member_api_docs
  Day({
    @required items,
    @required date,
  }) {
    _items = items..sort((a, b) => a.from.isBefore(b.from) ? 1 : -1);
    _date = date;
  }

  /// Render the day
  Widget render(BuildContext context) => ListTile(
        title: Row(children: <Widget>[
          Text(dateFormat.format(_date)),
          Text(' - '),
          Text(AppLocalization.of(context).weekday(_date.weekday - 1),
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(' - '),
          Text(weekNumber(_date) % 2 == 0 ? 'A' : 'B',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(' ${AppLocalization.of(context).homeWeek}'),
        ]),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _items.map((item) => item.render()).toList().cast<Widget>(),
        ),
      );

  DateTime _date;
  List<Item> _items;
}
