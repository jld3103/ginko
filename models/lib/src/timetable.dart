import 'dart:convert';

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
    final lessonCount =
        days[day.weekday - 1].userLessonsCount(selection, isWeekA(day));
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
            .map((i) => Lesson.fromJSON(i))
            .toList()
            .cast<Lesson>(),
      );

  /// Creates json from a TimetableDay object
  Map<String, dynamic> toJSON() => {
        'weekday': weekday,
        'lessons': lessons.map((i) => i.toJSON()).toList(),
      };

  /// Get the count of lessons for a selection for the day
  int userLessonsCount(Selection selection, bool weekA) {
    for (var i = -1; i < lessons.length; i++) {
      var somethingBetween = false;
      for (var j = i + 1; j < lessons.length; j++) {
        final lesson = lessons[j];
        final selected = lesson.subjects
            .where((subject) =>
                subject.identifier ==
                selection
                    .getSelection(Keys.selectionBlock(lesson.block, weekA)))
            .toList();
        if (selected.isNotEmpty &&
            selected[0].subject != Subjects.subjects['FR'] &&
            j != 5) {
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
  List<Lesson> lessons;
}

/// Lesson class
/// describes a lesson
class Lesson {
  // ignore: public_member_api_docs
  Lesson({
    @required this.unit,
    @required this.block,
    @required this.subjects,
  });

  /// Creates a Lesson object from json
  factory Lesson.fromJSON(json) => Lesson(
        unit: json['unit'],
        block: json['block'],
        subjects: json['subjects']
            .map((i) => Subject.fromJSON(i, json['unit']))
            .toList()
            .cast<Subject>(),
      );

  /// Creates json from a Lesson object
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
  List<Subject> subjects;
}

/// Subject class
/// describes a subject
class Subject {
  // ignore: public_member_api_docs
  Subject({
    @required this.teacher,
    @required this.subject,
    @required this.room,
    @required this.weeks,
    @required this.unit,
    this.course,
  });

  /// Creates a Subject object from json
  factory Subject.fromJSON(json, int unit) => Subject(
        teacher: json['teacher'],
        subject: json['subject'],
        room: json['room'],
        course: json['course'],
        weeks: json['weeks'],
        unit: unit,
      );

  /// Creates json from a Subject object
  Map<String, dynamic> toJSON() => {
        'teacher': teacher,
        'subject': subject,
        'room': room,
        'course': course,
        'weeks': weeks,
      };

  /// Get the changes that match this subject

  List<Change> getMatchingChanges(
          SubstitutionPlanForGrade substitutionPlanForGrade) =>
      substitutionPlanForGrade.changes
          .where((change) => change
              .getMatchingSubjectsByLesson(Lesson(
                unit: unit,
                block: null,
                subjects: [this],
              ))
              .where((subject) =>
                  json.encode(subject.toJSON()) == json.encode(toJSON()))
              .toList()
              .isNotEmpty)
          .toList();

  /// Complete the information of this subject using the replacement plan
  void complete(Change c) {
    if (c.type != ChangeTypes.exam) {
      if (course == null || course == '') {
        course = c.course;
      }
    }
  }

  // ignore: public_member_api_docs
  String get identifier => '$teacher-$subject';

  // ignore: public_member_api_docs
  String teacher;

  // ignore: public_member_api_docs
  String subject;

  // ignore: public_member_api_docs
  String room;

  // ignore: public_member_api_docs
  String course;

  // ignore: public_member_api_docs
  String weeks;

  // ignore: public_member_api_docs
  int unit;
}

/// MatchingSubject scan
/// a subject that matches a scanned string
class MatchingSubject {
  // ignore: public_member_api_docs
  MatchingSubject({
    @required this.subject,
    @required this.lesson,
  }) : super();

  // ignore: public_member_api_docs
  final Subject subject;

  // ignore: public_member_api_docs
  final Lesson lesson;
}
