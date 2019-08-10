import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:models/models.dart';

/// UnitPlan class
/// describes all unit plans for all grades
class UnitPlan {
  // ignore: public_member_api_docs
  UnitPlan({
    @required this.unitPlans,
  });

  /// Creates a UnitPlan object from json
  factory UnitPlan.fromJSON(json) => UnitPlan(
        unitPlans: json['unitPlans']
            .map((i) => UnitPlanForGrade.fromJSON(i))
            .toList()
            .cast<UnitPlanForGrade>(),
      );

  /// Creates json from a UnitPlan object
  Map<String, dynamic> toJSON() => {
        'unitPlans': unitPlans.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  List<UnitPlanForGrade> unitPlans;
}

/// UnitPlanForGrade class
/// describes a unit plan for one grade
class UnitPlanForGrade {
  // ignore: public_member_api_docs
  UnitPlanForGrade({
    @required this.grade,
    @required this.date,
    @required this.days,
  });

  /// Creates a UnitPlanForGrade object from json
  factory UnitPlanForGrade.fromJSON(json) => UnitPlanForGrade(
        grade: json['grade'],
        date: DateTime.parse(json['date']),
        days: json['days']
            .map((i) => UnitPlanDay.fromJSON(i))
            .toList()
            .cast<UnitPlanDay>(),
      );

  /// Creates json from a UnitPlanForGrade object
  Map<String, dynamic> toJSON() => {
        'grade': grade,
        'date': date.toIso8601String(),
        'days': days.map((i) => i.toJSON()).toList(),
      };

  /// Get the index of the initial day
  DateTime initialDay(User user, DateTime date) {
    var day = DateTime(
      date.year,
      date.month,
      date.day,
    );
    if (monday(date).isAfter(date)) {
      day = monday(date);
    }
    final lessonCount =
        days[day.weekday - 1].userLessonsCount(user, isWeekA(day));
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
  List<UnitPlanDay> days;
}

/// UnitPlanDay class
/// describes a day of a unit plan
class UnitPlanDay {
  // ignore: public_member_api_docs
  UnitPlanDay({
    @required this.weekday,
    @required this.lessons,
  });

  /// Creates a UnitPlanDay object from json
  factory UnitPlanDay.fromJSON(json) => UnitPlanDay(
        weekday: json['weekday'],
        lessons: json['lessons']
            .map((i) => Lesson.fromJSON(i))
            .toList()
            .cast<Lesson>(),
      );

  /// Creates json from a UnitPlanDay object
  Map<String, dynamic> toJSON() => {
        'weekday': weekday,
        'lessons': lessons.map((i) => i.toJSON()).toList(),
      };

  /// Get the count of lessons for a user for the day
  int userLessonsCount(User user, bool weekA) {
    for (var i = -1; i < lessons.length; i++) {
      var somethingBetween = false;
      for (var j = i + 1; j < lessons.length; j++) {
        final lesson = lessons[j];
        final selected = lesson.subjects
            .where((subject) =>
                subject.identifier ==
                user.getSelection(Keys.selection(lesson.block, weekA)))
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
  // ignore: lines_longer_than_80_chars
  List<Change> getMatchingChanges(
          ReplacementPlanForGrade replacementPlanForGrade) =>
      replacementPlanForGrade.changes
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
    if (course == null || course == '') {
      course = c.course;
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
