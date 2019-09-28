import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Rooms', () {
    test('Get room successfully', () {
      expect(Rooms.getRoom('klh'), 'klH');
    });

    test('Get room with wrong formatting successfully', () {
      expect(Rooms.getRoom('KLH'), 'klH');
      expect(Rooms.getRoom('a'), 'A');
      expect(Rooms.getRoom('A'), 'A');
      expect(Rooms.getRoom(' A '), 'A');
    });

    test('Cannot get unknown room without error', () {
      expect(Rooms.getRoom(null), '');
      expect(() => Rooms.getRoom('test'), throwsA(TypeMatcher<Exception>()));
    });

    test('Get rooms successfully', () {
      expect(Rooms.rooms.isNotEmpty, true);
    });

    test('Can match rooms with regex', () {
      for (final room in Rooms.rooms.keys.toList()) {
        expect(RegExp(Rooms.regex).hasMatch(room.toLowerCase()), true);
      }
    });
  });
}
