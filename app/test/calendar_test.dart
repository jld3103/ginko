import 'package:flutter_test/flutter_test.dart';
import 'package:ginko/views/calendar/row.dart';
import 'package:models/calendar.dart';
import 'package:models/models.dart';

import 'utils.dart';

void main() {
  group('Calendar', () {
    group('Calendar row', () {
      testWidgets('Normal calendar row', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CalendarRow(
          event: CalendarEvent(
            name: 'Sommerferien',
            type: EventTypes.vacation,
            start: DateTime(2019, 7, 15),
            end: DateTime(2019, 8, 27, 23, 59, 59),
          ),
          // ignore: missing_required_param
          user: User(
            language: UserValue('language', 'en'),
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Sommerferien'), findsOneWidget);
        expect(find.text('July 15, 2019 - August 27, 2019'), findsOneWidget);
      });

      testWidgets('Normal calendar row with times', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CalendarRow(
          event: CalendarEvent(
            name: 'Sommerferien',
            type: EventTypes.vacation,
            start: DateTime(2019, 7, 15, 8),
            end: DateTime(2019, 8, 27, 8),
          ),
          // ignore: missing_required_param
          user: User(
            language: UserValue('language', 'en'),
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Sommerferien'), findsOneWidget);
        expect(
          find.text('July 15, 2019 08:00 - August 27, 2019 08:00'),
          findsOneWidget,
        );
      });

      testWidgets('Normal calendar row on same day', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CalendarRow(
          event: CalendarEvent(
            name: 'Tag der offenen Tür',
            type: EventTypes.vacation,
            start: DateTime(2018, 12, 8),
            end: DateTime(2018, 12, 8, 23, 59, 59),
          ),
          // ignore: missing_required_param
          user: User(
            language: UserValue('language', 'en'),
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Tag der offenen Tür'), findsOneWidget);
        expect(find.text('December 8, 2018'), findsOneWidget);
      });

      testWidgets('Normal calendar row on same day with time', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CalendarRow(
          event: CalendarEvent(
            name: 'Tag der offenen Tür',
            type: EventTypes.vacation,
            start: DateTime(2018, 12, 8, 8),
            end: DateTime(2018, 12, 8, 23, 59, 59),
          ),
          // ignore: missing_required_param
          user: User(
            language: UserValue('language', 'en'),
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Tag der offenen Tür'), findsOneWidget);
        expect(find.text('December 8, 2018 08:00'), findsOneWidget);
      });
    });
  });
}
