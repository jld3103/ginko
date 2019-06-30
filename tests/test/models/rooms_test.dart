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

    test('Get unknown room successfully', () {
      expect(Rooms.getRoom(null), null);
      expect(Rooms.getRoom('test'), 'TEST');
    });
  });
}
