import 'package:models/models.dart';
import 'package:parsers/parsers.dart';

// ignore: avoid_classes_with_only_static_members
/// TimetableParser class
/// handles all timetable parsing
class TimetableParser {
  /// Extract timetables
  static Timetable extract(List<List<String>> table) {
    final date = DateTime(2019, 12, 21);
    final timetable = Timetable(timetables: []);
    final lines = table.where((line) => line[0].startsWith('U')).toList();
    for (var i = 0; i < lines.length; i++) {
      var definingLines = [lines[i]];
      for (var j = i + 1; j < lines.length; j++) {
        if (lines[j][0].startsWith('U1')) {
          i += j - i - 1;
          break;
        }
        definingLines.add(lines[j]);
      }
      definingLines = definingLines
        ..sort((a, b) =>
            int.parse(a[0].split('')[1]) - int.parse(b[0].split('')[1]));
      if (definingLines.length > 1) {
        var subject = definingLines[0][6]
            .replaceAll(RegExp(r'/ {2,}/g'), ' ')
            .replaceAll('"', '');
        final course = subject.split(' ').length > 1
            ? subject.split(' ')[1].toLowerCase()
            : null;
        subject =
            subject.split(' ')[0].toLowerCase().replaceAll(RegExp('[0-9]'), '');
        if (subject == 'ber' || subject == 'koor') {
          continue;
        }
        var grades = [definingLines[0][2].toLowerCase()];
        if (definingLines.length > 2 && definingLines[2][0] == 'U6') {
          grades = definingLines[2]
              .sublist(3, definingLines[2].length - 2)
              .map((grade) => grade.toLowerCase())
              .toList();
        }
        final block = definingLines[0][1];
        final numberOfLessons = int.parse(definingLines[1][2]);
        for (final grade in grades) {
          if (grade == 'ag') {
            continue;
          }
          TimetableForGrade t;
          if (timetable.timetables.where((t) => t.grade == grade).isEmpty) {
            t = TimetableForGrade(
              date: date,
              grade: grade,
              days: List.generate(
                5,
                (weekday) => TimetableDay(
                  weekday: weekday,
                  lessons: [],
                ),
              ),
            );
            timetable.timetables.add(t);
          } else {
            t = timetable.timetables.singleWhere((t) => t.grade == grade);
          }
          final dataLine = definingLines[1].sublist(3);
          for (var k = 0; k < numberOfLessons; k++) {
            final dataElement = dataLine.sublist(k * 6, (k + 1) * 6);
            final day = int.parse(dataElement[0]) - 1;
            final unitCount = int.parse(dataElement[2]);
            final startUnit = int.parse(dataElement[1]);
            final room = dataElement[3]
                .toLowerCase()
                .replaceAll('"', '')
                .replaceAll(' ', '');
            final teacher = dataElement[4].toLowerCase();

            for (var j = 0; j < unitCount; j++) {
              var unit = startUnit + j;
              if (unit <= 5) {
                unit--;
              }
              if (t.days[day].lessons
                  .where((lesson) => lesson.unit == unit)
                  .isEmpty) {
                t.days[day].lessons.add(TimetableLesson(
                  unit: unit,
                  block: block,
                  subjects: [],
                ));
              }
              final subjectsToUpdate = t.days[day].lessons
                  .singleWhere((lesson) => lesson.unit == unit)
                  .subjects
                  .where((s) =>
                      s.subject == subject &&
                      s.course == course &&
                      s.room == room);
              if (subjectsToUpdate.isNotEmpty) {
                for (final subject in subjectsToUpdate) {
                  subject.teachers =
                      (subject.teachers..add(teacher)).toSet().toList();
                }
              } else {
                t.days[day].lessons
                    .singleWhere((lesson) => lesson.unit == unit)
                    .subjects
                    .add(TimetableSubject(
                      teachers: [teacher],
                      subject: subject,
                      room: RoomsParser.fix(room),
                      unit: unit,
                      course: course,
                    ));
              }
            }
          }
        }
      }
    }
    timetable.timetables = (timetable.timetables
            .map((t) => t
              ..days = t.days
                  .map((d) => d
                    ..lessons = ([
                      ...d.lessons,
                      if (d.lessons.length > 5)
                        TimetableLesson(
                          unit: 5,
                          block: 'mit',
                          subjects: [
                            TimetableSubject(
                              unit: 5,
                              subject: 'mit',
                              teachers: null,
                              room: null,
                            )
                          ],
                        ),
                    ]..sort((a, b) => a.unit - b.unit))
                        .map((lesson) => lesson
                          ..subjects = [
                            ...lesson.subjects,
                            if (lesson.subjects.length > 1 ||
                                isSeniorGrade(t.grade) && lesson.unit != 5)
                              TimetableSubject(
                                unit: lesson.unit,
                                subject: 'fr',
                                room: null,
                                teachers: null,
                                course: null,
                              ),
                          ])
                        .toList())
                  .toList())
            .toList()
              ..sort(
                  (a, b) => grades.indexOf(a.grade) - grades.indexOf(b.grade)))
        .toList();
    return timetable;
  }
}
