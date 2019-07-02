import 'dart:convert';
import 'dart:math';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:models/models.dart';
import 'package:models/unitplan.dart';
import 'package:server/config.dart';

// ignore: avoid_classes_with_only_static_members
/// UnitPlanData class
/// handles all unit plan parsing
class UnitPlanData {
  // ignore: public_member_api_docs
  static UnitPlan unitPlans;

  /// Load all unit plans
  static Future load() async {
    final plans = [];
    for (var i = 0; i < 2; i++) {
      final weekA = i == 0;
      plans.add(
        UnitPlan(
          unitPlans: extract(await download(weekA)),
        ),
      );
    }
    unitPlans = mergeUnitPlans(plans.cast<UnitPlan>());
  }

  /// Download html unit plan
  static Future<Document> download(bool weekA) async {
    final response = await http.get(
      'https://viktoriaschule-aachen.de/sundvplan/sps/${weekA ? 'left' : 'right'}.html',
      headers: Config.headers,
    );
    return parse(utf8.decode(response.bodyBytes));
  }

  /// Extract unit plans from html
  static List<UnitPlanForGrade> extract(Document document) {
    final date = dateFormat.parse(document
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
        }
      }
      return UnitPlanForGrade(
        date: date,
        grade: grade,
        days: table.map((column) {
          final day = table.indexOf(column);
          var lastUnit = 0;
          return UnitPlanDay(
            replacementPlan: UnitPlanDayReplacementPlan(
              weekA: null,
              updated: null,
              applies: null,
            ),
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
                          changes: <Change>[],
                          course: null,
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
                                        changes: <Change>[],
                                        course: null,
                                        room: Rooms.getRoom(subject[2] == ''
                                            ? null
                                            : subject[2]),
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
                                      changes: <Change>[],
                                      course: null,
                                      room: Rooms.getRoom(
                                          subject[2] == '' ? null : subject[2]),
                                      subject: Subjects.getSubject(
                                          subject[1] == '' ? null : subject[1]),
                                      weeks: null,
                                      teacher:
                                          subject[0] == '' ? null : subject[0],
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
                                      changes: <Change>[],
                                      course: null,
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

  /// Merge all unit plans for a and b weeks
  static UnitPlan mergeUnitPlans(List<UnitPlan> unitPlans) {
    final unitPlan = UnitPlan(
      unitPlans: grades.map((grade) {
        final days = List.generate(
            5,
            (i) => UnitPlanDay(
                  weekday: i,
                  lessons: List.generate(
                      max(
                        unitPlans[0]
                            .unitPlans
                            .where((i) => i.grade == grade)
                            .toList()[0]
                            .days[i]
                            .lessons
                            .length,
                        unitPlans[1]
                            .unitPlans
                            .where((i) => i.grade == grade)
                            .toList()[0]
                            .days[i]
                            .lessons
                            .length,
                      ),
                      (j) => Lesson(
                            subjects: <Subject>[],
                            block: unitPlans[unitPlans[0]
                                            .unitPlans
                                            .where((i) => i.grade == grade)
                                            .toList()[0]
                                            .days[i]
                                            .lessons[j]
                                            .block !=
                                        null
                                    ? 0
                                    : 1]
                                .unitPlans
                                .where((i) => i.grade == grade)
                                .toList()[0]
                                .days[i]
                                .lessons[j]
                                .block,
                            unit: j,
                          )),
                  replacementPlan: UnitPlanDayReplacementPlan(
                    applies: null,
                    weekA: null,
                    updated: null,
                  ),
                ));
        for (var day = 0; day < 5; day++) {
          final dayA = unitPlans[0]
              .unitPlans
              .where((i) => i.grade == grade)
              .toList()[0]
              .days[day];
          final dayB = unitPlans[1]
              .unitPlans
              .where((i) => i.grade == grade)
              .toList()[0]
              .days[day];
          for (var unit = 0; unit < 9; unit++) {
            final addFreeLesson = [false, false];
            Lesson lessonA;
            Lesson lessonB;
            if (dayA.lessons.length > unit) {
              lessonA = dayA.lessons[unit];
            }
            if (dayB.lessons.length > unit) {
              lessonB = dayB.lessons[unit];
            }
            if (lessonA == null && lessonB == null) {
              continue;
            }
            if (lessonA == null && lessonB != null) {
              days[day].lessons[unit] = lessonB;
              for (final subject in days[day].lessons[unit].subjects) {
                subject.weeks = 'B';
              }
              if (unit != 5) {
                addFreeLesson[0] = true;
              }
            } else if (lessonA != null && lessonB == null) {
              days[day].lessons[unit] = lessonA;
              for (final subject in days[day].lessons[unit].subjects) {
                subject.weeks = 'A';
              }
              if (unit != 5) {
                addFreeLesson[1] = true;
              }
            } else {
              days[day].lessons[unit].subjects = [];
              final listShort =
                  lessonA.subjects.length >= lessonB.subjects.length
                      ? lessonB
                      : lessonA;
              final listLong =
                  lessonA.subjects.length >= lessonB.subjects.length
                      ? lessonA
                      : lessonB;
              for (var k = 0; k < listLong.subjects.length; k++) {
                final subject1 = listLong.subjects[k];
                var found = false;
                for (var l = 0; l < listShort.subjects.length; l++) {
                  final subject2 = listShort.subjects[l];
                  if (subject1.subject == subject2.subject &&
                      subject1.teacher == subject2.teacher &&
                      subject1.room == subject2.room) {
                    subject1.weeks = 'AB';
                    days[day].lessons[unit].subjects.add(subject1);
                    listShort.subjects.removeAt(l);
                    found = true;
                    break;
                  }
                }
                if (!found) {
                  subject1.weeks =
                      lessonA.subjects.length >= lessonB.subjects.length
                          ? 'A'
                          : 'B';
                  addFreeLesson[subject1.weeks == 'B' ? 0 : 1] = true;
                  days[day].lessons[unit].subjects.add(subject1);
                }
              }
              if (listShort.subjects.isNotEmpty) {
                for (final subject in listShort.subjects) {
                  subject.weeks =
                      lessonA.subjects.length >= lessonB.subjects.length
                          ? 'B'
                          : 'A';
                  addFreeLesson[subject.weeks == 'B' ? 0 : 1] = true;
                  days[day].lessons[unit].subjects.add(subject);
                }
              }
            }
            for (var i = 0; i < addFreeLesson.length; i++) {
              if (addFreeLesson[i]) {
                days[day].lessons[unit].subjects.add(Subject(
                      weeks: i == 0 ? 'A' : 'B',
                      teacher: null,
                      subject: 'FR',
                      changes: <Change>[],
                      course: null,
                      room: null,
                      unit: unit,
                    ));
              }
            }
          }
        }
        return UnitPlanForGrade(
          date: unitPlans[0]
              .unitPlans
              .where((i) => i.grade == grade)
              .toList()[0]
              .date,
          days: days,
          grade: grade,
        );
      }).toList(),
    );
    return unitPlan;
  }
}
