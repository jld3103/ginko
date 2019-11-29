import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// SubjectsParser class
/// handles all subjects parsing
class SubjectsParser {
  /// Extract subjects
  static Subjects extract(List<TimetableForGrade> timetables) => Subjects(
        date: timetables.isNotEmpty
            ? timetables[0].date
            : DateTime.fromMillisecondsSinceEpoch(0),
        subjects: (timetables
                .map((timetable) => timetable.days
                    .map((day) => day.lessons
                        .map((lesson) =>
                            lesson.subjects.map((subject) => subject.subject))
                        .expand((x) => x))
                    .expand((x) => x))
                .expand((x) => x)
                .toSet()
                  ..add('FR'))
            .where((a) => a != null && a.isNotEmpty)
            .toList()
              ..sort(),
      );
}
