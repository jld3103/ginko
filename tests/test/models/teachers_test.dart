import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Teachers', () {
    test('Can create teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          Teacher(
            shortName: 'KRA',
          ),
        ],
      );
      expect(teachers.date, DateTime(2019, 8, 10));
      expect(
        teachers.teachers.map((teacher) => teacher.toJSON()).toList(),
        [Teacher(shortName: 'KRA').toJSON()],
      );
      expect(
        teachers.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
      expect(RegExp(teachers.regex).hasMatch('kra'), true);
    });

    test('Can create teachers from JSON', () {
      final teachers = Teachers.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'teachers': [
          Teacher(
            shortName: 'KRA',
          ).toJSON(),
        ],
      });
      expect(teachers.date, DateTime(2019, 8, 10));
      expect(
        teachers.teachers.map((teacher) => teacher.toJSON()).toList(),
        [Teacher(shortName: 'KRA').toJSON()],
      );
      expect(
        teachers.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
      expect(RegExp(teachers.regex).hasMatch('kra'), true);
    });

    test('Can create JSON from teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          Teacher(
            shortName: 'KRA',
          ),
        ],
      );
      expect(
        teachers.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'teachers': [
            Teacher(
              shortName: 'KRA',
            ).toJSON(),
          ],
        },
      );
    });

    test('Can create teachers from JSON from teachers', () {
      final teachers = Teachers(
        date: DateTime(2019, 8, 10),
        teachers: [
          Teacher(
            shortName: 'KRA',
          ),
        ],
      );
      expect(Teachers.fromJSON(teachers.toJSON()).toJSON(), teachers.toJSON());
    });
  });

  group('Teacher', () {
    test('Can create teacher', () {
      final teacher = Teacher(
        shortName: 'KRA',
      );
      expect(teacher.shortName, 'KRA');
    });

    test('Can create teacher from JSON', () {
      final teacher = Teacher.fromJSON({
        'shortName': 'KRA',
      });
      expect(teacher.shortName, 'KRA');
    });

    test('Can create JSON from teacher', () {
      final teacher = Teacher(
        shortName: 'KRA',
      );
      expect(teacher.toJSON(), {
        'shortName': 'KRA',
      });
    });

    test('Can create teacher from JSON from teacher', () {
      final teacher = Teacher(
        shortName: 'KRA',
      );
      expect(Teacher.fromJSON(teacher.toJSON()).toJSON(), teacher.toJSON());
    });
  });
}
