import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Unit plan', () {
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
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [
          ReplacementPlanDay(
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
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            room: '525',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'PK',
            room: '525',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            room: '526',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 0,
            subject: 'EK',
            room: '525',
            teacher: 'STA',
            changed: Changed(),
            type: ChangeTypes.unknown,
          ),
          Change(
            date: DateTime(2019, 7, 8),
            unit: 1,
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
            changed: Changed(),
            type: ChangeTypes.unknown,
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
            .getMatchingChanges(replacementPlanForGrade)
            .map((change) => change.toJSON())
            .toList()
            .length,
        5,
      );
    });

    test('Can complete subject', () {
      final subject = Subject(
        unit: 0,
        weeks: 'AB',
        subject: 'EK',
        room: '525',
        teacher: 'KRA',
      );
      expect(subject.course, null);
      subject.complete(Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'GK1',
        changed: Changed(),
        type: ChangeTypes.exam,
      ));
      expect(subject.course, 'GK1');
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

    test('Can create unit plan day', () {
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(unitPlanDay.weekday, 0);
      expect(
        unitPlanDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create unit plan day from JSON', () {
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay.fromJSON({
        'weekday': 0,
        'lessons': [lesson.toJSON()],
      });
      expect(unitPlanDay.weekday, 0);
      expect(
        unitPlanDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create JSON from unit plan day', () {
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(
        unitPlanDay.toJSON(),
        {
          'weekday': 0,
          'lessons': [lesson.toJSON()],
        },
      );
    });

    test('Can create unit plan day from JSON from unit plan day', () {
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [lesson],
      );
      expect(
        UnitPlanDay.fromJSON(unitPlanDay.toJSON()).toJSON(),
        unitPlanDay.toJSON(),
      );
    });

    test('Get correct lesson count', () {
      // ignore: missing_required_param
      final user = User(
        selection: [
          UserValue(Keys.selection('a', true), 'KRA-EK'),
          UserValue(Keys.selection('b', true), 'KRA-EK'),
          UserValue(Keys.selection('c', true), 'KRA-EK'),
          UserValue(Keys.selection('d', true), 'KRA-EK'),
          UserValue(Keys.selection('e', true), 'KRA-EK'),
          UserValue(Keys.selection('f', true), 'null-MIT'),
          UserValue(Keys.selection('g', true), 'KRA-EK'),
          UserValue(Keys.selection('h', true), 'KRA-EK'),
          UserValue(Keys.selection('i', true), 'KRA-EK'),
          UserValue(Keys.selection('j', true), 'KRA-EK'),
          UserValue(Keys.selection('k', true), 'KRA-EK'),
          UserValue(Keys.selection('l', true), 'KRA-EK'),
          UserValue(Keys.selection('m', true), 'null-MIT'),
          UserValue(Keys.selection('n', true), 'STA-EK'),
          UserValue(Keys.selection('o', true), 'KRA-EK'),
          UserValue(Keys.selection('p', true), 'null-FR'),
          UserValue(Keys.selection('q', true), 'KRA-EK'),
        ],
      );
      final days = [
        UnitPlanDay(
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
        UnitPlanDay(
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
        UnitPlanDay(
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
        UnitPlanDay(
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
        UnitPlanDay(
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
        UnitPlanDay(
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
      expect(days[0].userLessonsCount(user, true), 7);
      expect(days[1].userLessonsCount(user, true), 5);
      expect(days[2].userLessonsCount(user, true), 1);
      expect(days[3].userLessonsCount(user, true), 1);
      expect(days[4].userLessonsCount(user, true), 2);
    });

    test('Can create unit plan for grade', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      expect(unitPlanForGrade.grade, 'EF');
      expect(
        unitPlanForGrade.date,
        DateTime(2019, 6, 30),
      );
      expect(
        unitPlanForGrade.days.map((day) => day.toJSON()).toList(),
        [unitPlanDay.toJSON()],
      );
      expect(
        unitPlanForGrade.timeStamp,
        unitPlanForGrade.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create unit plan for grade from JSON', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade.fromJSON({
        'grade': 'EF',
        'date': DateTime(2019, 6, 30).toIso8601String(),
        'days': [unitPlanDay.toJSON()],
      });
      expect(unitPlanForGrade.grade, 'EF');
      expect(
        unitPlanForGrade.date,
        DateTime(2019, 6, 30),
      );
      expect(
        unitPlanForGrade.days.map((day) => day.toJSON()).toList(),
        [unitPlanDay.toJSON()],
      );
      expect(
        unitPlanForGrade.timeStamp,
        unitPlanForGrade.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from unit plan for grade', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      expect(
        unitPlanForGrade.toJSON(),
        {
          'grade': 'EF',
          'date': DateTime(2019, 6, 30).toIso8601String(),
          'days': [unitPlanDay.toJSON()],
        },
      );
    });

    test(
        // ignore: prefer_adjacent_string_concatenation
        'Can create unit plan for grade from JSON' +
            ' from unit plan for grade', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      expect(
        UnitPlanForGrade.fromJSON(unitPlanForGrade.toJSON()).toJSON(),
        unitPlanForGrade.toJSON(),
      );
    });

    test('Can get correct initial weekday', () {
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [
          UnitPlanDay(
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
          UnitPlanDay(
            weekday: 1,
            lessons: [],
          ),
          UnitPlanDay(
            weekday: 2,
            lessons: [],
          ),
          UnitPlanDay(
            weekday: 3,
            lessons: [],
          ),
          UnitPlanDay(
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
      // ignore: missing_required_param
      final user = User(
        selection: [
          UserValue(Keys.selection('a', true), 'KRA-EK'),
          UserValue(Keys.selection('b', true), 'KRA-EK'),
        ],
      );
      expect(
        unitPlanForGrade.initialWeekday(user, DateTime(2019, 8, 10)),
        0,
      );
      expect(
        unitPlanForGrade.initialWeekday(user, DateTime(2019, 8, 12, 8, 59)),
        0,
      );
      expect(
        unitPlanForGrade.initialWeekday(user, DateTime(2019, 8, 12, 9, 1)),
        1,
      );
      expect(
        unitPlanForGrade.initialWeekday(user, DateTime(2019, 8, 16, 9, 1)),
        0,
      );
    });

    test('Can create unit plan', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      final unitPlan = UnitPlan(
        unitPlans: [unitPlanForGrade],
      );
      expect(
        unitPlan.unitPlans
            .map((unitPlanForGrade) => unitPlanForGrade.toJSON())
            .toList(),
        [unitPlanForGrade.toJSON()],
      );
    });

    test('Can create unit plan from JSON', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      final unitPlan = UnitPlan.fromJSON({
        'unitPlans': [unitPlanForGrade.toJSON()],
      });
      expect(
        unitPlan.unitPlans
            .map((unitPlanForGrade) => unitPlanForGrade.toJSON())
            .toList(),
        [unitPlanForGrade.toJSON()],
      );
    });

    test('Can create JSON from unit plan', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      final unitPlan = UnitPlan(
        unitPlans: [unitPlanForGrade],
      );
      expect(
        unitPlan.toJSON(),
        {
          'unitPlans': [unitPlanForGrade.toJSON()],
        },
      );
    });

    test('Can create unit plan from JSON from unit plan', () {
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        lessons: [],
      );
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 6, 30),
        days: [unitPlanDay],
      );
      final unitPlan = UnitPlan(
        unitPlans: [unitPlanForGrade],
      );
      expect(
        UnitPlan.fromJSON(unitPlan.toJSON()).toJSON(),
        unitPlan.toJSON(),
      );
    });
  });
}
