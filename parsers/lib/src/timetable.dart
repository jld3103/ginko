import 'dart:io';

import 'package:csv/csv.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// TimetableParser class
/// handles all timetable parsing
class TimetableParser {
  /// Load csv timetable
  static List<List<dynamic>> load() => CsvToListConverter()
      .convert(File('../parsers/timetable.csv').readAsStringSync());

  /// Extract timetables from html
  static List<TimetableForGrade> extract(List<List<dynamic>> table) {
    final date = DateTime(2019, 11, 14);
    return grades
        .map((grade) => TimetableForGrade(
              date: date,
              grade: grade,
              days: List.generate(5, (day) {
                final lessons = [];
                final rows1 = table
                    .where((row) => row[1] == grade && row[5] - 1 == day)
                    .toList();
                final units = rows1.map((row) => row[6]).toSet().toList()
                  ..sort();
                for (final unit in units) {
                  final patchedUnit = unit > 5 ? unit : unit - 1;
                  final subjects = [];
                  final rows2 = rows1.where((row) => row[6] == unit).toList();
                  for (final row in rows2) {
                    subjects.add(TimetableSubject(
                      unit: patchedUnit,
                      subject: row[3]
                          .toString()
                          .split(' ')
                          .first
                          .toUpperCase()
                          .replaceAll(RegExp('[0-9]'), ''),
                      course: row[3].toString().contains(' ')
                          ? row[3].toString().split(' ').last
                          : null,
                      teacher: row[2],
                      room: row[4],
                      weeks: 'AB', // FIXME
                    ));
                  }
                  if (grades.indexOf(grade) >= 15) {
                    subjects.add(TimetableSubject(
                      unit: unit,
                      subject: 'FR',
                      teacher: null,
                      room: null,
                      weeks: 'AB',
                    ));
                  }
                  lessons.add(TimetableLesson(
                    unit: patchedUnit,
                    block: rows2[0][0].toString(),
                    subjects: subjects.cast<TimetableSubject>(),
                  ));
                }
                if (lessons
                    .where((lesson) => lesson.unit > 4)
                    .toList()
                    .isNotEmpty) {
                  lessons.add(TimetableLesson(
                    unit: 5,
                    block: 'mit',
                    subjects: [
                      TimetableSubject(
                        weeks: null,
                        teacher: null,
                        room: null,
                        subject: 'MIT',
                        unit: 5,
                      )
                    ],
                  ));
                }
                return TimetableDay(
                  weekday: day,
                  lessons: lessons.cast<TimetableLesson>()
                    ..sort((a, b) => a.unit.compareTo(b.unit)),
                );
              }),
            ))
        .toList();
  }
}
