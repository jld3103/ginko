import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Subjects', () {
    test('Can create subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: [
          'KRA',
        ],
      );
      expect(subjects.date, DateTime(2019, 8, 10));
      expect(subjects.subjects, ['KRA']);
      expect(
        subjects.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create subjects from JSON', () {
      final subjects = Subjects.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'subjects': [
          'KRA',
        ],
      });
      expect(subjects.date, DateTime(2019, 8, 10));
      expect(subjects.subjects, ['KRA']);
      expect(
        subjects.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: [
          'KRA',
        ],
      );
      expect(
        subjects.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'subjects': [
            'KRA',
          ],
        },
      );
    });

    test('Can create subjects from JSON from subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: [
          'KRA',
        ],
      );
      expect(Subjects.fromJSON(subjects.toJSON()).toJSON(), subjects.toJSON());
    });
  });
}
