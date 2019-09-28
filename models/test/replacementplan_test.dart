import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Replacement plan', () {
    test('Can create changed', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      expect(changed.subject, 'EK');
      expect(changed.teacher, 'KRA');
      expect(changed.room, '526');
      expect(changed.info, 'Raumänderung');
    });

    test('Can create changed from JSON', () {
      final changed = Changed.fromJSON({
        'subject': 'EK',
        'teacher': 'KRA',
        'room': '526',
        'info': 'Raumänderung',
      });
      expect(changed.subject, 'EK');
      expect(changed.teacher, 'KRA');
      expect(changed.room, '526');
      expect(changed.info, 'Raumänderung');
    });

    test('Can create JSON from changed', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      expect(
        changed.toJSON(),
        {
          'subject': 'EK',
          'teacher': 'KRA',
          'room': '526',
          'info': 'Raumänderung',
        },
      );
    });

    test('Can create changed from JSON from changed', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      expect(Changed.fromJSON(changed.toJSON()).toJSON(), changed.toJSON());
    });

    test('Can create change', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      expect(change.date, DateTime(2019, 7, 11));
      expect(change.unit, 0);
      expect(change.subject, 'EK');
      expect(change.course, 'GK1');
      expect(change.room, '525');
      expect(change.teacher, 'KRA');
      expect(change.changed, changed);
      expect(change.type, ChangeTypes.exam);
    });

    test('Can create change from JSON', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change.fromJSON({
        'date': DateTime(2019, 7, 11).toIso8601String(),
        'unit': 0,
        'subject': 'EK',
        'course': 'GK1',
        'room': '525',
        'teacher': 'KRA',
        'changed': changed.toJSON(),
        'type': ChangeTypes.exam.index,
      });
      expect(change.date, DateTime(2019, 7, 11));
      expect(change.unit, 0);
      expect(change.subject, 'EK');
      expect(change.course, 'GK1');
      expect(change.room, '525');
      expect(change.teacher, 'KRA');
      expect(change.changed.toJSON(), changed.toJSON());
      expect(change.type, ChangeTypes.exam);
    });

    test('Can create JSON from change', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      expect(
        change.toJSON(),
        {
          'date': DateTime(2019, 7, 11).toIso8601String(),
          'unit': 0,
          'subject': 'EK',
          'course': 'GK1',
          'room': '525',
          'teacher': 'KRA',
          'changed': changed.toJSON(),
          'type': ChangeTypes.exam.index,
        },
      );
    });

    test('Can create change from JSON from change', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      expect(Change.fromJSON(change.toJSON()).toJSON(), change.toJSON());
    });

    test('Can apply filter', () {
      final changes = [
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
          room: '526',
          teacher: 'STA',
          changed: Changed(),
          type: ChangeTypes.unknown,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'PK',
          room: '527',
          teacher: 'KRA',
          changed: Changed(),
          type: ChangeTypes.unknown,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'KR',
          room: '527',
          teacher: 'LIC',
          changed: Changed(),
          type: ChangeTypes.unknown,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          room: '527',
          changed: Changed(),
          type: ChangeTypes.unknown,
          subject: null,
          teacher: null,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 1,
          room: '527',
          changed: Changed(),
          type: ChangeTypes.unknown,
          subject: null,
          teacher: null,
        ),
      ];
      final unitPlanForGrade = UnitPlanForGrade(
        grade: 'EF',
        date: DateTime(2019, 7, 7),
        days: [
          UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'EFa',
                subjects: [
                  Subject(
                    subject: 'EK',
                    room: '525',
                    teacher: 'KRA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  Subject(
                    subject: 'EK',
                    room: '526',
                    teacher: 'STA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  Subject(
                    subject: 'PK',
                    room: '527',
                    teacher: 'KRA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  Subject(
                    subject: 'KR',
                    room: '527',
                    teacher: 'LIC',
                    unit: 0,
                    weeks: 'AB',
                  ),
                ],
              )
            ],
          ),
        ],
      );
      expect(
        changes[0].getMatchingSubjectsByUnitPlan(unitPlanForGrade) != null,
        true,
      );
      expect(
        changes[1].getMatchingSubjectsByUnitPlan(unitPlanForGrade) != null,
        true,
      );
      expect(
        changes[2].getMatchingSubjectsByUnitPlan(unitPlanForGrade) != null,
        true,
      );
      expect(
        changes[3].getMatchingSubjectsByUnitPlan(unitPlanForGrade) != null,
        true,
      );
      expect(
        changes[4].getMatchingSubjectsByUnitPlan(unitPlanForGrade).length,
        2,
      );
      expect(
        changes[5].getMatchingSubjectsByUnitPlan(unitPlanForGrade),
        [],
      );
      expect(
        changes[0].getMatchingSubjectsByLesson(
                unitPlanForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[1].getMatchingSubjectsByLesson(
                unitPlanForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[2].getMatchingSubjectsByLesson(
                unitPlanForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[3].getMatchingSubjectsByLesson(
                unitPlanForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[4]
            .getMatchingSubjectsByLesson(unitPlanForGrade.days[0].lessons[0])
            .length,
        2,
      );
      expect(
        changes[5]
            .getMatchingSubjectsByLesson(unitPlanForGrade.days[0].lessons[0]),
        [],
      );
    });

    test('Can apply filter with fix for sport rooms', () {
      final changes = [
        Change(
          unit: 0,
          date: DateTime(2019, 7, 11),
          room: 'KLH',
          subject: null,
          teacher: null,
          changed: null,
        ),
        Change(
          unit: 0,
          date: DateTime(2019, 7, 11),
          room: 'GRH',
          subject: null,
          teacher: null,
          changed: null,
        ),
      ];
      final lessons = [
        Lesson(
          unit: 0,
          block: 'a',
          subjects: [
            Subject(
              unit: 0,
              subject: 'SP',
              room: 'GRH',
              teacher: 'GÖB',
              weeks: 'AB',
            ),
          ],
        ),
        Lesson(
          unit: 0,
          block: 'b',
          subjects: [
            Subject(
              unit: 0,
              subject: 'SP',
              room: 'KLH',
              teacher: 'GÖB',
              weeks: 'AB',
            ),
          ],
        ),
      ];
      expect(changes[0].getMatchingSubjectsByLesson(lessons[0])[0].room, 'GRH');
      expect(changes[1].getMatchingSubjectsByLesson(lessons[0])[0].room, 'GRH');
      expect(changes[0].getMatchingSubjectsByLesson(lessons[1])[0].room, 'KLH');
      expect(changes[1].getMatchingSubjectsByLesson(lessons[1])[0].room, 'KLH');
    });

    test('Can complete change', () {
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'GK1',
        changed: Changed(),
        type: ChangeTypes.replaced,
        subject: null,
        teacher: null,
        room: null,
      );
      expect(change.subject, null);
      expect(change.room, null);
      expect(change.teacher, null);
      change.complete(Subject(
        unit: 0,
        weeks: 'AB',
        subject: 'EK',
        room: '525',
        teacher: 'KRA',
      ));
      expect(change.subject, 'EK');
      expect(change.room, '525');
      expect(change.teacher, 'KRA');
    });

    test('Can create replacement plan day', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create replacement plan day from JSON', () {
      final day = ReplacementPlanDay.fromJSON({
        'date': DateTime(2019, 7, 12).toIso8601String(),
        'updated': DateTime(2019, 7, 12, 7, 55).toIso8601String(),
      });
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create JSON from replacement plan day', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(
        day.toJSON(),
        {
          'date': DateTime(2019, 7, 12).toIso8601String(),
          'updated': DateTime(2019, 7, 12, 7, 55).toIso8601String(),
        },
      );
    });

    test('Can create replacement plan day from JSON from replacement plan day',
        () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(ReplacementPlanDay.fromJSON(day.toJSON()).toJSON(), day.toJSON());
    });

    test('Can create replacement plan for grade', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      expect(replacementPlanForGrade.grade, 'EF');
      expect(
        replacementPlanForGrade.replacementPlanDays
            .map((day) => day.toJSON())
            .toList(),
        [day.toJSON()],
      );
      expect(
        replacementPlanForGrade.changes
            .map((change) => change.toJSON())
            .toList(),
        [change.toJSON()],
      );
      expect(
        replacementPlanForGrade.timeStamp,
        day.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create replacement plan for grade from JSON', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade.fromJSON({
        'grade': 'EF',
        'replacementPlanDays': [day.toJSON()],
        'changes': [change.toJSON()],
      });
      expect(replacementPlanForGrade.grade, 'EF');
      expect(
        replacementPlanForGrade.replacementPlanDays
            .map((day) => day.toJSON())
            .toList(),
        [day.toJSON()],
      );
      expect(
        replacementPlanForGrade.changes
            .map((change) => change.toJSON())
            .toList(),
        [change.toJSON()],
      );
      expect(
        replacementPlanForGrade.timeStamp,
        day.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from replacement plan for grade', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      expect(
        replacementPlanForGrade.toJSON(),
        {
          'grade': 'EF',
          'replacementPlanDays': [day.toJSON()],
          'changes': [change.toJSON()],
        },
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can create replacement plan for grade from JSON from replacement plan for grade',
        () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      expect(
        ReplacementPlanForGrade.fromJSON(replacementPlanForGrade.toJSON())
            .toJSON(),
        replacementPlanForGrade.toJSON(),
      );
    });

    test('Can create replacement plan', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      final replacementPlan = ReplacementPlan(
        replacementPlans: [replacementPlanForGrade],
      );
      expect(
          replacementPlan.replacementPlans
              .map(
                  (replacementPlanForGrade) => replacementPlanForGrade.toJSON())
              .toList(),
          [replacementPlanForGrade.toJSON()]);
    });

    test('Can create replacement plan from JSON', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      final replacementPlan = ReplacementPlan.fromJSON({
        'replacementPlans': [replacementPlanForGrade.toJSON()],
      });
      expect(
          replacementPlan.replacementPlans
              .map(
                  (replacementPlanForGrade) => replacementPlanForGrade.toJSON())
              .toList(),
          [replacementPlanForGrade.toJSON()]);
    });

    test('Can create JSON from replacement plan', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      final replacementPlan = ReplacementPlan(
        replacementPlans: [replacementPlanForGrade],
      );
      expect(
        replacementPlan.toJSON(),
        {
          'replacementPlans': [replacementPlanForGrade.toJSON()],
        },
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can create replacement plan from JSON from replacement plan', () {
      final day = ReplacementPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        type: ChangeTypes.exam,
      );
      final replacementPlanForGrade = ReplacementPlanForGrade(
        grade: 'EF',
        replacementPlanDays: [day],
        changes: [change],
      );
      final replacementPlan = ReplacementPlan(
        replacementPlans: [replacementPlanForGrade],
      );
      expect(
        ReplacementPlan.fromJSON(replacementPlan.toJSON()).toJSON(),
        replacementPlan.toJSON(),
      );
    });
  });
}
