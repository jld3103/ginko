import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Device', () {
    test('Can create device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
        version: '1.0.0+1',
      );
      expect(device.token, 'abc');
      expect(device.language, 'de');
      expect(device.os, 'android');
      expect(device.version, '1.0.0+1');
    });

    test('Can create device from JSON', () {
      final device = Device.fromJSON({
        'token': 'abc',
        'language': 'de',
        'os': 'android',
        'version': '1.0.0+1',
      });
      expect(device.token, 'abc');
      expect(device.language, 'de');
      expect(device.os, 'android');
      expect(device.version, '1.0.0+1');
    });

    test('Can create JSON from device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
        version: '1.0.0+1',
      );
      expect(
        device.toJSON(),
        {
          'token': 'abc',
          'language': 'de',
          'os': 'android',
          'version': '1.0.0+1',
        },
      );
    });

    test('Can create device from JSON from device', () {
      final device = Device(
        token: 'abc',
        language: 'de',
        os: 'android',
        version: '1.0.0+1',
      );
      expect(
        Device.fromJSON(device.toJSON()).toJSON(),
        device.toJSON(),
      );
    });
  });
}
