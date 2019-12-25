import 'package:meta/meta.dart';
import 'package:models/models.dart';

/// Timetable class
/// describes all timetables for all grades
class Timetable {
  // ignore: public_member_api_docs
  Timetable({
    @required this.timetables,
  });

  /// Creates a Timetable object from json
  factory Timetable.fromJSON(json) => Timetable(
        timetables: json['timetables']
            .map((i) => TimetableForGrade.fromJSON(i))
            .toList()
            .cast<TimetableForGrade>(),
      );

  /// Creates json from a Timetable object
  Map<String, dynamic> toJSON() => {
        'timetables': timetables.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  List<TimetableForGrade> timetables;
}

/// TimetableForGrade class
/// describes a timetable for one grade
class TimetableForGrade {
  // ignore: public_member_api_docs
  TimetableForGrade({
    @required this.grade,
    @required this.date,
    @required this.days,
  });

  /// Creates a TimetableForGrade object from json
  factory TimetableForGrade.fromJSON(json) => TimetableForGrade(
        grade: json['grade'],
        date: DateTime.parse(json['date']),
        days: json['days']
            .map((i) => TimetableDay.fromJSON(i))
            .toList()
            .cast<TimetableDay>(),
      );

  /// Creates json from a TimetableForGrade object
  Map<String, dynamic> toJSON() => {
        'grade': grade,
        'date': date.toIso8601String(),
        'days': days.map((i) => i.toJSON()).toList(),
      };

  /// Get the index of the initial day
  DateTime initialDay(Selection selection, DateTime date) {
    var day = DateTime(
      date.year,
      date.month,
      date.day,
    );
    if (monday(date).isAfter(date)) {
      day = monday(date);
    }
    final lessonCount = days[day.weekday - 1].userLessonsCount(selection);
    if (date.isAfter(day.add(Times.getUnitTimes(lessonCount - 1)[1]))) {
      day = day.add(Duration(days: 1));
    }
    if (day.weekday > 5) {
      day = monday(day);
    }
    return day;
  }

  /// Get the time stamp of this object
  int get timeStamp => date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  String grade;

  // ignore: public_member_api_docs
  DateTime date;

  // ignore: public_member_api_docs
  List<TimetableDay> days;
}

/// TimetableDay class
/// describes a day of a timetable
class TimetableDay {
  // ignore: public_member_api_docs
  TimetableDay({
    @required this.weekday,
    @required this.lessons,
  });

  /// Creates a TimetableDay object from json
  factory TimetableDay.fromJSON(json) => TimetableDay(
        weekday: json['weekday'],
        lessons: json['lessons']
            .map((i) => TimetableLesson.fromJSON(i))
            .toList()
            .cast<TimetableLesson>(),
      );

  /// Creates json from a TimetableDay object
  Map<String, dynamic> toJSON() => {
        'weekday': weekday,
        'lessons': lessons.map((i) => i.toJSON()).toList(),
      };

  /// Get the count of lessons for a selection for the day
  int userLessonsCount(Selection selection) {
    for (var i = -1; i < lessons.length; i++) {
      var somethingBetween = false;
      for (var j = i + 1; j < lessons.length; j++) {
        final lesson = lessons[j];
        final selected = lesson.subjects
            .where((subject) =>
                subject.identifier == selection.getSelection(lesson.block))
            .toList();
        if (selected.isNotEmpty && selected[0].subject != 'fr' && j != 5) {
          somethingBetween = true;
        }
      }
      if (!somethingBetween) {
        if (i == -1) {
          return lessons.length;
        }
        return i + 1;
      }
    }
    return 0;
  }

  // ignore: public_member_api_docs
  int weekday;

  // ignore: public_member_api_docs
  List<TimetableLesson> lessons;
}

/// TimetableLesson class
/// describes a lesson
class TimetableLesson {
  // ignore: public_member_api_docs
  TimetableLesson({
    @required this.unit,
    @required this.block,
    @required this.subjects,
  });

  /// Creates a TimetableLesson object from json
  factory TimetableLesson.fromJSON(json) => TimetableLesson(
        unit: json['unit'],
        block: json['block'],
        subjects: json['subjects']
            .map((i) => TimetableSubject.fromJSON(i, json['unit']))
            .toList()
            .cast<TimetableSubject>(),
      );

  /// Creates json from a TimetableLesson object
  Map<String, dynamic> toJSON() => {
        'unit': unit,
        'block': block,
        'subjects': subjects.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  int unit;

  // ignore: public_member_api_docs
  String block;

  // ignore: public_member_api_docs
  List<TimetableSubject> subjects;
}

/// TimetableSubject class
/// describes a subject
class TimetableSubject {
  // ignore: public_member_api_docs
  TimetableSubject({
    @required this.teachers,
    @required this.subject,
    @required this.room,
    @required this.unit,
    this.course,
  });

  /// Creates a TimetableSubject object from json
  factory TimetableSubject.fromJSON(json, int unit) => TimetableSubject(
        teachers: json['teachers']?.cast<String>(),
        subject: json['subject'],
        room: json['room'],
        course: json['course'],
        unit: unit,
      );

  /// Creates json from a TimetableSubject object
  Map<String, dynamic> toJSON() => {
        'teachers': teachers,
        'subject': subject,
        'room': room,
        'course': course,
      };

  /// Get the changes that match this subject
  List<SubstitutionPlanChange> getMatchingChanges(
          SubstitutionPlanForGrade substitutionPlanForGrade) =>
      substitutionPlanForGrade.changes
          .where((change) => change.subjectMatches(this))
          .toList();

  // ignore: public_member_api_docs
  String get identifier => '${teachers?.join('+')}-$subject';

  // ignore: public_member_api_docs
  List<String> teachers;

  // ignore: public_member_api_docs
  String subject;

  // ignore: public_member_api_docs
  String room;

  // ignore: public_member_api_docs
  String course;

  // ignore: public_member_api_docs
  int unit;
}
