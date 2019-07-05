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
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        sure: true,
        exam: ExamTypes.none,
      );
      expect(change.unit, 0);
      expect(change.subject, 'EK');
      expect(change.course, 'GK1');
      expect(change.room, '525');
      expect(change.teacher, 'KRA');
      expect(change.changed, changed);
      expect(change.sure, true);
      expect(change.exam, ExamTypes.none);
    });

    test('Can create change from JSON', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change.fromJSON({
        'unit': 0,
        'subject': 'EK',
        'course': 'GK1',
        'room': '525',
        'teacher': 'KRA',
        'changed': changed.toJSON(),
        'sure': true,
        'exam': ExamTypes.none.index,
      });
      expect(change.unit, 0);
      expect(change.subject, 'EK');
      expect(change.course, 'GK1');
      expect(change.room, '525');
      expect(change.teacher, 'KRA');
      expect(change.changed.toJSON(), changed.toJSON());
      expect(change.sure, true);
      expect(change.exam, ExamTypes.none);
    });

    test('Can create JSON from change', () {
      final changed = Changed(
        subject: 'EK',
        teacher: 'KRA',
        room: '526',
        info: 'Raumänderung',
      );
      final change = Change(
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        sure: true,
        exam: ExamTypes.none,
      );
      expect(
        change.toJSON(),
        {
          'unit': 0,
          'subject': 'EK',
          'course': 'GK1',
          'room': '525',
          'teacher': 'KRA',
          'changed': changed.toJSON(),
          'sure': true,
          'exam': ExamTypes.none.index,
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
        unit: 0,
        subject: 'EK',
        course: 'GK1',
        room: '525',
        teacher: 'KRA',
        changed: changed,
        sure: true,
        exam: ExamTypes.none,
      );
      expect(Change.fromJSON(change.toJSON()).toJSON(), change.toJSON());
    });
  });
}
