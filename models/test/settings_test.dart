import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Settings', () {
    test('Can create settings', () {
      final settings = Settings([
        SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(settings.settings.length, 1);
      expect(settings.settings[0].key, 'a');
      expect(settings.settings[0].value, true);
      expect(settings.settings[0].modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create settings from JSON', () {
      final settings = Settings.fromJSON([
        {
          'key': 'a',
          'value': true,
          'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
        }
      ]);
      expect(settings.settings.length, 1);
      expect(settings.settings[0].key, 'a');
      expect(settings.settings[0].value, true);
      expect(settings.settings[0].modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create JSON from settings', () {
      final settings = Settings([
        SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(
        settings.toJSON(),
        [
          {
            'key': 'a',
            'value': true,
            'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
          }
        ],
      );
    });

    test('Can create settings from JSON from settings', () {
      final settings = Settings([
        SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(
        Settings.fromJSON(settings.toJSON()).toJSON(),
        settings.toJSON(),
      );
    });

    test('Can get settings', () {
      final settings = Settings([
        SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(settings.getSettings('a'), true);
    });

    test('Can set settings', () {
      final settings = Settings([
        SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11)),
      ]);
      expect(settings.getSettings('a'), true);
      settings.setSettings('a', false);
      expect(settings.getSettings('a'), false);
      expect(settings.getSettings('d'), null);
      settings.setSettings('d', true);
      expect(settings.getSettings('d'), true);
    });

    test('Can create settings value', () {
      final settingsValue =
          SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11));
      expect(settingsValue.key, 'a');
      expect(settingsValue.value, true);
      expect(settingsValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create settings value without explicit modified stamp', () {
      final settingsValue = SettingsValue('a', true);
      expect(settingsValue.key, 'a');
      expect(settingsValue.value, true);
      expect(settingsValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create settings value from JSON', () {
      final settingsValue = SettingsValue.fromJSON({
        'key': 'a',
        'value': true,
        'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
      });
      expect(settingsValue.key, 'a');
      expect(settingsValue.value, true);
      expect(settingsValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
    });

    test('Can create settings value from JSON without explicit modified stamp',
        () {
      final settingsValue = SettingsValue.fromJSON({
        'key': 'a',
        'value': true,
      });
      expect(settingsValue.key, 'a');
      expect(settingsValue.value, true);
      expect(settingsValue.modified.isBefore(DateTime.now()), true);
    });

    test('Can create JSON from settings value', () {
      final settingsValue =
          SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        settingsValue.toJSON(),
        {
          'key': 'a',
          'value': true,
          'modified': DateTime(2019, 8, 7, 19, 56, 11).toIso8601String(),
        },
      );
    });

    test('Can create settings value from JSON from settings value', () {
      final settingsValue =
          SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11));
      expect(
        SettingsValue.fromJSON(settingsValue.toJSON()).toJSON(),
        settingsValue.toJSON(),
      );
    });

    test('Can update settings value', () {
      final settingsValue =
          SettingsValue('a', true, DateTime(2019, 8, 7, 19, 56, 11));
      expect(settingsValue.key, 'a');
      expect(settingsValue.value, true);
      expect(settingsValue.modified, DateTime(2019, 8, 7, 19, 56, 11));
      settingsValue.value = false;
      expect(settingsValue.value, false);
      expect(settingsValue.modified.isBefore(DateTime.now()), true);
      expect(
        settingsValue.modified.isAfter(DateTime(2019, 8, 7, 19, 56, 11)),
        true,
      );
    });
  });
}
