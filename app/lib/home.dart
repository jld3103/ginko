import 'package:app/utils/data.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/utils/platform/platform.dart';
import 'package:app/views/calendar/row.dart';
import 'package:app/views/day.dart';
import 'package:app/views/item.dart';
import 'package:app/views/modes.dart' as modes;
import 'package:app/views/unitplan/row.dart';
import 'package:flutter/material.dart';

/// Home class
/// describes the home widget
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

/// HomeState class
/// describes the state of the home widget
class HomeState extends State<Home> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      if (!Data.online) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalization.of(context).homeOffline),
        ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).appName),
        ),
    body: Platform().isMobile
            ? modes.PageMode(_itemBuilder)
            : modes.ListMode(_itemBuilder),
      );

  /// Build a single day
  Widget _itemBuilder(BuildContext context, int index) => FutureBuilder(
        future: _fetchEntry(index),
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data != null) {
                return snapshot.data.render(context);
              }
              break;
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
          }
          return Text('');
        },
      );

  Future<Day> _fetchEntry(int index) async {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final start = lastMidnight.add(Duration(days: index));
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final items = [];
    // Add items from unit plan
    if (start.weekday < 6) {
      items.add(Item(
        from: start,
        to: end,
        render: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Data.unitPlan.days[start.weekday - 1].lessons
                  .map((lesson) => UnitPlanRow(lesson: lesson, start: start))
                  .toList()
                  .cast<Widget>(),
            ),
      ));
    }
    // Add items from calendar
    for (final event in Data.calendar.events.where((event) {
      if (event.start == start && event.end == end) {
        return true;
      }
      if (event.start.isBefore(start) && event.end.isAfter(end)) {
        return true;
      }
      if (event.start.isAfter(start) && event.end.isBefore(end)) {
        return true;
      }
      if (event.start.isAfter(start) && event.start.isBefore(end)) {
        return true;
      }
      if (event.end.isAfter(start) && event.end.isBefore(end)) {
        return true;
      }
      return false;
    })) {
      items.add(Item(
        from: event.start,
        to: event.end,
        render: () => CalendarRow(event: event),
      ));
    }
    // Add more items ...
    return Day(
      date: start,
      items: items.cast<Item>(),
    );
  }
}
