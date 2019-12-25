import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Timetable', () {
    test('Can create subject', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      expect(subject.teachers, ['kra', 'bdn']);
      expect(subject.subject, 'ek');
      expect(subject.room, '525');
      expect(subject.course, 'g1');
      expect(subject.unit, 0);
      expect(
        subject.identifier,
        '${subject.teachers.join('+')}-${subject.subject}',
      );
    });

    test('Can create subject from JSON', () {
      final subject = TimetableSubject.fromJSON({
        'teachers': ['kra', 'bdn'],
        'subject': 'ek',
        'room': '525',
        'course': 'g1',
        'changes': [],
      }, 0);
      expect(subject.teachers, ['kra', 'bdn']);
      expect(subject.subject, 'ek');
      expect(subject.room, '525');
      expect(subject.course, 'g1');
      expect(subject.unit, 0);
      expect(
        subject.identifier,
        '${subject.teachers.join('+')}-${subject.subject}',
      );
    });

    test('Can create JSON from subject', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      expect(
        subject.toJSON(),
        {
          'teachers': ['kra', 'bdn'],
          'subject': 'ek',
          'room': '525',
          'course': 'g1',
        },
      );
    });

    test('Can create subject from JSON from subject', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      expect(
        TimetableSubject.fromJSON(subject.toJSON(), 0).toJSON(),
        subject.toJSON(),
      );
    });

    test('Can apply filter', () {
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
        substitutionPlanDays: [
          SubstitutionPlanDay(
            date: DateTime(2019, 7, 8),
            updated: DateTime(2019, 7, 8, 7, 55),
          ),
        ],
        changes: [
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'ek',
            room: '525',
            teacher: 'kra',
            changed: SubstitutionPlanChanged(),
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'ek',
            changed: SubstitutionPlanChanged(),
            room: null,
            teacher: null,
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            room: '525',
            changed: SubstitutionPlanChanged(),
            subject: null,
            teacher: null,
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            teacher: 'kra',
            changed: SubstitutionPlanChanged(),
            subject: null,
            room: null,
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'pk',
            room: '525',
            teacher: 'kra',
            changed: SubstitutionPlanChanged(),
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'ek',
            room: '526',
            teacher: 'kra',
            changed: SubstitutionPlanChanged(),
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'ek',
            room: '525',
            teacher: 'bdn',
            changed: SubstitutionPlanChanged(),
            type: SubstitutionPlanChangeTypes.changed,
          ),
          SubstitutionPlanChange(
            date: DateTime(2019, 7, 8),
            unit: 1,
            subject: 'ek',
            room: '525',
            teacher: 'kra',
            changed: SubstitutionPlanChanged(),
            type: SubstitutionPlanChangeTypes.changed,
          ),
        ],
      );
      final subject = TimetableSubject(
        subject: 'ek',
        room: '525',
        teachers: ['kra', 'bdn'],
        unit: 0,
      );
      expect(
        subject
            .getMatchingChanges(substitutionPlanForGrade)
            .map((change) => change.toJSON())
            .toList()
            .length,
        5,
      );
    });

    test('Can create lesson', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [subject],
      );
      expect(lesson.unit, 0);
      expect(lesson.block, 'test');
      expect(
        lesson.subjects.map((subject) => subject.toJSON()).toList(),
        [subject.toJSON()],
      );
    });

    test('Can create lesson from JSON', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      final lesson = TimetableLesson.fromJSON({
        'unit': 0,
        'block': 'test',
        'subjects': [subject.toJSON()],
      });
      expect(lesson.unit, 0);
      expect(lesson.block, 'test');
      expect(
        lesson.subjects.map((subject) => subject.toJSON()).toList(),
        [subject.toJSON()],
      );
    });

    test('Can create JSON from lesson', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [subject],
      );
      expect(
        lesson.toJSON(),
        {
          'unit': 0,
          'block': 'test',
          'subjects': [subject.toJSON()],
        },
      );
    });

    test('Can create lesson from JSON from lesson', () {
      final subject = TimetableSubject(
        teachers: ['kra', 'bdn'],
        subject: 'ek',
        room: '525',
        course: 'g1',
        unit: 0,
      );
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [subject],
      );
      expect(
        TimetableLesson.fromJSON(lesson.toJSON()).toJSON(),
        lesson.toJSON(),
      );
    });

    test('Can create timetable day', () {
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(timetableDay.weekday, 0);
      expect(
        timetableDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create timetable day from JSON', () {
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final timetableDay = TimetableDay.fromJSON({
        'weekday': 0,
        'lessons': [lesson.toJSON()],
      });
      expect(timetableDay.weekday, 0);
      expect(
        timetableDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create JSON from timetable day', () {
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(
        timetableDay.toJSON(),
        {
          'weekday': 0,
          'lessons': [lesson.toJSON()],
        },
      );
    });

    test('Can create timetable day from JSON from timetable day', () {
      final lesson = TimetableLesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(
        TimetableDay.fromJSON(timetableDay.toJSON()).toJSON(),
        timetableDay.toJSON(),
      );
    });

    test('Get correct lesson count', () {
      final selection = Selection([
        SelectionValue('a', 'kra+bdn-ek'),
        SelectionValue('b', 'kra+bdn-ek'),
        SelectionValue('c', 'kra+bdn-ek'),
        SelectionValue('d', 'kra+bdn-ek'),
        SelectionValue('e', 'kra+bdn-ek'),
        SelectionValue('f', 'null-mit'),
        SelectionValue('g', 'kra+bdn-ek'),
        SelectionValue('h', 'kra+bdn-ek'),
        SelectionValue('i', 'kra+bdn-ek'),
        SelectionValue('j', 'kra+bdn-ek'),
        SelectionValue('k', 'kra+bdn-ek'),
        SelectionValue('l', 'kra+bdn-ek'),
        SelectionValue('m', 'null-mit'),
        SelectionValue('n', 'sta-ek'),
        SelectionValue('o', 'kra+bdn-ek'),
        SelectionValue('p', 'null-fr'),
        SelectionValue('q', 'kra+bdn-ek'),
      ]);
      final days = [
        TimetableDay(
          weekday: 0,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 'a',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 'b',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 2,
              block: 'c',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 3,
              block: 'd',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 4,
              block: 'e',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 5,
              block: 'f',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'mit',
                ),
              ],
            ),
            TimetableLesson(
              unit: 6,
              block: 'g',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 1,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 'h',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 'i',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 2,
              block: 'j',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 3,
              block: 'k',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 4,
              block: 'l',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 5,
              block: 'm',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'mit',
                ),
              ],
            ),
            TimetableLesson(
              unit: 6,
              block: 'n',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 2,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 'o',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 'p',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'fr',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 3,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 'q',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 'r',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 4,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 's',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 't',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 5,
          lessons: [
            TimetableLesson(
              unit: 0,
              block: 'u',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
            TimetableLesson(
              unit: 1,
              block: 'v',
              subjects: [
                // ignore: missing_required_param
                TimetableSubject(
                  subject: 'ek',
                  teachers: ['kra', 'bdn'],
                ),
              ],
            ),
          ],
        ),
      ];
      expect(days[0].userLessonsCount(selection), 7);
      expect(days[1].userLessonsCount(selection), 5);
      expect(days[2].userLessonsCount(selection), 1);
      expect(days[3].userLessonsCount(selection), 1);
      expect(days[4].userLessonsCount(selection), 2);
    });

    test('Can create timetable for grade', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      expect(timetableForGrade.grade, 'ef');
      expect(
        timetableForGrade.date,
        DateTime(2019, 6, 30),
      );
      expect(
        timetableForGrade.days.map((day) => day.toJSON()).toList(),
        [timetableDay.toJSON()],
      );
      expect(
        timetableForGrade.timeStamp,
        timetableForGrade.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create timetable for grade from JSON', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade.fromJSON({
        'grade': 'ef',
        'date': DateTime(2019, 6, 30).toIso8601String(),
        'days': [timetableDay.toJSON()],
      });
      expect(timetableForGrade.grade, 'ef');
      expect(
        timetableForGrade.date,
        DateTime(2019, 6, 30),
      );
      expect(
        timetableForGrade.days.map((day) => day.toJSON()).toList(),
        [timetableDay.toJSON()],
      );
      expect(
        timetableForGrade.timeStamp,
        timetableForGrade.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from timetable for grade', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      expect(
        timetableForGrade.toJSON(),
        {
          'grade': 'ef',
          'date': DateTime(2019, 6, 30).toIso8601String(),
          'days': [timetableDay.toJSON()],
        },
      );
    });

    test(
        // ignore: prefer_adjacent_string_concatenation
        'Can create timetable for grade from JSON' +
            ' from timetable for grade', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      expect(
        TimetableForGrade.fromJSON(timetableForGrade.toJSON()).toJSON(),
        timetableForGrade.toJSON(),
      );
    });

    test('Can get correct initial day', () {
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [
          TimetableDay(
            weekday: 0,
            lessons: [
              TimetableLesson(
                block: 'a',
                unit: 0,
                subjects: [
                  // ignore: missing_required_param
                  TimetableSubject(
                    subject: 'ek',
                    teachers: ['kra', 'bdn'],
                  ),
                ],
              ),
            ],
          ),
          TimetableDay(
            weekday: 1,
            lessons: [],
          ),
          TimetableDay(
            weekday: 2,
            lessons: [],
          ),
          TimetableDay(
            weekday: 3,
            lessons: [],
          ),
          TimetableDay(
            weekday: 4,
            lessons: [
              TimetableLesson(
                block: 'b',
                unit: 0,
                subjects: [
                  // ignore: missing_required_param
                  TimetableSubject(
                    subject: 'ek',
                    teachers: ['kra', 'bdn'],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      final selection = Selection([
        SelectionValue('a', 'kra+bdn-ek'),
        SelectionValue('b', 'kra+bdn-ek'),
      ]);
      expect(
        timetableForGrade.initialDay(selection, DateTime(2019, 8, 10)),
        DateTime(2019, 8, 12),
      );
      expect(
        timetableForGrade.initialDay(selection, DateTime(2019, 8, 12, 8, 59)),
        DateTime(2019, 8, 12),
      );
      expect(
        timetableForGrade.initialDay(selection, DateTime(2019, 8, 12, 9, 1)),
        DateTime(2019, 8, 13),
      );
      expect(
        timetableForGrade.initialDay(selection, DateTime(2019, 8, 16, 9, 1)),
        DateTime(2019, 8, 19),
      );
    });

    test('Can create timetable', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      final timetable = Timetable(
        timetables: [timetableForGrade],
      );
      expect(
        timetable.timetables
            .map((timetableForGrade) => timetableForGrade.toJSON())
            .toList(),
        [timetableForGrade.toJSON()],
      );
    });

    test('Can create timetable from JSON', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      final timetable = Timetable.fromJSON({
        'timetables': [timetableForGrade.toJSON()],
      });
      expect(
        timetable.timetables
            .map((timetableForGrade) => timetableForGrade.toJSON())
            .toList(),
        [timetableForGrade.toJSON()],
      );
    });

    test('Can create JSON from timetable', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      final timetable = Timetable(
        timetables: [timetableForGrade],
      );
      expect(
        timetable.toJSON(),
        {
          'timetables': [timetableForGrade.toJSON()],
        },
      );
    });

    test('Can create timetable from JSON from timetable', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'ef',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      final timetable = Timetable(
        timetables: [timetableForGrade],
      );
      expect(
        Timetable.fromJSON(timetable.toJSON()).toJSON(),
        timetable.toJSON(),
      );
    });
  });
}
