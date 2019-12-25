import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Subjects', () {
    test('Can create subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: {
          'ek': 'Erdkunde',
        },
      );
      expect(subjects.date, DateTime(2019, 8, 10));
      expect(subjects.subjects, {'ek': 'Erdkunde'});
      expect(
        subjects.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create subjects from JSON', () {
      final subjects = Subjects.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'subjects': {
          'ek': 'Erdkunde',
        },
      });
      expect(subjects.date, DateTime(2019, 8, 10));
      expect(subjects.subjects, {'ek': 'Erdkunde'});
      expect(
        subjects.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: {
          'ek': 'Erdkunde',
        },
      );
      expect(
        subjects.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'subjects': {
            'ek': 'Erdkunde',
          },
        },
      );
    });

    test('Can create subjects from JSON from subjects', () {
      final subjects = Subjects(
        date: DateTime(2019, 8, 10),
        subjects: {
          'ek': 'Erdkunde',
        },
      );
      expect(Subjects.fromJSON(subjects.toJSON()).toJSON(), subjects.toJSON());
    });
  });
}
