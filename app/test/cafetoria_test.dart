import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ginko/views/cafetoria/row.dart';
import 'package:models/models.dart';

import 'utils.dart';

void main() {
  group('Cafetoria', () {
    group('Cafetoria row', () {
      testWidgets('Normal cafetoria row', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          // ignore: missing_required_param
          device: Device(
            language: 'de',
            token: null,
            os: null,
          ),
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [
                  Duration(hours: 12, minutes: 40),
                  Duration(hours: 13),
                ],
                price: 3.99,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln (3.99€)'), findsOneWidget);
        expect(find.text('12:40 - 13:00'), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('Cafetoria row without price', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          // ignore: missing_required_param
          device: Device(
            language: 'de',
            token: null,
            os: null,
          ),
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [
                  Duration(hours: 12, minutes: 40),
                  Duration(hours: 13),
                ],
                price: 0,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln'), findsOneWidget);
        expect(find.text('12:40 - 13:00'), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('Cafetoria row without times', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          // ignore: missing_required_param
          device: Device(
            language: 'de',
            token: null,
            os: null,
          ),
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [],
                price: 3.99,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln (3.99€)'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('Cafetoria row without times', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          // ignore: missing_required_param
          device: Device(
            language: 'de',
            token: null,
            os: null,
          ),
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [],
                price: 0,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });

      testWidgets('Cafetoria row with date', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          // ignore: missing_required_param
          device: Device(
            language: 'de',
            token: null,
            os: null,
          ),
          showDate: true,
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [
                  Duration(hours: 12, minutes: 40),
                  Duration(hours: 13),
                ],
                price: 3.99,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln (3.99€)'), findsOneWidget);
        expect(find.text('12:40 - 13:00'), findsOneWidget);
        expect(find.text('Friday 09.08.2019'), findsOneWidget);
        expect(find.byType(Text), findsNWidgets(3));
      });
    });
  });
}
