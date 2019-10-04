import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ginko/views/unitplan/all_row.dart';
import 'package:ginko/views/unitplan/row.dart';
import 'package:ginko/views/unitplan/select_dialog.dart';
import 'package:models/models.dart';
import 'package:translations/translations_server.dart';

import 'utils.dart';

void main() {
  group('Unit plan', () {
    group('Unit plan row', () {
      testWidgets('Normal unit plan row', (tester) async {
        await tester.pumpWidget(makeTestableWidget(UnitPlanRow(
          subject: Subject(
            unit: 0,
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            weeks: null,
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Unit plan row without unit', (tester) async {
        await tester.pumpWidget(makeTestableWidget(UnitPlanRow(
          subject: Subject(
            unit: 0,
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            weeks: null,
          ),
          showUnit: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsNothing);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Unit plan row without real subject', (tester) async {
        await tester.pumpWidget(makeTestableWidget(UnitPlanRow(
          subject: Subject(
            unit: 0,
            subject: 'LOL',
            teacher: 'KRA',
            room: '525',
            weeks: null,
          ),
          showUnit: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsNothing);
        expect(find.text(''), findsOneWidget);
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Unit plan row without real room', (tester) async {
        await tester.pumpWidget(makeTestableWidget(UnitPlanRow(
          subject: Subject(
            unit: 0,
            subject: 'EK',
            teacher: 'KRA',
            room: null,
            weeks: null,
          ),
          showUnit: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsNothing);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('Unit plan row without real teacher', (tester) async {
        await tester.pumpWidget(makeTestableWidget(UnitPlanRow(
          subject: Subject(
            unit: 0,
            subject: 'EK',
            teacher: null,
            room: '525',
            weeks: null,
          ),
          showUnit: false,
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsNothing);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text(''), findsOneWidget);
        expect(find.text('525'), findsOneWidget);
      });
    });

    group('Unit plan all row', () {
      testWidgets('Unit plan all row without changes ', (tester) async {
        final subject = Subject(
          unit: 0,
          subject: 'EK',
          teacher: 'KRA',
          room: '525',
          weeks: null,
        );
        await tester.pumpWidget(makeTestableWidget(UnitPlanAllRow(
          start: DateTime(2019, 8, 5),
          unitPlanDay: UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'a',
                subjects: [subject],
              ),
            ],
          ),
          subject: subject,
          replacementPlan: ReplacementPlanForGrade(
            grade: 'EF',
            replacementPlanDays: [
              ReplacementPlanDay(
                date: DateTime(2019, 8, 5),
                updated: DateTime(2019, 8, 5, 7, 55),
              ),
              ReplacementPlanDay(
                date: DateTime(2019, 8, 6),
                updated: DateTime(2019, 8, 5, 7, 55),
              ),
            ],
            changes: [
              Change(
                unit: 0,
                date: DateTime(2019, 8, 6),
                subject: 'EK',
                teacher: 'KRA',
                room: '525',
                changed: Changed(),
              ),
              Change(
                unit: 1,
                date: DateTime(2019, 8, 5),
                subject: 'EK',
                teacher: 'KRA',
                room: '525',
                changed: Changed(),
              ),
              Change(
                unit: 0,
                date: DateTime(2019, 8, 5),
                subject: 'EK',
                teacher: 'STA',
                room: '525',
                changed: Changed(),
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('STA'), findsNothing);
        expect(find.text('525'), findsOneWidget);
      });

      testWidgets('Unit plan all row with changes with subject',
          (tester) async {
        final subject = Subject(
          unit: 0,
          subject: 'EK',
          teacher: 'KRA',
          room: '525',
          weeks: null,
        );
        await tester.pumpWidget(makeTestableWidget(UnitPlanAllRow(
          start: DateTime(2019, 8, 5),
          current: DateTime(2019, 8, 5),
          unitPlanDay: UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'a',
                subjects: [subject],
              ),
            ],
          ),
          subject: subject,
          replacementPlan: ReplacementPlanForGrade(
            grade: 'EF',
            replacementPlanDays: [
              ReplacementPlanDay(
                date: DateTime(2019, 8, 5),
                updated: DateTime(2019, 8, 5, 7, 55),
              ),
            ],
            changes: [
              Change(
                unit: 0,
                date: DateTime(2019, 8, 5),
                subject: 'EK',
                teacher: 'KRA',
                room: '525',
                changed: Changed(
                  subject: 'EK',
                  teacher: 'KRA',
                  room: '525',
                ),
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsNWidgets(2),
        );
        expect(
          // ignore: prefer_interpolation_to_compose_strings
          find.text(ServerTranslations.subjects('en')['EK'] +
              ': ' +
              ServerTranslations.replacementPlanUnknown('en')),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(3));
        expect(find.text('525'), findsNWidgets(3));
      });

      testWidgets('Unit plan all row with changes with info', (tester) async {
        final subject = Subject(
          unit: 0,
          subject: 'EK',
          teacher: 'KRA',
          room: '525',
          weeks: null,
        );
        await tester.pumpWidget(makeTestableWidget(UnitPlanAllRow(
          start: DateTime(2019, 8, 5),
          current: DateTime(2019, 8, 5),
          unitPlanDay: UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'a',
                subjects: [subject],
              ),
            ],
          ),
          subject: subject,
          replacementPlan: ReplacementPlanForGrade(
            grade: 'EF',
            replacementPlanDays: [
              ReplacementPlanDay(
                date: DateTime(2019, 8, 5),
                updated: DateTime(2019, 8, 5, 7, 55),
              ),
            ],
            changes: [
              Change(
                unit: 0,
                date: DateTime(2019, 8, 5),
                subject: 'EK',
                teacher: 'KRA',
                room: '525',
                changed: Changed(
                  teacher: 'KRA',
                  room: '525',
                  info: 'LOL',
                ),
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsNWidgets(2),
        );
        expect(
          // ignore: prefer_interpolation_to_compose_strings
          find.text(ServerTranslations.replacementPlanUnknown('en') + ' LOL'),
          findsOneWidget,
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(3));
        expect(find.text('525'), findsNWidgets(3));
      });

      testWidgets('Unit plan all row with changes with info and subject',
          (tester) async {
        final subject = Subject(
          unit: 0,
          subject: 'EK',
          teacher: 'KRA',
          room: '525',
          weeks: null,
        );
        await tester.pumpWidget(makeTestableWidget(UnitPlanAllRow(
          start: DateTime(2019, 8, 5),
          current: DateTime(2019, 8, 5),
          unitPlanDay: UnitPlanDay(
            weekday: 0,
            lessons: [
              Lesson(
                unit: 0,
                block: 'a',
                subjects: [subject],
              ),
            ],
          ),
          subject: subject,
          replacementPlan: ReplacementPlanForGrade(
            grade: 'EF',
            replacementPlanDays: [
              ReplacementPlanDay(
                date: DateTime(2019, 8, 5),
                updated: DateTime(2019, 8, 5, 7, 55),
              ),
            ],
            changes: [
              Change(
                unit: 0,
                date: DateTime(2019, 8, 5),
                subject: 'EK',
                teacher: 'KRA',
                room: '525',
                changed: Changed(
                  subject: 'EK',
                  teacher: 'KRA',
                  room: '525',
                  info: 'LOL',
                ),
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('1'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsNWidgets(2),
        );
        expect(find.text('08:00 - 09:00'), findsOneWidget);
        expect(find.text('KRA'), findsNWidgets(3));
        expect(find.text('525'), findsNWidgets(3));
        expect(
          // ignore: prefer_interpolation_to_compose_strings
          find.text(ServerTranslations.subjects('en')['EK'] +
              ': ' +
              ServerTranslations.replacementPlanUnknown('en') +
              ' LOL'),
          findsOneWidget,
        );
      });
    });

    group('Select dialog', () {
      testWidgets('Normal select dialog', (tester) async {
        final subjects = [
          Subject(
            unit: 0,
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            weeks: 'AB',
          ),
          Subject(
            unit: 0,
            subject: 'IF',
            teacher: 'HNZ',
            room: 'PC2',
            weeks: 'AB',
          ),
          Subject(
            unit: 0,
            subject: 'FR',
            weeks: 'AB',
            teacher: null,
            room: null,
          ),
        ];
        await tester.pumpWidget(makeTestableWidget(DialogTester(
          UnitPlanSelectDialog(
            weekday: 0,
            lesson: Lesson(
              unit: 0,
              block: 'a',
              subjects: subjects,
            ),
          ),
          dataCallback: (data) {
            final s = data.cast<Subject>();
            expect(s.length, 1);
            expect(s[0], subjects[1]);
          },
        )));
        await tester.pumpAndSettle();
        expect(
          find.text('${ServerTranslations.weekdays('en')[0]} 1.'),
          findsOneWidget,
        );
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsOneWidget,
        );
        expect(find.text('KRA'), findsOneWidget);
        expect(find.text('525'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['IF']),
          findsOneWidget,
        );
        expect(find.text('HNZ'), findsOneWidget);
        expect(find.text('PC2'), findsOneWidget);
        expect(
          find.text(ServerTranslations.subjects('en')['FR']),
          findsOneWidget,
        );
        expect(find.text(''), findsNWidgets(2));
        expect(find.text('08:00 - 09:00'), findsNWidgets(3));

        await tester.tap(find.byType(GestureDetector).at(1));
        await tester.pump();
      });

      testWidgets('Select dialog with a/b options', (tester) async {
        final subjects = [
          Subject(
            unit: 0,
            subject: 'EK',
            teacher: 'KRA',
            room: '525',
            weeks: 'A',
          ),
          Subject(
            unit: 0,
            subject: 'IF',
            teacher: 'HNZ',
            room: 'PC2',
            weeks: 'B',
          ),
          Subject(
            unit: 0,
            subject: 'FR',
            weeks: 'AB',
            teacher: null,
            room: null,
          ),
        ];
        await tester.pumpWidget(makeTestableWidget(DialogTester(
          UnitPlanSelectDialog(
            weekday: 0,
            lesson: Lesson(
              unit: 0,
              block: 'a',
              subjects: subjects,
            ),
          ),
          dataCallback: (data) {
            final s = data.cast<Subject>();
            expect(s.length, 2);
            expect(s[0], subjects[0]);
            expect(s[1], subjects[1]);
          },
        )));
        await tester.pumpAndSettle();
        expect(
          find.text('${ServerTranslations.weekdays('en')[0]} 1.'),
          findsOneWidget,
        );
        expect(
          find.text(ServerTranslations.subjects('en')['EK']),
          findsNWidgets(2),
        );
        expect(find.text('KRA'), findsNWidgets(2));
        expect(find.text('525'), findsNWidgets(2));
        expect(
          find.text(ServerTranslations.subjects('en')['IF']),
          findsNWidgets(2),
        );
        expect(find.text('HNZ'), findsNWidgets(2));
        expect(find.text('PC2'), findsNWidgets(2));
        expect(
          find.text(ServerTranslations.subjects('en')['FR']),
          findsNWidgets(3),
        );
        expect(find.text(''), findsNWidgets(6));
        expect(find.text('08:00 - 09:00'), findsNWidgets(7));

        await tester.tap(find.byType(GestureDetector).at(1));
        await tester.pump();
      });
    });
  });
}
