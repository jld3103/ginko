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

    test('Dateformat converts correctly', () async {
      await setupDateFormats();
      expect(outputDateFormat.format(DateTime(2019, 7, 5)), '5.7.2019');
      expect(parseDate('5.7.2019'), DateTime(2019, 7, 5));
      expect(parseDate('5.7.19'), DateTime(2019, 7, 5));
      expect(parseDate('5. Juli 2019'), DateTime(2019, 7, 5));
      expect(
          () => parseDate('blabla'), throwsA(TypeMatcher<FormatException>()));
    });

    test('Get correct week a', () {
      expect(isWeekA(DateTime(2019, 1, 1)), true);
      expect(isWeekA(DateTime(2019, 1, 8)), false);
    });

    test('Get senior grades correct', () {
      expect(isSeniorGrade('5a'), false);
      expect(isSeniorGrade('7c'), false);
      expect(isSeniorGrade('9b'), false);
      expect(isSeniorGrade('EF'), true);
      expect(isSeniorGrade('Q1'), true);
      expect(isSeniorGrade('Q2'), true);
    });

    test('Get correct mondays for dates', () {
      expect(monday(DateTime(2019, 8, 8)), DateTime(2019, 8, 5));
      expect(monday(DateTime(2019, 8, 10)), DateTime(2019, 8, 12));
    });
  });
}
