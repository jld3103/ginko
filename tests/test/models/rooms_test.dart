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
      expect(
          () => Rooms.getRoom(null), throwsA(TypeMatcher<NoSuchMethodError>()));
      expect(() => Rooms.getRoom('test'), throwsA(TypeMatcher<Exception>()));
    });

    test('Get rooms successfully', () {
      expect(Rooms.rooms.isNotEmpty, true);
    });
  });
}
