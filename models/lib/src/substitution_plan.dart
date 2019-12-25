import 'package:meta/meta.dart';
import 'package:models/models.dart';

/// SubstitutionPlan class
/// describes all substitution plans for all grades
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
/// describes a substitution plan for one grade
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
            .map((i) => SubstitutionPlanChange.fromJSON(i))
            .toList()
            .cast<SubstitutionPlanChange>(),
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
  List<SubstitutionPlanChange> changes;
}

/// SubstitutionPlanDay class
/// describes the day of a substitution plan
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

/// SubstitutionPlanChange class
/// describes a change in a subject
class SubstitutionPlanChange {
  // ignore: public_member_api_docs
  SubstitutionPlanChange({
    @required this.date,
    @required this.unit,
    @required this.changed,
    @required this.subject,
    @required this.room,
    @required this.teacher,
    @required this.type,
    this.course,
  });

  /// Creates a SubstitutionPlanChange object from json
  factory SubstitutionPlanChange.fromJSON(json) => SubstitutionPlanChange(
        date: DateTime.parse(json['date']),
        unit: json['unit'],
        subject: json['subject'],
        course: json['course'],
        room: json['room'],
        teacher: json['teacher'],
        changed: SubstitutionPlanChanged.fromJSON(json['changed']),
        type: SubstitutionPlanChangeTypes.values[json['type']],
      );

  /// Creates json from a SubstitutionPlanChange object
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

  /// Checks if a subject matches this change
  bool subjectMatches(TimetableSubject s) {
    if (s.unit != unit) {
      return false;
    }
    var subjects = [s];
    if (subject != null &&
        subject != '' &&
        !subjects
            .map((s) => s.subject == null || s.subject == '')
            .toList()
            .contains(true)) {
      subjects = subjects.where((s) => s.subject == subject).toList();
    }
    if (teacher != null &&
        teacher != '' &&
        !subjects
            .map((s) => s.teachers == null || s.teachers.isNotEmpty)
            .toList()
            .contains(true)) {
      subjects = subjects.where((s) => s.teachers.contains(teacher)).toList();
    }
    if (room != null &&
        room != '' &&
        !subjects
            .map((s) => s.room == null || s.room == '')
            .toList()
            .contains(true)) {
      subjects = subjects.where((s) => s.room == room).toList();
    }
    if (course != null &&
        course != '' &&
        !subjects
            .map((s) => s.course == null || s.course == '')
            .toList()
            .contains(true)) {
      subjects = subjects.where((s) => s.course == course).toList();
    }
    return subjects.isNotEmpty;
  }

  /// Complete the information of this change using a lesson
  SubstitutionPlanChange completedByLesson(TimetableLesson lesson) {
    if (lesson == null) {
      return SubstitutionPlanChange.fromJSON(toJSON());
    }
    final subjects = lesson.subjects.where(subjectMatches).toList();
    if (subjects.length != 1) {
      return SubstitutionPlanChange.fromJSON(toJSON());
    }
    final s = subjects[0];
    return completedBySubject(s);
  }

  /// Complete the information of this change using a subject
  SubstitutionPlanChange completedBySubject(TimetableSubject s) {
    final newChange = SubstitutionPlanChange.fromJSON(toJSON());
    if (subject == null || subject == '') {
      newChange.subject = s.subject;
    }
    if (room == null || room == '') {
      newChange.room = s.room;
    }
    if (teacher == null || teacher.isEmpty) {
      newChange.teacher = s.teachers[0];
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
  SubstitutionPlanChanged changed;

  // ignore: public_member_api_docs
  SubstitutionPlanChangeTypes type;
}

/// SubstitutionPlanChanged class
/// describes what changed in a substitution plan change
class SubstitutionPlanChanged {
  // ignore: public_member_api_docs
  SubstitutionPlanChanged({
    this.subject,
    this.teacher,
    this.room,
    this.info,
  });

  /// Creates a SubstitutionPlanChanged object from json
  factory SubstitutionPlanChanged.fromJSON(json) => SubstitutionPlanChanged(
        subject: json['subject'],
        teacher: json['teacher'],
        room: json['room'],
        info: json['info'],
      );

  /// Creates json from a SubstitutionPlanChanged object
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

/// SubstitutionPlanChangeTypes enum
/// describes the possible types of a substitution plan change
enum SubstitutionPlanChangeTypes {
  // ignore: public_member_api_docs
  exam,
  // ignore: public_member_api_docs
  freeLesson,
  // ignore: public_member_api_docs
  changed,
}
