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
          type: ChangeTypes.changed,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'EK',
          room: '526',
          teacher: 'STA',
          changed: Changed(),
          type: ChangeTypes.changed,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'PK',
          room: '527',
          teacher: 'KRA',
          changed: Changed(),
          type: ChangeTypes.changed,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'KR',
          room: '527',
          teacher: 'LIC',
          changed: Changed(),
          type: ChangeTypes.changed,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 0,
          room: '527',
          changed: Changed(),
          subject: null,
          teacher: null,
          type: ChangeTypes.changed,
        ),
        Change(
          date: DateTime(2019, 7, 8),
          unit: 1,
          room: '527',
          changed: Changed(),
          subject: null,
          teacher: null,
          type: ChangeTypes.changed,
        ),
      ];
      final timetableForGrade = TimetableForGrade(
        grade: 'EF',
        date: DateTime(2019, 7, 7),
        days: [
          TimetableDay(
            weekday: 0,
            lessons: [
              TimetableLesson(
                unit: 0,
                block: 'EFa',
                subjects: [
                  TimetableSubject(
                    subject: 'EK',
                    room: '525',
                    teacher: 'KRA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  TimetableSubject(
                    subject: 'EK',
                    room: '526',
                    teacher: 'STA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  TimetableSubject(
                    subject: 'PK',
                    room: '527',
                    teacher: 'KRA',
                    unit: 0,
                    weeks: 'AB',
                  ),
                  TimetableSubject(
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
        changes[0].getMatchingSubjectsByTimetable(timetableForGrade) != null,
        true,
      );
      expect(
        changes[1].getMatchingSubjectsByTimetable(timetableForGrade) != null,
        true,
      );
      expect(
        changes[2].getMatchingSubjectsByTimetable(timetableForGrade) != null,
        true,
      );
      expect(
        changes[3].getMatchingSubjectsByTimetable(timetableForGrade) != null,
        true,
      );
      expect(
        changes[4].getMatchingSubjectsByTimetable(timetableForGrade).length,
        2,
      );
      expect(
        changes[5].getMatchingSubjectsByTimetable(timetableForGrade),
        [],
      );
      expect(
        changes[0].getMatchingSubjectsByLesson(
                timetableForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[1].getMatchingSubjectsByLesson(
                timetableForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[2].getMatchingSubjectsByLesson(
                timetableForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[3].getMatchingSubjectsByLesson(
                timetableForGrade.days[0].lessons[0]) !=
            null,
        true,
      );
      expect(
        changes[4]
            .getMatchingSubjectsByLesson(timetableForGrade.days[0].lessons[0])
            .length,
        2,
      );
      expect(
        changes[5]
            .getMatchingSubjectsByLesson(timetableForGrade.days[0].lessons[0]),
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
          type: ChangeTypes.changed,
        ),
        Change(
          unit: 0,
          date: DateTime(2019, 7, 11),
          room: 'GRH',
          subject: null,
          teacher: null,
          changed: null,
          type: ChangeTypes.changed,
        ),
      ];
      final lessons = [
        TimetableLesson(
          unit: 0,
          block: 'a',
          subjects: [
            TimetableSubject(
              unit: 0,
              subject: 'SP',
              room: 'GRH',
              teacher: 'GÖB',
              weeks: 'AB',
            ),
          ],
        ),
        TimetableLesson(
          unit: 0,
          block: 'b',
          subjects: [
            TimetableSubject(
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
        type: ChangeTypes.changed,
        subject: null,
        teacher: null,
        room: null,
      );
      expect(change.subject, null);
      expect(change.room, null);
      expect(change.teacher, null);
      final completedChange = change.completed(TimetableLesson(
        unit: 0,
        block: null,
        subjects: [
          TimetableSubject(
            unit: 0,
            weeks: 'AB',
            subject: 'EK',
            room: '525',
            teacher: 'KRA',
          ),
        ],
      ));
      expect(completedChange.subject, 'EK');
      expect(completedChange.room, '525');
      expect(completedChange.teacher, 'KRA');
    });

    test('Can create replacement plan day', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create replacement plan day from JSON', () {
      final day = SubstitutionPlanDay.fromJSON({
        'date': DateTime(2019, 7, 12).toIso8601String(),
        'updated': DateTime(2019, 7, 12, 7, 55).toIso8601String(),
      });
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create JSON from replacement plan day', () {
      final day = SubstitutionPlanDay(
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
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(SubstitutionPlanDay.fromJSON(day.toJSON()).toJSON(), day.toJSON());
    });

    test('Can create replacement plan for grade', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(substitutionPlanForGrade.grade, 'EF');
      expect(
        substitutionPlanForGrade.substitutionPlanDays
            .map((day) => day.toJSON())
            .toList(),
        [day.toJSON()],
      );
      expect(
        substitutionPlanForGrade.changes
            .map((change) => change.toJSON())
            .toList(),
        [change.toJSON()],
      );
      expect(
        substitutionPlanForGrade.timeStamp,
        day.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create replacement plan for grade from JSON', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade.fromJSON({
        'grade': 'EF',
        'substitutionPlanDays': [day.toJSON()],
        'changes': [change.toJSON()],
      });
      expect(substitutionPlanForGrade.grade, 'EF');
      expect(
        substitutionPlanForGrade.substitutionPlanDays
            .map((day) => day.toJSON())
            .toList(),
        [day.toJSON()],
      );
      expect(
        substitutionPlanForGrade.changes
            .map((change) => change.toJSON())
            .toList(),
        [change.toJSON()],
      );
      expect(
        substitutionPlanForGrade.timeStamp,
        day.date.millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from replacement plan for grade', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(
        substitutionPlanForGrade.toJSON(),
        {
          'grade': 'EF',
          'substitutionPlanDays': [day.toJSON()],
          'changes': [change.toJSON()],
        },
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can create replacement plan for grade from JSON from replacement plan for grade',
        () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(
        SubstitutionPlanForGrade.fromJSON(substitutionPlanForGrade.toJSON())
            .toJSON(),
        substitutionPlanForGrade.toJSON(),
      );
    });

    test('Can create replacement plan', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      final substitutionPlan = SubstitutionPlan(
        substitutionPlans: [substitutionPlanForGrade],
      );
      expect(
          substitutionPlan.substitutionPlans
              .map((substitutionPlanForGrade) =>
                  substitutionPlanForGrade.toJSON())
              .toList(),
          [substitutionPlanForGrade.toJSON()]);
    });

    test('Can create replacement plan from JSON', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      final substitutionPlan = SubstitutionPlan.fromJSON({
        'substitutionPlans': [substitutionPlanForGrade.toJSON()],
      });
      expect(
          substitutionPlan.substitutionPlans
              .map((substitutionPlanForGrade) =>
                  substitutionPlanForGrade.toJSON())
              .toList(),
          [substitutionPlanForGrade.toJSON()]);
    });

    test('Can create JSON from replacement plan', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      final substitutionPlan = SubstitutionPlan(
        substitutionPlans: [substitutionPlanForGrade],
      );
      expect(
        substitutionPlan.toJSON(),
        {
          'substitutionPlans': [substitutionPlanForGrade.toJSON()],
        },
      );
    });

    test('Can create replacement plan from JSON from replacement plan', () {
      final day = SubstitutionPlanDay(
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
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'EF',
        substitutionPlanDays: [day],
        changes: [change],
      );
      final substitutionPlan = SubstitutionPlan(
        substitutionPlans: [substitutionPlanForGrade],
      );
      expect(
        SubstitutionPlan.fromJSON(substitutionPlan.toJSON()).toJSON(),
        substitutionPlan.toJSON(),
      );
    });
  });
}
