import 'package:meta/meta.dart';
import 'package:models/models.dart';

/// SubstitutionPlan class
/// describes all replacement plans for all grades
class SubstitutionPlan {
  // ignore: public_member_api_docs
  SubstitutionPlan({
    @required this.substitutionPlans,
  });

  /// Creates a SubstitutionPlan object from json
  factory SubstitutionPlan.fromJSON(json) => SubstitutionPlan(
        substitutionPlans: json['substitutionPlans']
            .map((i) => SubstitutionPlanForGrade.fromJSON(i))
            .toList()
            .cast<SubstitutionPlanForGrade>(),
      );

  /// Creates json from a SubstitutionPlan object
  Map<String, dynamic> toJSON() => {
        'substitutionPlans': substitutionPlans.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  List<SubstitutionPlanForGrade> substitutionPlans;
}

/// SubstitutionPlanForGrade class
/// describes a replacement plan for one grade
class SubstitutionPlanForGrade {
  // ignore: public_member_api_docs
  SubstitutionPlanForGrade({
    @required this.grade,
    @required this.substitutionPlanDays,
    @required this.changes,
  });

  /// Creates a SubstitutionPlanForGrade object from json
  factory SubstitutionPlanForGrade.fromJSON(json) => SubstitutionPlanForGrade(
        grade: json['grade'],
        substitutionPlanDays: json['substitutionPlanDays']
            .map((i) => SubstitutionPlanDay.fromJSON(i))
            .toList()
            .cast<SubstitutionPlanDay>(),
        changes: json['changes']
            .map((i) => Change.fromJSON(i))
            .toList()
            .cast<Change>(),
      );

  /// Creates json from a SubstitutionPlanForGrade object
  Map<String, dynamic> toJSON() => {
        'grade': grade,
        'substitutionPlanDays':
            substitutionPlanDays.map((i) => i.toJSON()).toList(),
        'changes': changes.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  int get timeStamp =>
      substitutionPlanDays[0].date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  String grade;

  // ignore: public_member_api_docs
  List<SubstitutionPlanDay> substitutionPlanDays;

  // ignore: public_member_api_docs
  List<Change> changes;
}

/// SubstitutionPlanDay class
/// describes the day of a replacement plan
class SubstitutionPlanDay {
  // ignore: public_member_api_docs
  SubstitutionPlanDay({
    @required this.date,
    @required this.updated,
  });

  /// Creates a SubstitutionPlanDay object from json
  factory SubstitutionPlanDay.fromJSON(json) => SubstitutionPlanDay(
        date: DateTime.parse(json['date']),
        updated: DateTime.parse(json['updated']),
      );

  /// Creates json from a SubstitutionPlanDay object
  Map<String, dynamic> toJSON() => {
        'date': date.toIso8601String(),
        'updated': updated.toIso8601String(),
      };

  // ignore: public_member_api_docs
  DateTime date;

  // ignore: public_member_api_docs
  DateTime updated;
}

/// Change class
/// describes a change in a subject
class Change {
  // ignore: public_member_api_docs
  Change({
    @required this.date,
    @required this.unit,
    @required this.changed,
    @required this.subject,
    @required this.room,
    @required this.teacher,
    @required this.type,
    this.course,
  });

  /// Creates a Change object from json
  factory Change.fromJSON(json) => Change(
        date: DateTime.parse(json['date']),
        unit: json['unit'],
        subject: json['subject'],
        course: json['course'],
        room: json['room'],
        teacher: json['teacher'],
        changed: Changed.fromJSON(json['changed']),
        type: ChangeTypes.values[json['type']],
      );

  /// Creates json from a Change object
  Map<String, dynamic> toJSON() => {
        'date': date.toIso8601String(),
        'unit': unit,
        'subject': subject,
        'course': course,
        'room': room,
        'teacher': teacher,
        'changed': changed?.toJSON(),
        'type': type?.index,
      };

  /// Get all subject indexes in a lesson that match the change
  List<TimetableSubject> getMatchingSubjectsByTimetable(
      TimetableForGrade timetableForGrade) {
    try {
      return getMatchingSubjectsByLesson(
          timetableForGrade.days[date.weekday - 1].lessons[unit]);
      // ignore: avoid_catching_errors
    } on RangeError {
      return [];
    }
  }

  /// Get all subject indexes in a lesson that match the change
  List<TimetableSubject> getMatchingSubjectsByLesson(TimetableLesson lesson) {
    if (unit != lesson.unit) {
      return [];
    }
    var subjects = lesson.subjects;
    if (subject != null && subject != '') {
      subjects = subjects.where((s) => s.subject == subject).toList();
    }
    if (teacher != null && teacher != '') {
      subjects = subjects.where((s) => s.teacher == teacher).toList();
    }
    if (room != null && room != '') {
      subjects = subjects.where((s) => s.room == room).toList();
    }
    if (course != null && course != '') {
      subjects = subjects.where((s) => s.course == course).toList();
    }
    if (subjects.isEmpty) {
      return lesson.subjects;
    }
    return subjects;
  }

  /// Complete the information of this change using the timetable
  Change completed(TimetableLesson lesson) {
    final newChange = Change.fromJSON(toJSON());
    if (lesson == null) {
      return newChange;
    }
    final subjects = getMatchingSubjectsByLesson(lesson);
    if (subjects.length != 1) {
      return newChange;
    }
    final s = subjects[0];
    if (subject == null || subject == '') {
      newChange.subject = s.subject;
    }
    if (room == null || room == '') {
      newChange.room = s.room;
    }
    if (teacher == null || teacher == '') {
      newChange.teacher = s.teacher;
    }
    return newChange;
  }

  // ignore: public_member_api_docs
  DateTime date;

  // ignore: public_member_api_docs
  int unit;

  // ignore: public_member_api_docs
  String subject;

  // ignore: public_member_api_docs
  String course;

  // ignore: public_member_api_docs
  String room;

  // ignore: public_member_api_docs
  String teacher;

  // ignore: public_member_api_docs
  Changed changed;

  // ignore: public_member_api_docs
  ChangeTypes type;
}

/// Changed class
/// describes what changed in a replacement plan change
class Changed {
  // ignore: public_member_api_docs
  Changed({
    this.subject,
    this.teacher,
    this.room,
    this.info,
  });

  /// Creates a Changed object from json
  factory Changed.fromJSON(json) => Changed(
        subject: json['subject'],
        teacher: json['teacher'],
        room: json['room'],
        info: json['info'],
      );

  /// Creates json from a Changed object
  Map<String, dynamic> toJSON() => {
        'subject': subject,
        'teacher': teacher,
        'room': room,
        'info': info,
      };

  // ignore: public_member_api_docs
  String subject;

  // ignore: public_member_api_docs
  String teacher;

  // ignore: public_member_api_docs
  String room;

  // ignore: public_member_api_docs
  String info;
}

/// ChangeTypes enum
/// describes the possible types of a replacement plan change
enum ChangeTypes {
  // ignore: public_member_api_docs
  exam,
  // ignore: public_member_api_docs
  freeLesson,
  // ignore: public_member_api_docs
  changed,
}
