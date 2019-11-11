import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// Calendar class
/// describes a full calendar
class Calendar {
  // ignore: public_member_api_docs
  Calendar({
    @required this.years,
    @required this.events,
  });

  /// Creates a Calendar object from json
  factory Calendar.fromJSON(json) => Calendar(
        years: json['years'].cast<int>(),
        events: json['events']
            .map((event) => CalendarEvent.fromJSON(event))
            .toList()
            .cast<CalendarEvent>(),
      );

  /// Creates json from a Calendar object
  Map<String, dynamic> toJSON() => {
        'years': years,
        'events': events.map((event) => event.toJSON()).toList(),
      };

  /// Get the time stamp of this object
  int get timeStamp => years.reduce((a, b) => a * 10000 + b);

  /// Get all events that overlap with a certain time span
  List<CalendarEvent> getEventsForTimeSpan(DateTime start, DateTime end) =>
      events.where((event) {
        if (event.start == start &&
            (event.end == end ||
                event.end.isAfter(end) ||
                event.end.isBefore(end))) {
          return true;
        }
        if (event.end == end &&
            (event.start == start ||
                event.start.isAfter(start) ||
                event.start.isBefore(start))) {
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
      }).toList();

  // ignore: public_member_api_docs
  List<int> years;

  // ignore: public_member_api_docs
  List<CalendarEvent> events;
}

/// CalendarEvent class
/// describes a CalendarEvent
class CalendarEvent {
  // ignore: public_member_api_docs
  CalendarEvent({
    @required this.name,
    @required this.type,
    @required this.start,
    @required this.end,
    this.shortUnits = false,
    this.info,
  });

  /// Creates a CalendarEvent object from json
  factory CalendarEvent.fromJSON(json) => CalendarEvent(
        name: json['name'],
        type: EventTypes.values[json['type']],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        shortUnits: json['shortUnits'],
        info: json['info'],
      );

  /// Creates json from a CalendarEvent object
  Map<String, dynamic> toJSON() => {
        'name': name,
        'type': type.index,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'shortUnits': shortUnits,
        'info': info,
      };

  /// Get the date string of the event
  String dateString(String languageCode) {
    final _dateFormat = DateFormat.yMMMMd(languageCode);
    final _dateTimeFormat = DateFormat.yMMMMd(languageCode).add_Hm();
    var dateStr = '';
    if (start.hour != 0 || start.minute != 0) {
      dateStr = _dateTimeFormat.format(start);
    } else {
      dateStr = _dateFormat.format(start);
    }
    if (DateTime(
          start.year,
          start.month,
          start.day,
        ).add(Duration(days: 1)).subtract(Duration(seconds: 1)) !=
        end) {
      dateStr += ' - ';
      if (end.hour != 23 || end.minute != 59) {
        dateStr += _dateTimeFormat.format(end);
      } else {
        dateStr += _dateFormat.format(end);
      }
    }
    return dateStr;
  }

  // ignore: public_member_api_docs
  String name;

  // ignore: public_member_api_docs
  EventTypes type;

  // ignore: public_member_api_docs
  DateTime start;

  // ignore: public_member_api_docs
  DateTime end;

  // ignore: public_member_api_docs
  bool shortUnits;

  // ignore: public_member_api_docs
  String info;
}

/// EventTypes enum
/// describes all possible types of calendar events
enum EventTypes {
  // ignore: public_member_api_docs
  vacation,
  // ignore: public_member_api_docs
  free,
  // ignore: public_member_api_docs
  parentConsulting,
  // ignore: public_member_api_docs
  teacherConsulting,
  // ignore: public_member_api_docs
  noAfternoonClasses,
  // ignore: public_member_api_docs
  earlyEnd,
  // ignore: public_member_api_docs
  openDoorDay,
  // ignore: public_member_api_docs
  gradeRelease,
}
