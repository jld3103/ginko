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
                ),
                Change(
                  unit: 0,
                  date: DateTime(2019, 7, 12),
                  subject: 'D',
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
  });
}
