import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Models', () {
    test('Get week number successfully', () {
      expect(weekNumber(DateTime(2019, 1, 1)), 1);
      expect(weekNumber(DateTime(2019, 6, 30)), 26);
    });
  });
}
