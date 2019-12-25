import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Substitution plan', () {
    test('Can create changed', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      expect(changed.subject, 'ek');
      expect(changed.teacher, 'kra');
      expect(changed.room, '526');
      expect(changed.info, 'Raumänderung');
    });

    test('Can create changed from JSON', () {
      final changed = SubstitutionPlanChanged.fromJSON({
        'subject': 'ek',
        'teacher': 'kra',
        'room': '526',
        'info': 'Raumänderung',
      });
      expect(changed.subject, 'ek');
      expect(changed.teacher, 'kra');
      expect(changed.room, '526');
      expect(changed.info, 'Raumänderung');
    });

    test('Can create JSON from changed', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      expect(
        changed.toJSON(),
        {
          'subject': 'ek',
          'teacher': 'kra',
          'room': '526',
          'info': 'Raumänderung',
        },
      );
    });

    test('Can create changed from JSON from changed', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      expect(SubstitutionPlanChanged.fromJSON(changed.toJSON()).toJSON(),
          changed.toJSON());
    });

    test('Can create change', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      expect(change.date, DateTime(2019, 7, 11));
      expect(change.unit, 0);
      expect(change.subject, 'ek');
      expect(change.course, 'g1');
      expect(change.room, '525');
      expect(change.teacher, 'kra');
      expect(change.changed, changed);
      expect(change.type, SubstitutionPlanChangeTypes.exam);
    });

    test('Can create change from JSON', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange.fromJSON({
        'date': DateTime(2019, 7, 11).toIso8601String(),
        'unit': 0,
        'subject': 'ek',
        'course': 'g1',
        'room': '525',
        'teacher': 'kra',
        'changed': changed.toJSON(),
        'type': SubstitutionPlanChangeTypes.exam.index,
      });
      expect(change.date, DateTime(2019, 7, 11));
      expect(change.unit, 0);
      expect(change.subject, 'ek');
      expect(change.course, 'g1');
      expect(change.room, '525');
      expect(change.teacher, 'kra');
      expect(change.changed.toJSON(), changed.toJSON());
      expect(change.type, SubstitutionPlanChangeTypes.exam);
    });

    test('Can create JSON from change', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      expect(
        change.toJSON(),
        {
          'date': DateTime(2019, 7, 11).toIso8601String(),
          'unit': 0,
          'subject': 'ek',
          'course': 'g1',
          'room': '525',
          'teacher': 'kra',
          'changed': changed.toJSON(),
          'type': SubstitutionPlanChangeTypes.exam.index,
        },
      );
    });

    test('Can create change from JSON from change', () {
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      expect(SubstitutionPlanChange.fromJSON(change.toJSON()).toJSON(),
          change.toJSON());
    });

    test('Can apply filter', () {
      final changes = [
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
          room: '526',
          teacher: 'bdn',
          changed: SubstitutionPlanChanged(),
          type: SubstitutionPlanChangeTypes.changed,
        ),
        SubstitutionPlanChange(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'pk',
          room: '527',
          teacher: 'kra',
          changed: SubstitutionPlanChanged(),
          type: SubstitutionPlanChangeTypes.changed,
        ),
        SubstitutionPlanChange(
          date: DateTime(2019, 7, 8),
          unit: 0,
          subject: 'kr',
          room: '527',
          teacher: 'lic',
          changed: SubstitutionPlanChanged(),
          type: SubstitutionPlanChangeTypes.changed,
        ),
        SubstitutionPlanChange(
          date: DateTime(2019, 7, 8),
          unit: 0,
          room: null,
          changed: SubstitutionPlanChanged(),
          subject: null,
          teacher: null,
          type: SubstitutionPlanChangeTypes.changed,
          course: 'g1',
        ),
        SubstitutionPlanChange(
          date: DateTime(2019, 7, 8),
          unit: 0,
          room: '527',
          changed: SubstitutionPlanChanged(),
          subject: null,
          teacher: null,
          type: SubstitutionPlanChangeTypes.changed,
        ),
        SubstitutionPlanChange(
          date: DateTime(2019, 7, 8),
          unit: 1,
          room: '527',
          changed: SubstitutionPlanChanged(),
          subject: null,
          teacher: null,
          type: SubstitutionPlanChangeTypes.changed,
        ),
      ];
      final subjects = [
        TimetableSubject(
          subject: 'ek',
          room: '525',
          teachers: ['kra', 'bdn'],
          unit: 0,
          course: 'g2',
        ),
        TimetableSubject(
          subject: 'ek',
          room: '526',
          teachers: ['bdn'],
          unit: 0,
          course: 'g2',
        ),
        TimetableSubject(
          subject: 'pk',
          room: '527',
          teachers: ['kra', 'bdn'],
          unit: 0,
          course: 'g2',
        ),
        TimetableSubject(
          subject: 'kr',
          room: '527',
          teachers: ['lic'],
          unit: 0,
          course: 'g2',
        ),
        TimetableSubject(
          subject: null,
          room: null,
          teachers: [],
          unit: 0,
          course: 'g1',
        ),
      ];
      expect(
        subjects.where((s) => changes[0].subjectMatches(s)).toList().length,
        1,
      );
      expect(
        subjects.where((s) => changes[1].subjectMatches(s)).toList().length,
        1,
      );
      expect(
        subjects.where((s) => changes[2].subjectMatches(s)).toList().length,
        1,
      );
      expect(
        subjects.where((s) => changes[3].subjectMatches(s)).toList().length,
        1,
      );
      expect(
        subjects.where((s) => changes[4].subjectMatches(s)).toList().length,
        1,
      );
      expect(
        subjects.where((s) => changes[5].subjectMatches(s)).toList().length,
        3,
      );
      expect(
        subjects.where((s) => changes[6].subjectMatches(s)).toList().length,
        0,
      );
    });

    test('Can complete change by lesson', () {
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'g1',
        changed: SubstitutionPlanChanged(),
        type: SubstitutionPlanChangeTypes.changed,
        subject: null,
        teacher: null,
        room: null,
      );
      final completedChange = change.completedByLesson(TimetableLesson(
        unit: 0,
        block: null,
        subjects: [
          TimetableSubject(
            unit: 0,
            subject: 'ek',
            room: '525',
            teachers: ['kra', 'bdn'],
          ),
        ],
      ));
      expect(completedChange.subject, 'ek');
      expect(completedChange.room, '525');
      expect(completedChange.teacher, 'kra');
    });

    test('Cannot complete change by lesson if lesson is null', () {
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'g1',
        changed: SubstitutionPlanChanged(),
        type: SubstitutionPlanChangeTypes.changed,
        subject: null,
        teacher: null,
        room: null,
      );
      final completedChange = change.completedByLesson(null);
      expect(change.toJSON(), completedChange.toJSON());
    });

    test('Cannot complete change by lesson if multiple subjects match', () {
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'g1',
        changed: SubstitutionPlanChanged(),
        type: SubstitutionPlanChangeTypes.changed,
        subject: null,
        teacher: null,
        room: null,
      );
      final completedChange = change.completedByLesson(TimetableLesson(
        unit: 0,
        block: null,
        subjects: [
          TimetableSubject(
            unit: 0,
            subject: 'ek',
            room: '525',
            teachers: ['kra', 'bdn'],
          ),
          TimetableSubject(
            unit: 0,
            subject: 'ek',
            room: '525',
            teachers: ['kra', 'bdn'],
          ),
        ],
      ));
      expect(change.toJSON(), completedChange.toJSON());
    });

    test('Can complete change by subject', () {
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        course: 'g1',
        changed: SubstitutionPlanChanged(),
        type: SubstitutionPlanChangeTypes.changed,
        subject: null,
        teacher: null,
        room: null,
      );
      expect(change.subject, null);
      expect(change.room, null);
      expect(change.teacher, null);
      final completedChange = change.completedBySubject(TimetableSubject(
        unit: 0,
        subject: 'ek',
        room: '525',
        teachers: ['kra', 'bdn'],
      ));
      expect(completedChange.subject, 'ek');
      expect(completedChange.room, '525');
      expect(completedChange.teacher, 'kra');
    });

    test('Can create substitution plan day', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create substitution plan day from JSON', () {
      final day = SubstitutionPlanDay.fromJSON({
        'date': DateTime(2019, 7, 12).toIso8601String(),
        'updated': DateTime(2019, 7, 12, 7, 55).toIso8601String(),
      });
      expect(day.date, DateTime(2019, 7, 12));
      expect(day.updated, DateTime(2019, 7, 12, 7, 55));
    });

    test('Can create JSON from substitution plan day', () {
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

    test(
        'Can create substitution plan day from JSON from substitution plan day',
        () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      expect(SubstitutionPlanDay.fromJSON(day.toJSON()).toJSON(), day.toJSON());
    });

    test('Can create substitution plan for grade', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(substitutionPlanForGrade.grade, 'ef');
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

    test('Can create substitution plan for grade from JSON', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade.fromJSON({
        'grade': 'ef',
        'substitutionPlanDays': [day.toJSON()],
        'changes': [change.toJSON()],
      });
      expect(substitutionPlanForGrade.grade, 'ef');
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

    test('Can create JSON from substitution plan for grade', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(
        substitutionPlanForGrade.toJSON(),
        {
          'grade': 'ef',
          'substitutionPlanDays': [day.toJSON()],
          'changes': [change.toJSON()],
        },
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can create substitution plan for grade from JSON from substitution plan for grade',
        () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
        substitutionPlanDays: [day],
        changes: [change],
      );
      expect(
        SubstitutionPlanForGrade.fromJSON(substitutionPlanForGrade.toJSON())
            .toJSON(),
        substitutionPlanForGrade.toJSON(),
      );
    });

    test('Can create substitution plan', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
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

    test('Can create substitution plan from JSON', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
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

    test('Can create JSON from substitution plan', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
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

    test('Can create substitution plan from JSON from substitution plan', () {
      final day = SubstitutionPlanDay(
        date: DateTime(2019, 7, 12),
        updated: DateTime(2019, 7, 12, 7, 55),
      );
      final changed = SubstitutionPlanChanged(
        subject: 'ek',
        teacher: 'kra',
        room: '526',
        info: 'Raumänderung',
      );
      final change = SubstitutionPlanChange(
        date: DateTime(2019, 7, 11),
        unit: 0,
        subject: 'ek',
        course: 'g1',
        room: '525',
        teacher: 'kra',
        changed: changed,
        type: SubstitutionPlanChangeTypes.exam,
      );
      final substitutionPlanForGrade = SubstitutionPlanForGrade(
        grade: 'ef',
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
