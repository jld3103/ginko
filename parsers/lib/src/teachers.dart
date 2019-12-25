import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// TeachersParser class
/// handles all teachers parsing
class TeachersParser {
  /// Extract teachers
  static Teachers extract(List<List<String>> table) {
    final teachers = {};
    table.where((line) => line[0].startsWith('L1') && line[2] != '?').forEach(
        (line) =>
            teachers[line[2].toLowerCase()] = line[3].replaceAll('"', ''));
    return Teachers(
      date: DateTime(2019, 12, 21),
      teachers: teachers.cast<String, String>(),
    );
  }
}
