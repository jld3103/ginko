import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Keys', () {
    test('Selection keys works', () {
      expect(Keys.selectionBlock('test', true), 'selection-test-a');
      expect(Keys.selectionBlock('test', false), 'selection-test-b');
    });

    test('Settings keys works', () {
      expect(Keys.settingsKey('test'), 'settings-test');
    });
  });
}
