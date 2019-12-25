import 'package:intl/date_symbol_data_local.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Calendar', () {
    test('Can create calendar event', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      expect(event.name, 'test');
      expect(event.type, EventTypes.free);
      expect(event.start, DateTime(2019, 1, 5));
      expect(event.end, DateTime(2019, 1, 6));
      expect(event.shortUnits, true);
      expect(event.info, 'blabla');
    });

    test('Can create calendar event from JSON', () {
      final event = CalendarEvent.fromJSON({
        'name': 'test',
        'type': EventTypes.free.index,
        'start': DateTime(2019, 1, 5).toIso8601String(),
        'end': DateTime(2019, 1, 6).toIso8601String(),
        'shortUnits': true,
        'info': 'blabla',
      });
      expect(event.name, 'test');
      expect(event.type, EventTypes.free);
      expect(event.start, DateTime(2019, 1, 5));
      expect(event.end, DateTime(2019, 1, 6));
      expect(event.shortUnits, true);
      expect(event.info, 'blabla');
    });

    test('Can create JSON from calendar event', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      expect(
        event.toJSON(),
        {
          'name': 'test',
          'type': EventTypes.free.index,
          'start': DateTime(2019, 1, 5).toIso8601String(),
          'end': DateTime(2019, 1, 6).toIso8601String(),
          'shortUnits': true,
          'info': 'blabla',
        },
      );
    });

    test('Can create calendar event from JSON from calendar event', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      expect(CalendarEvent.fromJSON(event.toJSON()).toJSON(), event.toJSON());
    });

    test('Can get correct date string for single day event', () async {
      await initializeDateFormatting('de');
      // ignore: missing_required_param
      final event = CalendarEvent(
        start: DateTime(2019, 8, 25),
        end: DateTime(2019, 8, 25, 23, 59, 59),
      );
      expect(event.dateString, '25. August 2019');
    });

    test('Can get correct date string for single day event starting later',
        () async {
      await initializeDateFormatting('de');
      // ignore: missing_required_param
      final event = CalendarEvent(
        start: DateTime(2019, 8, 25, 8),
        end: DateTime(2019, 8, 25, 23, 59, 59),
      );
      expect(event.dateString, '25. August 2019 08:00');
    });

    test('Can get correct date string for multiple days event', () async {
      await initializeDateFormatting('de');
      // ignore: missing_required_param
      final event = CalendarEvent(
        start: DateTime(2019, 8, 25),
        end: DateTime(2019, 8, 26, 23, 59, 59),
      );
      expect(event.dateString, '25. August 2019 - 26. August 2019');
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can get correct date string for multiple days event starting later and ending earlier',
        () async {
      await initializeDateFormatting('de');
      // ignore: missing_required_param
      final event = CalendarEvent(
        start: DateTime(2019, 8, 25, 8),
        end: DateTime(2019, 8, 26, 12),
      );
      expect(event.dateString, '25. August 2019 08:00 - 26. August 2019 12:00');
    });

    test('Can create calendar', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      final calendar = Calendar(
        years: [2018, 2019],
        events: [event],
      );
      expect(calendar.years, [2018, 2019]);
      expect(calendar.events, [event]);
      expect(
        calendar.timeStamp,
        calendar.years.reduce((a, b) => a * 10000 + b),
      );
    });

    test('Can create calendar from JSON', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      final calendar = Calendar.fromJSON({
        'years': [2018, 2019],
        'events': [event.toJSON()],
      });
      expect(calendar.years, [2018, 2019]);
      expect(
        calendar.events.map((event) => event.toJSON()).toList(),
        [event.toJSON()],
      );
      expect(
        calendar.timeStamp,
        calendar.years.reduce((a, b) => a * 10000 + b),
      );
    });

    test('Can create JSON from calendar', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      final calendar = Calendar(
        years: [2018, 2019],
        events: [event],
      );
      expect(
        calendar.toJSON(),
        {
          'years': [2018, 2019],
          'events': [event.toJSON()],
        },
      );
    });

    test('Can create calendar event from JSON from calendar event', () {
      final event = CalendarEvent(
        name: 'test',
        type: EventTypes.free,
        start: DateTime(2019, 1, 5),
        end: DateTime(2019, 1, 6),
        shortUnits: true,
        info: 'blabla',
      );
      final calendar = Calendar(
        years: [2018, 2019],
        events: [event],
      );
      expect(Calendar.fromJSON(calendar.toJSON()).toJSON(), calendar.toJSON());
    });

    test('Can get correct events for timespan', () {
      final calendar = Calendar(
        events: [
          // ignore: missing_required_param
          CalendarEvent(
            start: DateTime(2019, 8, 25),
            end: DateTime(2019, 8, 25, 23, 59, 59),
          ),
        ],
        years: [],
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25), DateTime(2019, 8, 25, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25), DateTime(2019, 8, 26, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25), DateTime(2019, 8, 25, 8))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25, 8), DateTime(2019, 8, 25, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 24), DateTime(2019, 8, 25, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 24), DateTime(2019, 8, 26, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25, 8), DateTime(2019, 8, 25, 9))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 25, 8), DateTime(2019, 8, 26, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 24), DateTime(2019, 8, 26, 23, 59, 59))
            .length,
        1,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 24), DateTime(2019, 8, 24, 23, 59, 59))
            .length,
        0,
      );
      expect(
        calendar
            .getEventsForTimeSpan(
                DateTime(2019, 8, 26), DateTime(2019, 8, 26, 23, 59, 59))
            .length,
        0,
      );
    });
  });
}
