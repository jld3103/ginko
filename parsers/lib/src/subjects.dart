import 'package:models/models.dart';
import 'package:parsers/parsers.dart';

// ignore: avoid_classes_with_only_static_members
/// SubjectsParser class
/// handles all subjects parsing
class SubjectsParser {
  /// Extract subjects
  static Subjects extract(List<List<String>> table) {
    final subjects = {};
    table.where((line) => line[0].startsWith('F1')).forEach((line) =>
        subjects[line[2].toLowerCase().replaceAll(RegExp('[0-9]'), '')] =
            line[3].replaceAll('"', ''));
    subjects.addAll({
      'fr': 'Freistunde',
      'kl': 'Klausur',
      'ae': 'Änderung',
      'mit': 'Mittagspause',
      'f': 'Französisch',
      'l': 'Latein',
      's': 'Spanisch',
      'sw': 'Sozialwissenschaften',
      'ku': 'Kunst', // Only to be fancy
      'iv': 'Musik',
      'none': 'Keine Stunde ausgewählt',
      '': '',
    });
    return Subjects(
      date: UNSTFDate,
      subjects: subjects.cast<String, String>(),
    );
  }
}
