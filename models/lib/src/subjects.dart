import 'package:meta/meta.dart';

/// Subjects class
/// describes all subjects
class Subjects {
  // ignore: public_member_api_docs
  Subjects({
    @required this.subjects,
    @required this.date,
  });

  /// Creates a Subjects object from json
  factory Subjects.fromJSON(json) => Subjects(
        subjects: json['subjects'].cast<String, String>(),
        date: DateTime.parse(json['date']),
      );

  /// Creates json from a Subjects object
  Map<String, dynamic> toJSON() => {
        'subjects': subjects,
        'date': date.toIso8601String(),
      };

  /// Get the time stamp of this object
  int get timeStamp => date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  final Map<String, String> subjects;

  // ignore: public_member_api_docs
  final DateTime date;
}
