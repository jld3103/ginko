import 'package:meta/meta.dart';

/// Change class
/// describes a change in a subject
class Change {
  // ignore: public_member_api_docs
  Change({
    @required this.unit,
    @required this.subject,
    @required this.course,
    @required this.room,
    @required this.teacher,
    @required this.changed,
    @required this.sure,
    @required this.exam,
  });

  /// Creates a Change object from json
  factory Change.fromJSON(json) => Change(
        unit: json['unit'],
        subject: json['subject'],
        course: json['course'],
        room: json['room'],
        teacher: json['teacher'],
        changed: Changed.fromJSON(json['changed']),
        sure: json['sure'],
        exam: ExamTypes.values[json['exam']],
      );

  /// Creates json from a Change object
  Map<String, dynamic> toJSON() => {
        'unit': unit,
        'subject': subject,
        'course': course,
        'room': room,
        'teacher': teacher,
        'changed': changed.toJSON(),
        'sure': sure,
        'exam': exam.index,
      };

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
  bool sure;

  // ignore: public_member_api_docs
  ExamTypes exam;
}

/// Changed class
/// describes what changed in a replacement plan change
class Changed {
  // ignore: public_member_api_docs
  Changed({
    @required this.subject,
    @required this.teacher,
    @required this.room,
    @required this.info,
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

/// ExamTypes enum
/// describes the possible exam types of a replacement plan change
enum ExamTypes {
  /// Not an exam
  none,

  /// Normal exam
  exam,

  /// Rewrite exam
  rewriteExam,
}
