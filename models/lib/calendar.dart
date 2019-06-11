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
    this.info,
  });

  /// Creates a CalendarEvent object from json
  factory CalendarEvent.fromJSON(json) => CalendarEvent(
        name: json['name'],
        type: EventTypes.values[json['type']],
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
        info: json['info'],
      );

  /// Creates json from a CalendarEvent object
  Map<String, dynamic> toJSON() => {
        'name': name,
        'type': type.index,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'info': info,
      };

  // ignore: public_member_api_docs
  String name;

  // ignore: public_member_api_docs
  EventTypes type;

  // ignore: public_member_api_docs
  DateTime start;

  // ignore: public_member_api_docs
  DateTime end;

  // ignore: public_member_api_docs
  String info;
}

/// EventTypes enum
/// describes all possible types of calendar events
enum EventTypes {
  // ignore: public_member_api_docs
  vacation,
  // ignore: public_member_api_docs
  holiday,
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
}
