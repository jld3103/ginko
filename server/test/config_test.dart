import 'package:server/config.dart';
import 'package:test/test.dart';

void main() {
  group('Config', () {
    test('Can load all config', () {
      Config.load({
        'username': 'a',
        'password': 'b',
        'replacementPlanPassword': 'c',
        'cafetoriaUsername': 'd',
        'cafetoriaPassword': 'e',
        'fcmServerKey': 'f',
        'dev': true,
      });
      expect(Config.username, 'a');
      expect(Config.password, 'b');
      expect(Config.replacementPlanPassword, 'c');
      expect(Config.cafetoriaUsername, 'd');
      expect(Config.cafetoriaPassword, 'e');
      expect(Config.fcmServerKey, 'f');
      expect(Config.dev, true);
    });

    test('Can load config from default', Config.loadFromDefault);
  });
}
