import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// SubstitutionPlanParser class
/// handles all replacement plan parsing
class SubstitutionPlanParser {
  static const _arrow = '→';
  static final Dio _dio = Dio();

  /// Download html replacement plan
  static Future<Document> download(
      bool dayOne, String username, String password) async {
    final response = await _dio
        .get(
          'https://viktoriaschule-aachen.de/sundvplan/vps/f${dayOne ? '1' : '2'}/subst_001.htm',
          options: Options(
            headers: {
              'authorization':
                  'Basic ${base64Encode(utf8.encode('$username:$password'))}',
            },
          ),
        )
        .timeout(Duration(seconds: 10));
    return parse(response.toString());
  }

  /// Extract replacement plans from html
  static List<SubstitutionPlanForGrade> extract(Document document) {
    final date =
        parseDate(document.querySelector('.mon_title').text.split(' ')[0]);
    final updatedStr = document
        .querySelector('html')
        .children[1]
        .text
        .split('\n')[0]
        .split(': ')[1];
    final updated = parseDate(updatedStr.split(' ')[0]).add(Duration(
      hours: int.parse(updatedStr.split(' ')[1].split(':')[0]),
      minutes: int.parse(updatedStr.split(' ')[1].split(':')[1]),
    ));
    final changes = {};
    for (final row in document
        .querySelector('.mon_list')
        .querySelectorAll('tr')
        .sublist(1)) {
      final fields =
          row.querySelectorAll('td').map((field) => field.text).toList();
      for (final grade
          in fields[0].replaceAll(_arrow, ', ').split(', ').toSet().toList()) {
        try {
          if (!grades.contains(grade)) {
            continue;
          }
          if (changes[grade] == null) {
            changes[grade] = [];
          }
          final units = fields[1].split('-').map((u) {
            var unit = int.parse(u.trim()) - 1;
            if (unit > 4) {
              unit++;
            }
            return unit;
          });
          for (final unit in units) {
            try {
              ChangeTypes type;
              if (fields[3] == 'Entfall') {
                type = ChangeTypes.freeLesson;
              } else if (fields[3] == 'Klausur') {
                type = ChangeTypes.exam;
              } else {
                type = ChangeTypes.changed;
              }
              while (fields[2].contains('  ')) {
                fields[2] = fields[2].replaceAll('  ', ' ').trim();
              }
              final change = Change(
                date: date,
                unit: unit,
                subject: fields[2].split(_arrow)[0] != '---' &&
                        fields[2].split(_arrow)[0].split(' ').length > 1
                    ? fields[2].split(_arrow)[0].split(' ')[0].trim()
                    : null,
                course: fields[2].split(_arrow)[0] != '---' &&
                        fields[2].split(_arrow)[0].split(' ').length > 1
                    ? fields[2].split(_arrow)[0].split(' ')[1].trim()
                    : null,
                room: fields[5].split(_arrow)[0] != '---'
                    ? fields[5].split(_arrow)[0].trim()
                    : null,
                teacher: fields[4].split(_arrow)[0] != '---'
                    ? fields[4].split(_arrow)[0].trim()
                    : null,
                changed: Changed(
                  subject: fields[2].split(_arrow).length > 1 &&
                          fields[2].split(_arrow)[1] != '---'
                      ? fields[2].split(_arrow)[1].trim()
                      : null,
                  teacher: fields[4].split(_arrow).length > 1 &&
                          fields[4].split(_arrow)[1] != '---'
                      ? fields[4].split(_arrow)[1].trim()
                      : null,
                  room: fields[5].split(_arrow).length > 1 &&
                          fields[5].split(_arrow)[1] != '---'
                      ? fields[5].split(_arrow)[1].trim()
                      : null,
                  info: fields[6].trim() != '' ? fields[6].trim() : null,
                ),
                type: type,
              );
              changes[grade].add(change);
              // ignore: avoid_catches_without_on_clauses
            } catch (e) {
              print(e);
            }
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
        }
      }
    }
    return grades
        .map((grade) => SubstitutionPlanForGrade(
              grade: grade,
              substitutionPlanDays: [
                SubstitutionPlanDay(
                  date: date,
                  updated: updated,
                ),
              ],
              changes: (changes[grade] ?? []).cast<Change>(),
            ))
        .toList();
  }
}
