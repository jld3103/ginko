import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Device', () {
    test('Can create device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
      );
      expect(device.token, 'abc');
      expect(device.language, 'de');
      expect(device.os, 'android');
    });

    test('Can create device from JSON', () {
      final device = Device.fromJSON({
        'token': 'abc',
        'language': 'de',
        'os': 'android',
      });
      expect(device.token, 'abc');
      expect(device.language, 'de');
      expect(device.os, 'android');
    });

    test('Can create JSON from device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
      );
      expect(
        device.toJSON(),
        {
          'token': 'abc',
          'language': 'de',
          'os': 'android',
        },
      );
    });

    test('Can create device from JSON from device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
      );
      expect(
        Device.fromJSON(device.toJSON()).toJSON(),
        device.toJSON(),
      );
    });
  });
}
