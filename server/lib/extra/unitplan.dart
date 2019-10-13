import 'dart:math';

import 'package:models/models.dart';

/// UnitPlanExtra class
/// extras for unit plan parsing
class UnitPlanExtra {
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
                            subjects: [],
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
            if (addFreeLesson[0] && addFreeLesson[1]) {
              days[day].lessons[unit].subjects.add(Subject(
                    weeks: 'AB',
                    teacher: null,
                    subject: 'FR',
                    room: null,
                    unit: unit,
                  ));
            } else {
              for (var i = 0; i < addFreeLesson.length; i++) {
                if (addFreeLesson[i]) {
                  days[day].lessons[unit].subjects.add(Subject(
                        weeks: i == 0 ? 'A' : 'B',
                        teacher: null,
                        subject: 'FR',
                        room: null,
                        unit: unit,
                      ));
                }
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
