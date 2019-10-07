import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:models/replacementplan.dart';
import 'package:server/config.dart';

// ignore: avoid_classes_with_only_static_members
/// ReplacementPlanParser class
/// handles all replacement plan parsing
class ReplacementPlanParser {
  static const _arrow = '→';

  /// Download html replacement plan
  static Future<Document> download(bool dayOne) async {
    final response = await http
        .get(
          'https://viktoriaschule-aachen.de/sundvplan/vps/f${dayOne ? '1' : '2'}/subst_001.htm',
          headers: Config.replacementPlanHeaders,
        )
        .timeout(Duration(seconds: 3));
    return parse(utf8.decode(response.bodyBytes));
  }

  /// Extract replacement plans from html
  static List<ReplacementPlanForGrade> extract(Document document) {
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
              var type = ChangeTypes.unknown;
              if (fields[3] == 'Entfall') {
                type = ChangeTypes.freeLesson;
              } else if (fields[3] == 'Klausur') {
                type = ChangeTypes.exam;
              } else {
                type = ChangeTypes.replaced;
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
    for (final grade in changes.keys) {
      for (final change in changes[grade]) {
        try {
          change.subject = Subjects.getSubject(change.subject);
          if (change.changed.subject != null) {
            change.changed.subject =
                Subjects.getSubject(change.changed.subject);
          }
          change.room = Rooms.getRoom(change.room);
          if (change.changed.room != null) {
            change.changed.room = Rooms.getRoom(change.changed.room);
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(change.toJSON());
        }
      }
    }
    return grades
        .map((grade) => ReplacementPlanForGrade(
              grade: grade,
              replacementPlanDays: [
                ReplacementPlanDay(
                  date: date,
                  updated: updated,
                ),
              ],
              changes: (changes[grade] ?? []).cast<Change>(),
            ))
        .toList();
  }
}
