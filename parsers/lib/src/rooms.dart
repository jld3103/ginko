import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// RoomsParser class
/// handles all rooms parsing
class RoomsParser {
  /// Extract rooms
  static Rooms extract(List<TimetableForGrade> timetables) => Rooms(
        date: timetables.isNotEmpty
            ? timetables[0].date
            : DateTime.fromMillisecondsSinceEpoch(0),
        rooms: timetables
            .map((timetable) => timetable.days
                .map((day) => day.lessons
                    .map((lesson) =>
                        lesson.subjects.map((subject) => subject.room))
                    .expand((x) => x))
                .expand((x) => x))
            .expand((x) => x)
            .toSet()
            .where((a) => a != null && a.isNotEmpty)
            .toList()
              ..sort((a, b) => a.toString().compareTo(b.toString())),
      );
}
