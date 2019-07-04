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
        changes: [],
        weeks: 'AB',
        unit: 0,
      );
      expect(subject.teacher, 'KRA');
      expect(subject.subject, 'EK');
      expect(subject.room, '525');
      expect(subject.course, 'GK1');
      expect(subject.changes, []);
      expect(subject.weeks, 'AB');
      expect(subject.unit, 0);
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
      expect(subject.changes, []);
      expect(subject.weeks, 'AB');
      expect(subject.unit, 0);
    });

    test('Can create JSON from subject', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        changes: [],
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
          'changes': [],
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
        changes: [],
        weeks: 'AB',
        unit: 0,
      );
      expect(Subject.fromJSON(subject.toJSON(), 0).toJSON(), subject.toJSON());
    });

    test('Can create lesson', () {
      final subject = Subject(
        teacher: 'KRA',
        subject: 'EK',
        room: '525',
        course: 'GK1',
        changes: [],
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
        changes: [],
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
        changes: [],
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
        changes: [],
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

    test('Can create unit plan day replacement plan', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      expect(unitPlanDayReplacementPlan.applies, DateTime(2019, 6, 31));
      expect(unitPlanDayReplacementPlan.updated, DateTime(2019, 6, 30));
      expect(unitPlanDayReplacementPlan.weekA, true);
    });

    test('Can create unit plan day replacement plan from JSON', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan.fromJSON({
        'applies': DateTime(2019, 6, 31).toIso8601String(),
        'updated': DateTime(2019, 6, 30).toIso8601String(),
        'weekA': true,
      });
      expect(unitPlanDayReplacementPlan.applies, DateTime(2019, 6, 31));
      expect(unitPlanDayReplacementPlan.updated, DateTime(2019, 6, 30));
      expect(unitPlanDayReplacementPlan.weekA, true);
    });

    test('Can create JSON from unit plan day replacement plan', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      expect(
        unitPlanDayReplacementPlan.toJSON(),
        {
          'applies': DateTime(2019, 6, 31).toIso8601String(),
          'updated': DateTime(2019, 6, 30).toIso8601String(),
          'weekA': true,
        },
      );
    });

    test(
        // ignore: prefer_adjacent_string_concatenation
        'Can create unit plan day replacement plan from JSON' +
            ' from unit plan day replacement plan', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      expect(
        UnitPlanDayReplacementPlan.fromJSON(unitPlanDayReplacementPlan.toJSON())
            .toJSON(),
        unitPlanDayReplacementPlan.toJSON(),
      );
    });

    test('Can create unit plan day', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
        lessons: [lesson],
      );
      expect(unitPlanDay.weekday, 0);
      expect(
        unitPlanDay.replacementPlan.toJSON(),
        unitPlanDayReplacementPlan.toJSON(),
      );
      expect(
        unitPlanDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create unit plan day from JSON', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay.fromJSON({
        'weekday': 0,
        'replacementPlan': unitPlanDayReplacementPlan.toJSON(),
        'lessons': [lesson.toJSON()],
      });
      expect(unitPlanDay.weekday, 0);
      expect(
        unitPlanDay.replacementPlan.toJSON(),
        unitPlanDayReplacementPlan.toJSON(),
      );
      expect(
        unitPlanDay.lessons.map((lesson) => lesson.toJSON()).toList(),
        [lesson.toJSON()],
      );
    });

    test('Can create JSON from unit plan day', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
        lessons: [lesson],
      );
      expect(
        unitPlanDay.toJSON(),
        {
          'weekday': 0,
          'replacementPlan': unitPlanDayReplacementPlan.toJSON(),
          'lessons': [lesson.toJSON()],
        },
      );
    });

    test('Can create unit plan day from JSON from unit plan day', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final lesson = Lesson(
        unit: 0,
        block: 'test',
        subjects: [],
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
        lessons: [lesson],
      );
      expect(
        UnitPlanDay.fromJSON(unitPlanDay.toJSON()).toJSON(),
        unitPlanDay.toJSON(),
      );
    });

    test('Can create unit plan for grade', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
        unitPlanForGrade.date.millisecondsSinceEpoch ~/ 1000,
        unitPlanForGrade.timeStamp,
      );
    });

    test('Can create unit plan for grade from JSON', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
        unitPlanForGrade.date.millisecondsSinceEpoch ~/ 1000,
        unitPlanForGrade.timeStamp,
      );
    });

    test('Can create JSON from unit plan for grade', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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

    test('Can create unit plan', () {
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
      final unitPlanDayReplacementPlan = UnitPlanDayReplacementPlan(
        applies: DateTime(2019, 6, 31),
        updated: DateTime(2019, 6, 30),
        weekA: true,
      );
      final unitPlanDay = UnitPlanDay(
        weekday: 0,
        replacementPlan: unitPlanDayReplacementPlan,
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
