import 'package:models/models.dart';
import 'package:server/extra/replacementplan.dart';
import 'package:test/test.dart';

void main() {
  group('Replacement plan data', () {
    test(
        // ignore: lines_longer_than_80_chars
        'Can merge replacement plans correctly if they are for the same day, but the first is older',
        () {
      expect(
        ReplacementPlanExtra.mergeReplacementPlans(
          [
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 12),
                      subject: 'EK',
                      changed: Changed(),
                      room: null,
                      teacher: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 12),
                      updated: DateTime(2019, 7, 12, 7, 54),
                    ),
                  ],
                ),
              ],
            ),
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 12),
                      subject: 'D',
                      changed: Changed(),
                      teacher: null,
                      room: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 12),
                      updated: DateTime(2019, 7, 12, 7, 55),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ).toJSON(),
        ReplacementPlan(
          replacementPlans: [
            ReplacementPlanForGrade(
              grade: 'EF',
              changes: [
                Change(
                  unit: 0,
                  date: DateTime(2019, 7, 12),
                  subject: 'D',
                  changed: Changed(),
                  teacher: null,
                  room: null,
                ),
              ],
              replacementPlanDays: [
                ReplacementPlanDay(
                  date: DateTime(2019, 7, 12),
                  updated: DateTime(2019, 7, 12, 7, 55),
                ),
              ],
            ),
          ],
        ).toJSON(),
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can merge replacement plans correctly if they are for the same day, but the first is newer',
        () {
      expect(
        ReplacementPlanExtra.mergeReplacementPlans(
          [
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 12),
                      subject: 'EK',
                      changed: Changed(),
                      room: null,
                      teacher: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 12),
                      updated: DateTime(2019, 7, 12, 7, 55),
                    ),
                  ],
                ),
              ],
            ),
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 12),
                      subject: 'D',
                      changed: Changed(),
                      teacher: null,
                      room: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 12),
                      updated: DateTime(2019, 7, 12, 7, 54),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ).toJSON(),
        ReplacementPlan(
          replacementPlans: [
            ReplacementPlanForGrade(
              grade: 'EF',
              changes: [
                Change(
                  unit: 0,
                  date: DateTime(2019, 7, 12),
                  subject: 'EK',
                  changed: Changed(),
                  room: null,
                  teacher: null,
                ),
              ],
              replacementPlanDays: [
                ReplacementPlanDay(
                  date: DateTime(2019, 7, 12),
                  updated: DateTime(2019, 7, 12, 7, 55),
                ),
              ],
            ),
          ],
        ).toJSON(),
      );
    });

    test(
        // ignore: lines_longer_than_80_chars
        'Can merge replacement plans correctly if they are not for the same day',
        () {
      expect(
        ReplacementPlanExtra.mergeReplacementPlans(
          [
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 11),
                      subject: 'EK',
                      changed: Changed(),
                      teacher: null,
                      room: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 11),
                      updated: DateTime(2019, 7, 12, 7, 55),
                    ),
                  ],
                ),
              ],
            ),
            ReplacementPlan(
              replacementPlans: [
                ReplacementPlanForGrade(
                  grade: 'EF',
                  changes: [
                    Change(
                      unit: 0,
                      date: DateTime(2019, 7, 12),
                      subject: 'D',
                      changed: Changed(),
                      teacher: null,
                      room: null,
                    ),
                  ],
                  replacementPlanDays: [
                    ReplacementPlanDay(
                      date: DateTime(2019, 7, 12),
                      updated: DateTime(2019, 7, 12, 7, 55),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ).toJSON(),
        ReplacementPlan(
          replacementPlans: [
            ReplacementPlanForGrade(
              grade: 'EF',
              changes: [
                Change(
                  unit: 0,
                  date: DateTime(2019, 7, 11),
                  subject: 'EK',
                  changed: Changed(),
                  teacher: null,
                  room: null,
                ),
                Change(
                  unit: 0,
                  date: DateTime(2019, 7, 12),
                  subject: 'D',
                  changed: Changed(),
                  room: null,
                  teacher: null,
                ),
              ],
              replacementPlanDays: [
                ReplacementPlanDay(
                  date: DateTime(2019, 7, 11),
                  updated: DateTime(2019, 7, 12, 7, 55),
                ),
                ReplacementPlanDay(
                  date: DateTime(2019, 7, 12),
                  updated: DateTime(2019, 7, 12, 7, 55),
                ),
              ],
            ),
          ],
        ).toJSON(),
      );
    });

    test('Can create notification', () {
      // ignore: missing_required_param
      final user = User(
        language: UserValue('language', 'en'),
        selection: [
          UserValue(Keys.selection('a', true), 'KRA-EK'),
        ],
      );
      final unitPlan = UnitPlanForGrade(
        grade: 'Q1',
        date: DateTime(2019, 10, 6),
        days: [
          UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'a',
                subjects: [
                  Subject(
                    unit: 0,
                    subject: 'EK',
                    teacher: 'KRA',
                    room: '525',
                    weeks: 'AB',
                  ),
                ],
              ),
              Lesson(
                unit: 1,
                block: 'a',
                subjects: [
                  Subject(
                    unit: 1,
                    subject: 'EK',
                    teacher: 'KRA',
                    room: '525',
                    weeks: 'AB',
                  ),
                  Subject(
                    unit: 1,
                    subject: 'EK',
                    teacher: 'KRA',
                    room: '526',
                    weeks: 'AB',
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      final replacementPlan = ReplacementPlanForGrade(
        grade: 'Q1',
        replacementPlanDays: [
          ReplacementPlanDay(
            date: DateTime(2019, 10, 7),
            updated: DateTime(2019, 10, 6, 21, 26),
          ),
        ],
        changes: [
          Change(
            unit: 0,
            date: DateTime(2019, 10, 7),
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            changed: Changed(
              subject: 'M',
              teacher: 'GRE',
              room: '511',
              info: 'LOL',
            ),
            type: ChangeTypes.exam,
          ),
          Change(
            unit: 1,
            date: DateTime(2019, 10, 7),
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            changed: Changed(
              subject: 'M',
              teacher: 'GRE',
              room: '511',
              info: 'LOL',
            ),
            type: ChangeTypes.exam,
          ),
          Change(
            unit: 1,
            date: DateTime(2019, 10, 7),
            subject: 'EK',
            teacher: 'KRA',
            room: '526',
            changed: Changed(
              subject: 'M',
              teacher: 'GRE',
              room: '511',
              info: 'LOL',
            ),
            type: ChangeTypes.freeLesson,
          ),
        ],
      );
      final notification = ReplacementPlanExtra.createNotification(
        user,
        unitPlan,
        replacementPlan,
        replacementPlan.replacementPlanDays[0],
        formatting: false,
      );
      final lines = notification.bigBody.split('\n');
      expect(notification.title, 'Monday 7.10.2019');
      expect(notification.body, '3 changes');
      expect(lines.length, 5);
      expect(lines[0], '1. unit:');
      expect(lines[1], 'Geography 525 KRA: Math 511 GRE Exam LOL');
      expect(lines[2], '2. unit:');
      expect(lines[3], 'Geography 525 KRA: Math 511 GRE Exam LOL');
      expect(lines[4], 'Geography 526 KRA: Math 511 GRE Free lesson LOL');
    });

    test('Can create notification with no changes', () {
      // ignore: missing_required_param
      final user = User(
        language: UserValue('language', 'en'),
        selection: [],
      );
      final unitPlan = UnitPlanForGrade(
        grade: 'Q1',
        date: DateTime(2019, 10, 6),
        days: [],
      );
      final replacementPlan = ReplacementPlanForGrade(
        grade: 'Q1',
        replacementPlanDays: [
          ReplacementPlanDay(
            date: DateTime(2019, 10, 7),
            updated: DateTime(2019, 10, 6, 21, 26),
          ),
        ],
        changes: [],
      );
      final notification = ReplacementPlanExtra.createNotification(
        user,
        unitPlan,
        replacementPlan,
        replacementPlan.replacementPlanDays[0],
        formatting: false,
      );
      final lines = notification.bigBody.split('\n');
      expect(notification.title, 'Monday 7.10.2019');
      expect(notification.body, 'No changes');
      expect(lines.length, 1);
      expect(lines[0], 'No changes');
    });
  });
}
