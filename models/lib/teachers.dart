import 'package:meta/meta.dart';

/// Teachers class
/// describes all teachers
class Teachers {
  // ignore: public_member_api_docs
  Teachers({
    @required this.teachers,
    @required this.date,
  });

  /// Creates a Teachers object from json
  factory Teachers.fromJSON(json) => Teachers(
        teachers: json['teachers']
            .map((i) => Teacher.fromJSON(i))
            .toList()
            .cast<Teacher>(),
        date: DateTime.parse(json['date']),
      );

  /// Creates json from a Teachers object
  Map<String, dynamic> toJSON() => {
        'teachers': teachers.map((i) => i.toJSON()).toList(),
        'date': date.toIso8601String(),
      };

  /// Get the time stamp of this object
  int get timeStamp => date.millisecondsSinceEpoch ~/ 1000;

  /// Get the regex to match all teachers
  String get regex =>
      // ignore: lines_longer_than_80_chars
      '(${teachers.map((teacher) => teacher.shortName.toLowerCase().replaceAll('ä', 'a').replaceAll('ö', 'o').replaceAll('ü', 'u')).join('|')})';

  // ignore: public_member_api_docs
  final List<Teacher> teachers;

  // ignore: public_member_api_docs
  final DateTime date;
}

/// Teacher class
/// describes one teacher
class Teacher {
  // ignore: public_member_api_docs
  Teacher({@required this.shortName});

  /// Creates a Teacher object from json
  factory Teacher.fromJSON(json) => Teacher(
        shortName: json['shortName'],
      );

  /// Creates json from a Teacher object
  Map<String, dynamic> toJSON() => {
        'shortName': shortName,
      };

  // ignore: public_member_api_docs
  final String shortName;
}
