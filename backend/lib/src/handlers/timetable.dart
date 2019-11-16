import 'dart:convert';
import 'dart:math';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// TimetableHandler class
class TimetableHandler extends Handler {
  // ignore: public_member_api_docs
  TimetableHandler(MySqlConnection mySqlConnection)
      : super(Keys.timetable, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_timetable ORDER BY date_time DESC LIMIT 2;');
    final timetable = _mergeTimetables(results
            .toList()
            .map((row) => Timetable.fromJSON(json.decode(row[0].toString())))
            .toList()
            .cast<Timetable>())
        .timetables
        .where((timetable) => timetable.grade == user.grade)
        .single;
    return Tuple2(timetable.toJSON(), timetable.date.toIso8601String());
  }

  /// Update the data from the website into the database
  @override
  Future update() async {
    final timetables = [
      Timetable(
        timetables: TimetableParser.extract(
          await TimetableParser.download(
            true,
            Config.websiteUsername,
            Config.websitePassword,
          ),
        ),
      ),
      Timetable(
        timetables: TimetableParser.extract(
          await TimetableParser.download(
            false,
            Config.websiteUsername,
            Config.websitePassword,
          ),
        ),
      ),
    ];
    for (final timetable in timetables) {
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_timetable (date_time, week_a, data) VALUES (\'${timetable.timetables[0].date.toIso8601String()}\', ${timetables.indexOf(timetable) == 1 ? 'TRUE' : 'FALSE'}, \'${json.encode(timetable.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(timetable.toJSON())}\';');
    }
  }

  static Timetable _mergeTimetables(List<Timetable> timetables) {
    final timetable = Timetable(
      timetables: grades.map((grade) {
        final days = List.generate(
            5,
            (i) => TimetableDay(
                  weekday: i,
                  lessons: List.generate(
                      max(
                        timetables[0]
                            .timetables
                            .where((i) => i.grade == grade)
                            .toList()[0]
                            .days[i]
                            .lessons
                            .length,
                        timetables[1]
                            .timetables
                            .where((i) => i.grade == grade)
                            .toList()[0]
                            .days[i]
                            .lessons
                            .length,
                      ),
                      (j) => Lesson(
                            subjects: [],
                            block: timetables[timetables[0]
                                            .timetables
                                            .where((i) => i.grade == grade)
                                            .toList()[0]
                                            .days[i]
                                            .lessons[j]
                                            .block !=
                                        null
                                    ? 0
                                    : 1]
                                .timetables
                                .where((i) => i.grade == grade)
                                .toList()[0]
                                .days[i]
                                .lessons[j]
                                .block,
                            unit: j,
                          )),
                ));
        for (var day = 0; day < 5; day++) {
          final dayA = timetables[0]
              .timetables
              .where((i) => i.grade == grade)
              .toList()[0]
              .days[day];
          final dayB = timetables[1]
              .timetables
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
        return TimetableForGrade(
          date: timetables[0]
              .timetables
              .where((i) => i.grade == grade)
              .toList()[0]
              .date,
          days: days,
          grade: grade,
        );
      }).toList(),
    );
    return timetable;
  }
}
