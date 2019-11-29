import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Rooms', () {
    test('Can create rooms', () {
      final rooms = Rooms(
        date: DateTime(2019, 8, 10),
        rooms: [
          'KRA',
        ],
      );
      expect(rooms.date, DateTime(2019, 8, 10));
      expect(rooms.rooms, ['KRA']);
      expect(
        rooms.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create rooms from JSON', () {
      final rooms = Rooms.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'rooms': [
          'KRA',
        ],
      });
      expect(rooms.date, DateTime(2019, 8, 10));
      expect(rooms.rooms, ['KRA']);
      expect(
        rooms.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from rooms', () {
      final rooms = Rooms(
        date: DateTime(2019, 8, 10),
        rooms: [
          'KRA',
        ],
      );
      expect(
        rooms.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'rooms': [
            'KRA',
          ],
        },
      );
    });

    test('Can create rooms from JSON from rooms', () {
      final rooms = Rooms(
        date: DateTime(2019, 8, 10),
        rooms: [
          'KRA',
        ],
      );
      expect(Rooms.fromJSON(rooms.toJSON()).toJSON(), rooms.toJSON());
    });
  });
}
