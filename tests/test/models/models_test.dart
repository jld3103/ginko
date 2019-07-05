import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Models', () {
    test('Get week number successfully', () {
      expect(weekNumber(DateTime(2019, 1, 1)), 1);
      expect(weekNumber(DateTime(2019, 6, 30)), 26);
    });

    test('Get correct grades count', () {
      expect(grades.length, 18);
    });

    test('Get correct weekday count', () {
      expect(weekdays.length, 5);
    });

    test('Dateformat converts correctly', () {
      expect(dateFormat.format(DateTime(2019, 7, 5)), '5.7.2019');
      expect(dateFormat.parse('5.7.2019'), DateTime(2019, 7, 5));
    });
  });
}
