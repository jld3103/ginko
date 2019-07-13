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
  /// Download html replacement plan
  static Future<Document> download(bool dayOne) async {
    final response = await http.get(
      'https://viktoriaschule-aachen.de/sundvplan/vps/${dayOne ? 'left' : 'right'}.html',
      headers: Config.headers,
    );
    return parse(utf8.decode(response.bodyBytes));
  }

  /// Extract replacement plans from html
  static List<ReplacementPlanForGrade> extract(Document document) {
    final date =
        parseDate(document.querySelectorAll('div')[0].text.split(', ')[1]);
    final updatedStr =
        document.querySelectorAll('div')[1].text.split(' den ')[1];
    final updateDateParts =
        updatedStr.split(' um ')[0].split('.').map(int.parse).toList();
    final updated = DateTime(
            updateDateParts[2] + 2000, updateDateParts[1], updateDateParts[0])
        .add(Duration(
      hours: int.parse(updatedStr.split(' um ')[1].split(':')[0]),
      minutes: int.parse(updatedStr.split(' um ')[1].split(':')[1]),
    ));
    final changes = {};
    var previousGrade = '';
    for (final row in document.querySelectorAll('tr').sublist(1)) {
      final fields = row
          .querySelectorAll('td')
          .map((field) => field.children.map((a) => a.text).toList().join(' '))
          .toList();
      if (fields.length < 3) {
        continue;
      }
      var grade =
          fields[0].replaceAll('·', '').replaceAll('.', '').split(' ')[0];
      if (grade == '') {
        grade = previousGrade;
      } else {
        previousGrade = grade;
        changes[grade] = [];
      }
      if (!grades.contains(grade)) {
        continue;
      }
      final unit = int.parse(
              fields[0].replaceAll('·', '').replaceAll('.', '').split(' ')[1]) -
          1;
      var normal = fields[1].replaceAll(RegExp(r'(\(|\)|\*)'), '').trim();
      normal = normal.replaceAll(RegExp('-{2,}'), '');
      while (normal.contains('  ')) {
        normal = normal.replaceAll('  ', ' ');
      }
      if ((isSeniorGrade(grade) || normal.split(' ').length == 4) &&
          !normal.contains('Klausur')) {
        normal = normal.split(' ').sublist(1).join(' ');
      }
      var changed = fields[2].trim();
      while (changed.contains('  ')) {
        changed = changed.replaceAll('  ', ' ');
      }
      var parses = 0;
      // Parse what has changed
      if ((changed == '' &&
              !normal.contains('Klausur') &&
              !normal.contains('Reststunde') &&
              !normal.contains('Ersatzbereitschaft')) ||
          changed == 'Studienzeit' ||
          changed == 'U-frei' ||
          changed == 'abgehängt' ||
          changed == 'abwesend') {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info: 'Freistunde',
            )
            ..type = ChangeTypes.freeLesson;
          changes[grade].add(change);
          parses++;
        }
      }
      if (changed.contains('m.Aufg.')) {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info: 'Mit Aufgaben',
              teacher: changed.split(' ')[0],
            )
            ..type = ChangeTypes.withTasks;
          changes[grade].add(change);
          parses++;
        }
      }
      if (changed == 'Referendar(in)') {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info: 'Referendar*in',
            )
            ..type = ChangeTypes.trainee;
          changes[grade].add(change);
          parses++;
        }
      }
      if (changed.contains(' v. ')) {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info:
                  // ignore: lines_longer_than_80_chars
                  'Verschoben von ${changed.split(' ')[2]} ${changed.split(' ')[3]}',
              subject: changed
                  .split(' ')
                  .sublist(changed.split(' ').indexOf('mit'))[2],
              teacher: changed.split(' ')[0],
              room: changed
                          .split(' ')
                          .sublist(changed.split(' ').indexOf('mit'))
                          .length ==
                      4
                  ? changed
                      .split(' ')
                      .sublist(changed.split(' ').indexOf('mit'))[3]
                  : null,
            )
            ..type = ChangeTypes.movedFrom;
          changes[grade].add(change);
          parses++;
        }
      }
      if (changed.contains('R-Ändg.')) {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info: 'Raumänderung',
              room: changed
                  .split(' ')
                  .sublist(changed.split(' ').indexOf('R-Ändg.'))[1],
            )
            ..type = ChangeTypes.roomChanged;
          changes[grade].add(change);
          parses++;
        }
      }
      if (changed.contains('Kl-Unt.')) {
        for (final change in getNormals(date, unit, normal, changed)) {
          change
            ..changed = Changed(
              info: 'Klassenunterricht',
              room: changed.split(' ')[changed.split(' ').length - 1],
              teacher: changed.split(' ')[changed.split(' ').length - 2],
              subject: changed.split(' ')[changed.split(' ').length - 3],
            )
            ..type = ChangeTypes.classTeaching;
          changes[grade].add(change);
          parses++;
        }
      }
      if (parses == 0) {
        changes[grade] = changes[grade]
          ..addAll(getNormals(date, unit, normal, changed));
      }
      for (final change in changes[grade]) {
        if (change.changed == null) {
          throw Exception('Changed not filled: ${change.toJSON()}');
        }
        try {
          change.subject = Subjects.getSubject(change.subject);
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          if (change.exam != ChangeTypes.rewriteExam) {
            print(change.toJSON());
            rethrow;
          }
        }
        if (change.changed.subject != null) {
          try {
            change.changed.subject =
                Subjects.getSubject(change.changed.subject);
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            print(change.toJSON());
            rethrow;
          }
        }
        try {
          change.room = Rooms.getRoom(change.room);
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          if (change.exam == ChangeTypes.unknown) {
            print(change.toJSON());
            rethrow;
          }
        }
        if (change.changed.room != null) {
          try {
            change.changed.room = Rooms.getRoom(change.changed.room);
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            print(change.toJSON());
            rethrow;
          }
        }
        if (change.type == ChangeTypes.unknown) {
          throw Exception('Change type not set: ${change.toJSON()}');
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

  /// Parse what normally should have happened in the lesson
  static List<Change> getNormals(
      DateTime date, int unit, String normal, String changed) {
    final changes = [];
    if (normal.split(' ').length == 2) {
      changes.add(Change(
        date: date,
        unit: unit,
        subject: normal.split(' ')[0],
        room: normal.split(' ')[1],
      ));
    }
    if (normal.split(' ').length == 3 &&
        !normal.contains('Ersatzbereitschaft')) {
      changes.add(Change(
        date: date,
        unit: unit,
        subject: normal.split(' ')[0],
        course: normal.split(' ')[1],
        room: normal.split(' ')[2],
        type: ChangeTypes.readyForReplacement,
      ));
    }
    if (normal.contains('nach')) {
      changes.add(Change(
        date: date,
        unit: unit,
        subject: normal.split(' ')[0],
        room: normal.split(' ')[1],
        changed: Changed(
          info: 'Verschoben nach ${normal.split(' ').sublist(3).join(' ')}',
        ),
        type: ChangeTypes.movedTo,
      ));
    }

    if (normal.contains('U.entf.')) {
      final courses = normal.split(' ').sublist(2);
      for (var i = 0; i < courses.length / 4; i++) {
        changes.add(Change(
          date: date,
          unit: unit,
          subject: courses[i * 4],
          course: courses[i * 4 + 1],
          room: courses[i * 4 + 2],
          changed: Changed(
            info: 'Freistunde',
          ),
          type: ChangeTypes.freeLesson,
        ));
      }
    }

    if (normal.contains('Klausur')) {
      if (normal.contains('Nachschreiber')) {
        changes.add(Change(
          date: date,
          unit: unit,
          changed: Changed(
            info: 'Nachschreiberklausur',
            room: normal.split(' ').reversed.toList()[0],
            teacher: normal.split(':')[1].split(' ').reversed.toList()[0],
          ),
          type: ChangeTypes.rewriteExam,
        ));
      } else {
        final exams = normal.split(':')[1].trim().split(' ')..removeLast();
        final m = exams.length % 4 == 0 ? 4 : 3;
        for (var i = 0; i < exams.length / m; i++) {
          changes.add(Change(
            date: date,
            unit: unit,
            subject: exams[i * m + 2],
            teacher: exams[i * m + 1],
            course: m == 4 ? exams[i * m + 3] : null,
            changed: Changed(
              info: 'Klausur',
              room: normal.split(' ').reversed.toList()[0],
              teacher: normal.split(':')[1].split(' ').reversed.toList()[0],
            ),
            type: ChangeTypes.exam,
          ));
        }
      }
    }
    if (normal.contains('Reststunde')) {
      var a =
          normal.split(' ').sublist(0, normal.split(' ').indexOf('Reststunde'));
      if (a.length == 4) {
        a = a.sublist(1, 4);
        changes.add(Change(
          date: date,
          unit: unit,
          subject: a[0],
          course: a[1],
          room: a[2],
          changed: Changed(
            info: normal
                .split(' ')
                .sublist(normal.split(' ').indexOf('Reststunde'))
                .join(' '),
          ),
          type: ChangeTypes.remainingLesson,
        ));
      }
    }
    if (normal.contains('Ersatzbereitschaft')) {
      changes.add(Change(
        date: date,
        unit: unit,
        subject: normal.split(' ')[0],
        course: normal.split(' ').length == 4 ? normal.split(' ')[1] : null,
        room: normal.split(' ').length == 4
            ? normal.split(' ')[2]
            : normal.split(' ')[1],
        changed: Changed(
          info: 'Ersatzbereitschaft',
        ),
      ));
    }
    return changes.cast<Change>();
  }
}
