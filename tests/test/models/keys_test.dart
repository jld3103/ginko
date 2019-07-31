import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Keys', () {
    test('Selection keys works', () {
      expect(Keys.selection('test', true), 'selection-test-a');
      expect(Keys.selection('test', false), 'selection-test-b');
    });

    test('Keys are not null', () {
      expect(Keys.username != null, true);
      expect(Keys.password != null, true);
      expect(Keys.grade != null, true);
      expect(Keys.unitPlan != null, true);
      expect(Keys.none != null, true);
      expect(Keys.calendar != null, true);
      expect(Keys.cafetoria != null, true);
      expect(Keys.replacementPlan != null, true);
      expect(Keys.user != null, true);
      expect(Keys.type != null, true);
    });
  });
}
