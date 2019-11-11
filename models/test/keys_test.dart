import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Keys', () {
    test('Selection keys works', () {
      expect(Keys.selectionBlock('test', true), 'selection-test-a');
      expect(Keys.selectionBlock('test', false), 'selection-test-b');
    });

    test('Keys are not null', () {
      expect(Keys.username != null, true);
      expect(Keys.password != null, true);
      expect(Keys.grade != null, true);
      expect(Keys.timetable != null, true);
      expect(Keys.none != null, true);
      expect(Keys.calendar != null, true);
      expect(Keys.cafetoria != null, true);
      expect(Keys.substitutionPlan != null, true);
      expect(Keys.user != null, true);
      expect(Keys.askedForScan != null, true);
      expect(Keys.teachers != null, true);
      expect(Keys.weekday != null, true);
      expect(Keys.aiXformation != null, true);
    });
  });
}
