import 'package:meta/meta.dart';

/// Change class
/// describes all replacement plans for all grades
class ReplacementPlan {
  // ignore: public_member_api_docs
  ReplacementPlan({
    @required this.replacementPlans,
  });

  /// Creates a ReplacementPlan object from json
  factory ReplacementPlan.fromJSON(json) => ReplacementPlan(
        replacementPlans: json['replacementPlans']
            .map((i) => ReplacementPlanForGrade.fromJSON(i))
            .toList()
            .cast<ReplacementPlanForGrade>(),
      );

  /// Creates json from a ReplacementPlan object
  Map<String, dynamic> toJSON() => {
        'replacementPlans': replacementPlans.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  List<ReplacementPlanForGrade> replacementPlans;
}

/// ReplacementPlanForGrade class
/// describes a replacement plan for one grade
class ReplacementPlanForGrade {
  // ignore: public_member_api_docs
  ReplacementPlanForGrade({
    @required this.grade,
    @required this.replacementPlanDays,
    @required this.changes,
  });

  /// Creates a ReplacementPlanForGrade object from json
  factory ReplacementPlanForGrade.fromJSON(json) => ReplacementPlanForGrade(
        grade: json['grade'],
        replacementPlanDays: json['replacementPlanDays']
            .map((i) => ReplacementPlanDay.fromJSON(i))
            .toList()
            .cast<ReplacementPlanDay>(),
        changes: json['changes']
            .map((i) => Change.fromJSON(i))
            .toList()
            .cast<Change>(),
      );

  /// Creates json from a ReplacementPlanForGrade object
  Map<String, dynamic> toJSON() => {
        'grade': grade,
        'replacementPlanDays':
            replacementPlanDays.map((i) => i.toJSON()).toList(),
        'changes': changes.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  int get timeStamp =>
      replacementPlanDays[0].date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  String grade;

  // ignore: public_member_api_docs
  List<ReplacementPlanDay> replacementPlanDays;

  // ignore: public_member_api_docs
  List<Change> changes;
}

/// ReplacementPlanDay class
/// describes the day of a replacement plan
class ReplacementPlanDay {
  // ignore: public_member_api_docs
  ReplacementPlanDay({
    @required this.date,
    @required this.updated,
  });

  /// Creates a ReplacementPlanDay object from json
  factory ReplacementPlanDay.fromJSON(json) => ReplacementPlanDay(
        date: DateTime.parse(json['date']),
        updated: DateTime.parse(json['updated']),
      );

  /// Creates json from a ReplacementPlanDay object
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
    this.subject,
    this.course,
    this.room,
    this.teacher,
    this.changed,
    this.type = ChangeTypes.unknown,
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
        'type': type.index,
      };

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
  unknown,
  // ignore: public_member_api_docs
  exam,
  // ignore: public_member_api_docs
  rewriteExam,
  // ignore: public_member_api_docs
  freeLesson,
  // ignore: public_member_api_docs
  withTasks,
  // ignore: public_member_api_docs
  trainee,
  // ignore: public_member_api_docs
  movedFrom,
  // ignore: public_member_api_docs
  movedTo,
  // ignore: public_member_api_docs
  roomChanged,
  // ignore: public_member_api_docs
  classTeaching,
  // ignore: public_member_api_docs
  remainingLesson,
  // ignore: public_member_api_docs
  readyForReplacement, // Shouldn't be on the pupils replacement plan
}
