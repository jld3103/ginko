import 'package:flutter/material.dart';
import 'package:ginko/calendar/calendar_grid_event.dart';
import 'package:ginko/calendar/calendar_grid_item.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  // ignore: public_member_api_docs
  DateTime firstEvent;

  // ignore: public_member_api_docs
  DateTime lastEvent;

  // ignore: public_member_api_docs
  TabController controller;

  final List<CalendarEvent> events = Static.calendar.data.getEventsForTimeSpan(
      DateTime.now(), DateTime.now().add(Duration(days: 730)));

  @override
  void initState() {
    events.sort((a, b) {
      if (b.end == null) {
        return 1;
      }
      if (a.end == null) {
        return 1;
      }
      return b.end.millisecondsSinceEpoch
          .compareTo(a.end.millisecondsSinceEpoch);
    });
    lastEvent = events[0].end;
    events.sort((a, b) => a.start.millisecondsSinceEpoch
        .compareTo(b.start.millisecondsSinceEpoch));
    firstEvent = events[0].start;
    controller = TabController(
      length: lastEvent.month -
          firstEvent.month +
          1 +
          (lastEvent.year - firstEvent.year) * 12,
      vsync: this,
    );
    super.initState();
  }

  int daysInMonth(int monthNum, int year) {
    final monthLength = [
      31,
      if (leapYear(year)) 29 else 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
    return monthLength[monthNum];
  }

  bool leapYear(int year) {
    var leapYear = false;

    final leap = (year % 100 == 0) && (year % 400 != 0);
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }
    return leapYear;
  }

  int getDayOfWeek(DateTime monday, DateTime sunday, DateTime date) {
    if (date.isBefore(monday)) {
      return 0;
    }
    if (date.isAfter(sunday)) {
      return 6;
    }
    return date.weekday - 1;
  }

  List<Positioned> getEventViewsForWeek(
    DateTime monday,
    DateTime sunday,
    double width,
    double height,
  ) =>
      getEventsForWeek(monday, sunday)
          .map((event) {
            final lines = [];
            // Show a point in the corner top right when...
            // ... the height is too small to show an event
            // ... the height is too small to show two events
            // ... there are more than 2 events
            if (height / 6 < 40 ||
                (height / 6 < 70 &&
                    (getEventsForDate(event.start)
                                .where((e) =>
                                    Static.calendar.data.events.indexOf(e) <
                                    Static.calendar.data.events.indexOf(event))
                                .length +
                            1) >
                        1) ||
                (getEventsForDate(event.start)
                            .where((e) =>
                                Static.calendar.data.events.indexOf(e) <
                                Static.calendar.data.events.indexOf(event))
                            .length +
                        1) >
                    2) {
              for (var i = getDayOfWeek(monday, sunday, event.start);
                  i <= getDayOfWeek(monday, sunday, event.end);
                  i++) {
                lines.add(Positioned(
                  top: 3,
                  right: 3.0 + width / 7 * (6 - i),
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ));
              }
            } else {
              lines.add(Positioned(
                top: 25.0 *
                    (getEventsForDate(event.start)
                            .where((e) =>
                                Static.calendar.data.events.indexOf(e) <
                                Static.calendar.data.events.indexOf(event))
                            .length +
                        1),
                left: 3 + getDayOfWeek(monday, sunday, event.start) * width / 7,
                child: SizedBox(
                  width: (getDayOfWeek(monday, sunday, event.end) -
                              getDayOfWeek(monday, sunday, event.start) +
                              1) *
                          width /
                          7 -
                      6,
                  child: CalendarGridEvent(
                    event: event,
                  ),
                ),
              ));
            }
            return lines;
          })
          .toList()
          .expand((x) => x)
          .toList()
          .cast<Positioned>();

  List<CalendarEvent> getEventsForDate(DateTime date) => Static
      .calendar.data.events
      .where((event) =>
          event.start != null &&
          event.end != null &&
          (event.start.isBefore(date) || event.start == date) &&
          (event.end.isAfter(date) || event.end == date))
      .toList();

  List<CalendarEvent> getEventsForWeek(DateTime monday, DateTime sunday) =>
      Static.calendar.data.events
          .where((event) =>
              event.start != null &&
              event.end != null &&
              (event.start.isBefore(sunday) || event.start == sunday) &&
              (event.end.isAfter(monday) || event.end == monday))
          .toList();

  @override
  Widget build(BuildContext context) {
    const headerHeight = 36;
    const otherPadding = 0.0;
    final height =
        MediaQuery.of(context).size.height - headerHeight - otherPadding - 82;
    final width = MediaQuery.of(context).size.width - otherPadding * 2 - 1;

    final tabs = [];
    for (var i = 0;
        i <
            lastEvent.month -
                firstEvent.month +
                1 +
                (lastEvent.year - firstEvent.year) * 12;
        i++) {
      final month = (i + firstEvent.month - 1) % 12;
      final year = firstEvent.year + ((i + firstEvent.month - 1) ~/ 12);
      final days = daysInMonth(month, year);
      final firstDayInMonth = DateTime(year, month + 1, 1);
      final items = [];
      for (var j = 0; j < firstDayInMonth.weekday - 1; j++) {
        final date = firstDayInMonth
            .subtract(Duration(days: firstDayInMonth.weekday - 1 - j));
        items.add(CalendarGridItem(date: date, main: false));
      }
      for (var k = 0; k < days; k++) {
        final date = firstDayInMonth.add(Duration(days: k));
        items.add(CalendarGridItem(date: date, main: true));
      }
      var l = 0;
      while (items.length < 42) {
        final date =
            DateTime(firstDayInMonth.year, firstDayInMonth.month + 1, 1)
                .add(Duration(days: l++));
        items.add(CalendarGridItem(date: date, main: false));
      }
      final rows = [];
      for (var m = 0; m < 6; m++) {
        final column = [];
        for (var n = 0; n < 7; n++) {
          column.add(items[m * 7 + n]);
        }
        rows.add(column);
      }
      tabs.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                '${months[month]} $year',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor(context),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: textColor(context).withOpacity(0.5),
                ),
                left: BorderSide(
                  color: textColor(context).withOpacity(0.5),
                ),
              ),
            ),
            margin: EdgeInsets.only(
              right: otherPadding,
              bottom: otherPadding,
              left: otherPadding,
            ),
            child: Column(
              children: rows
                  .map((row) => Stack(
                        children: <Widget>[
                          Row(
                            children: row
                                .map((item) => SizedBox(
                                      width: width / 7,
                                      height: height / 6,
                                      child: item,
                                    ))
                                .toList()
                                .cast<Widget>(),
                          ),
                          ...getEventViewsForWeek(
                              row[0].date, row[6].date, width, height)
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender',
          style: TextStyle(
            color: textColor(context),
          ),
        ),
        elevation: 2,
      ),
      body: TabBarView(
        controller: controller,
        children: tabs.cast<Widget>(),
      ),
    );
  }
}
