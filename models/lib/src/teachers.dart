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
        teachers: json['teachers'].cast<String>(),
        date: DateTime.parse(json['date']),
      );

  /// Creates json from a Teachers object
  Map<String, dynamic> toJSON() => {
        'teachers': teachers,
        'date': date.toIso8601String(),
      };

  /// Get the time stamp of this object
  int get timeStamp => date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  final List<String> teachers;

  // ignore: public_member_api_docs
  final DateTime date;
}
