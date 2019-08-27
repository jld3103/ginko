import 'package:ginko/views/cafetoria/row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/cafetoria.dart';

import 'utils.dart';

void main() {
  group('Cafetoria', () {
    group('Cafetoria row', () {
      testWidgets('Normal cafetoria row', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [], // TODO(jld3103): Add times
                price: 3.99,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln'), findsOneWidget);
        expect(find.text(' (3.99€)'), findsOneWidget);
      });

      testWidgets('Cafetoria row without price', (tester) async {
        await tester.pumpWidget(makeTestableWidget(CafetoriaRow(
          day: CafetoriaDay(
            date: DateTime(2019, 8, 9),
            menus: [
              CafetoriaMenu(
                name: 'Nudeln',
                times: [], // TODO(jld3103): Add times
                price: 0,
              ),
            ],
          ),
        )));
        await tester.pumpAndSettle();
        expect(find.text('Nudeln'), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      });
    });
  });
}
