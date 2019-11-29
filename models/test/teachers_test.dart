import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Teachers', () {
    test('Can create teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          'KRA',
        ],
      );
      expect(teachers.date, DateTime(2019, 8, 10));
      expect(teachers.teachers, ['KRA']);
      expect(
        teachers.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create teachers from JSON', () {
      final teachers = Teachers.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'teachers': [
          'KRA',
        ],
      });
      expect(teachers.date, DateTime(2019, 8, 10));
      expect(teachers.teachers, ['KRA']);
      expect(
        teachers.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          'KRA',
        ],
      );
      expect(
        teachers.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'teachers': [
            'KRA',
          ],
        },
      );
    });

    test('Can create teachers from JSON from teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          'KRA',
        ],
      );
      expect(Teachers.fromJSON(teachers.toJSON()).toJSON(), teachers.toJSON());
    });
  });
}
