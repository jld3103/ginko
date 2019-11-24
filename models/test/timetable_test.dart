import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Timetable', () {
    test('Can create subject', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      expect(subject.teacher, 'KRA');
      expect(subject.subject, 'EK');
      expect(subject.room, '525');
      expect(subject.course, 'GK1');
      expect(subject.weeks, 'AB');
      expect(subject.unit, 0);
      expect(subject.identifier, '${subject.teacher}-${subject.subject}');
    });

    test('Can create subject from JSON', () {
      final subject = Subject.fromJSON({
        'teacher': 'KRA',
        'subject': 'EK',
        'room': '525',
        'course': 'GK1',
        'changes': [],
        'weeks': 'AB',
      }, 0);
      expect(subject.teacher, 'KRA');
      expect(subject.subject, 'EK');
      expect(subject.room, '525');
      expect(subject.course, 'GK1');
      expect(subject.weeks, 'AB');
      expect(subject.unit, 0);
      expect(subject.identifier, '${subject.teacher}-${subject.subject}');
    });

    test('Can create JSON from subject', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      expect(
        subject.toJSON(),
        {
          'teacher': 'KRA',
          'subject': 'EK',
          'room': '525',
          'course': 'GK1',
          'weeks': 'AB',
        },
      );
    });

    test('Can create subject from JSON from subject', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      expect(Subject.fromJSON(subject.toJSON(), 0).toJSON(), subject.toJSON());
    });

    test('Can apply filter', () {
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [
          SubstitutionPlanDay(
            date: DateTime(2019, 7, 8),
            updated: DateTime(2019, 7, 8, 7, 55),
          ),
        ],
        changes: [
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            changed: Changed(),
            room: null,
            teacher: null,
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            room: '525',
            changed: Changed(),
            subject: null,
            teacher: null,
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            teacher: 'KRA',
            changed: Changed(),
            subject: null,
            room: null,
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'PK',
            room: '525',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            room: '526',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            room: '525',
            teacher: 'STA',
            changed: Changed(),
            type: ChangeTypes.changed,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 1,
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.changed,
          ),
        ],
      );
      final subject = Subject(
        subject: 'EK',
        room: '525',
        teacher: 'KRA',
        unit: 0,
        weeks: 'AB',
      );
      expect(
        subject
            .getMatchingChanges(substitutionPlanForGrade)
            .map((change) => change.toJSON())
            .toList()
            .length,
        7,
      );
    });

    test('Can create lesson', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      final lesson = Lesson(
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
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      final lesson = Lesson.fromJSON({
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
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      final lesson = Lesson(
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
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [subject],
      );
      expect(Lesson.fromJSON(lesson.toJSON()).toJSON(), lesson.toJSON());
    });

    test('Can create timetable day', () {
      final lesson = Lesson(
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
      final lesson = Lesson(
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
      final lesson = Lesson(
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
      final lesson = Lesson(
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
        SelectionValue(Keys.selectionBlock('a', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('b', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('c', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('d', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('e', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('f', true), 'null-MIT'),
        SelectionValue(Keys.selectionBlock('g', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('h', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('i', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('j', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('k', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('l', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('m', true), 'null-MIT'),
        SelectionValue(Keys.selectionBlock('n', true), 'STA-EK'),
        SelectionValue(Keys.selectionBlock('o', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('p', true), 'null-FR'),
        SelectionValue(Keys.selectionBlock('q', true), 'KRA-EK'),
      ]);
      final days = [
        TimetableDay(
          weekday: 0,
          lessons: [
            Lesson(
              unit: 0,
              block: 'a',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 'b',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 2,
              block: 'c',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 3,
              block: 'd',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 4,
              block: 'e',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 5,
              block: 'f',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'MIT',
                ),
              ],
            ),
            Lesson(
              unit: 6,
              block: 'g',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 1,
          lessons: [
            Lesson(
              unit: 0,
              block: 'h',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 'i',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 2,
              block: 'j',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 3,
              block: 'k',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 4,
              block: 'l',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 5,
              block: 'm',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'MIT',
                ),
              ],
            ),
            Lesson(
              unit: 6,
              block: 'n',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 2,
          lessons: [
            Lesson(
              unit: 0,
              block: 'o',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 'p',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'FR',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 3,
          lessons: [
            Lesson(
              unit: 0,
              block: 'q',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 'r',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 4,
          lessons: [
            Lesson(
              unit: 0,
              block: 's',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 't',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
          ],
        ),
        TimetableDay(
          weekday: 5,
          lessons: [
            Lesson(
              unit: 0,
              block: 'u',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
            Lesson(
              unit: 1,
              block: 'v',
              subjects: [
                // ignore: missing_required_param
                Subject(
                  subject: 'EK',
                  teacher: 'KRA',
                ),
              ],
            ),
          ],
        ),
      ];
      expect(days[0].userLessonsCount(selection, true), 7);
      expect(days[1].userLessonsCount(selection, true), 5);
      expect(days[2].userLessonsCount(selection, true), 1);
      expect(days[3].userLessonsCount(selection, true), 1);
      expect(days[4].userLessonsCount(selection, true), 2);
    });

    test('Can create timetable for grade', () {
      final timetableDay = TimetableDay(
        weekday: 0,
        lessons: [],
      );
      final timetableForGrade = TimetableForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      expect(timetableForGrade.grade, 'EF');
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
        'grade': 'EF',
        'date': DateTime(2019, 6, 30).toIso8601String(),
        'days': [timetableDay.toJSON()],
      });
      expect(timetableForGrade.grade, 'EF');
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
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [timetableDay],
      );
      expect(
        timetableForGrade.toJSON(),
        {
          'grade': 'EF',
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
        grade: 'EF',
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
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [
          TimetableDay(
            weekday: 0,
            lessons: [
              Lesson(
                block: 'a',
                unit: 0,
                subjects: [
                  // ignore: missing_required_param
                  Subject(
                    subject: 'EK',
                    teacher: 'KRA',
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
              Lesson(
                block: 'b',
                unit: 0,
                subjects: [
                  // ignore: missing_required_param
                  Subject(
                    subject: 'EK',
                    teacher: 'KRA',
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      final selection = Selection([
        SelectionValue(Keys.selectionBlock('a', true), 'KRA-EK'),
        SelectionValue(Keys.selectionBlock('b', true), 'KRA-EK'),
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
        grade: 'EF',
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
        grade: 'EF',
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
        grade: 'EF',
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
        grade: 'EF',
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

    test('Can create matching subject', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        weeks: 'AB',
        unit: 0,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'a',
        subjects: [subject],
      );
      final matchingSubject = MatchingSubject(
        subject: subject,
        lesson: lesson,
      );
      expect(matchingSubject.subject.toJSON(), subject.toJSON());
      expect(matchingSubject.lesson.toJSON(), lesson.toJSON());
    });
  });
}
