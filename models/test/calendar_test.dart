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
  });
}
