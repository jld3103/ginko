import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:server/config.dart';

// ignore: avoid_classes_with_only_static_members
/// UnitPlanParser class
/// handles all unit plan parsing
class UnitPlanParser {
  /// Download html unit plan
  static Future<Document> download(bool weekA) async {
    final response = await http
        .get(
          'https://viktoriaschule-aachen.de/sundvplan/sps/${weekA ? 'left' : 'right'}.html',
          headers: Config.replacementPlanHeaders,
        )
        .timeout(Duration(seconds: 3));
    return parse(utf8.decode(response.bodyBytes));
  }

  /// Extract unit plans from html
  static List<UnitPlanForGrade> extract(Document document) {
    final date = parseDate(document
        .querySelector('div')
        .text
        .split(' den ')[1]
        .trim()
        .split('')
        .reversed
        .join('')
        .toString()
        .replaceFirst('.', '02.')
        .split('')
        .reversed
        .join(''));
    return grades.map((grade) {
      final table = List.generate(5, (i) => List.generate(9, (i) => []));
      final rows = document
          .querySelectorAll('table')[grades.indexOf(grade)]
          .children[0]
          .children
        ..removeAt(0);
      for (final row in rows) {
        final items = row.children..removeAt(0);
        for (final item in items) {
          table[items.indexOf(item)][rows.indexOf(row)] =
              item.children.map((i) {
            var text = i.text.trim();
            while (text.contains('  ')) {
              text = text.replaceAll('  ', ' ');
            }
            return text;
          }).toList();
          if (table[items.indexOf(item)][rows.indexOf(row)][0].contains('*')) {
            table[items.indexOf(item)][rows.indexOf(row)] = [' FR '];
          }
        }
      }
      return UnitPlanForGrade(
        date: date,
        grade: grade,
        days: table.map((column) {
          final day = table.indexOf(column);
          var lastUnit = 0;
          return UnitPlanDay(
            weekday: day,
            lessons: column.reversed
                .map((lesson) {
                  final unit = column.indexOf(lesson);
                  String block;
                  if (lesson.isNotEmpty) {
                    block = lesson[0].toString().startsWith('Bl ')
                        ? lesson[0].split(' ')[1]
                        : lesson[0].toString() == 'Bl' ? '' : null;
                    if (block != null) {
                      lesson = lesson..removeAt(0);
                    }
                  }
                  if (lesson[0].length > 0 && unit > lastUnit) {
                    lastUnit = unit;
                  }
                  if (unit == 5) {
                    return Lesson(
                      block: block == null || block == ''
                          ? '$grade-$day-$unit'
                          : block,
                      unit: unit,
                      subjects: [
                        Subject(
                          weeks: null,
                          teacher: null,
                          room: null,
                          subject: 'MIT',
                          unit: 5,
                        )
                      ],
                    );
                  }
                  return Lesson(
                    block: block == null || block == ''
                        ? '$grade-$day-$unit'
                        : block,
                    unit: unit,
                    subjects: ((lesson[0].length > 0
                                ? lesson.map((subject) {
                                    subject = subject.split(' ');
                                    while (subject.length < 3) {
                                      subject.add('');
                                    }
                                    if (block != null) {
                                      return Subject(
                                        room: Rooms.getRoom(subject[2]),
                                        subject: Subjects.getSubject(
                                            subject[0] == ''
                                                ? null
                                                : subject[0]),
                                        weeks: null,
                                        teacher: subject[1] == ''
                                            ? null
                                            : subject[1],
                                        unit: unit,
                                      );
                                    }
                                    return Subject(
                                      room: Rooms.getRoom(subject[2]),
                                      subject: Subjects.getSubject(subject[1]),
                                      weeks: null,
                                      teacher: subject[0],
                                      unit: unit,
                                    );
                                  }).toList()
                                : [])
                            .cast<Subject>()
                              ..add(grades.indexOf(grade) >= 15
                                  ? Subject(
                                      weeks: null,
                                      teacher: null,
                                      subject: 'FR',
                                      room: null,
                                      unit: unit,
                                    )
                                  : null))
                        .where((subject) => subject != null)
                        .toList(),
                  );
                })
                .toList()
                .reversed
                .toList()
                .where((lesson) => lesson.unit <= lastUnit)
                .toList(),
          );
        }).toList(),
      );
    }).toList();
  }
}
