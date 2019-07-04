import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Cafetoria', () {
    test('Can create cafetoria menu', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      expect(menu.name, 'test');
      expect(
        menu.times,
        [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
      );
      expect(menu.price, 3);
    });

    test('Can create cafetoria menu from JSON', () {
      final menu = CafetoriaMenu.fromJSON({
        'name': 'test',
        'times': [
          '12:40',
          '13:00',
        ],
        'price': 3,
      });
      expect(menu.name, 'test');
      expect(
        menu.times,
        [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
      );
      expect(menu.price, 3);
    });

    test('Can create JSON from cafetoria menu', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      expect(
        menu.toJSON(),
        {
          'name': 'test',
          'times': [
            '12:40',
            '13:00',
          ],
          'price': 3,
        },
      );
    });

    test('Can create cafetoria menu from JSON from cafetoria menu', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      expect(CafetoriaMenu.fromJSON(menu.toJSON()).toJSON(), menu.toJSON());
    });

    test('Can create cafetoria day', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [menu],
      );
      expect(day.date, DateTime(2019, 7, 1));
      expect(day.menus, [menu]);
    });

    test('Can create cafetoria day from JSON', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      final day = CafetoriaDay.fromJSON({
        'date': DateTime(2019, 7, 1).toIso8601String(),
        'menus': [menu.toJSON()],
      });
      expect(day.date, DateTime(2019, 7, 1));
      expect(day.menus.map((menu) => menu.toJSON()).toList(), [menu.toJSON()]);
    });

    test('Can create JSON from cafetoria day', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [menu],
      );
      expect(
        day.toJSON(),
        {
          'date': DateTime(2019, 7, 1).toIso8601String(),
          'menus': [menu.toJSON()],
        },
      );
    });

    test('Can create cafetoria day from JSON from cafetoria day', () {
      final menu = CafetoriaMenu(
        name: 'test',
        times: [
          Duration(hours: 12, minutes: 40),
          Duration(hours: 13),
        ],
        price: 3,
      );
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [menu],
      );
      expect(CafetoriaDay.fromJSON(day.toJSON()).toJSON(), day.toJSON());
    });

    test('Can create cafetoria', () {
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [],
      );
      final cafetoria = Cafetoria(
        saldo: 0,
        days: [day],
      );
      expect(cafetoria.saldo, 0);
      expect(cafetoria.days, [day]);
      expect(
        cafetoria.days[0].date.millisecondsSinceEpoch ~/ 1000,
        cafetoria.timeStamp,
      );
    });

    test('Can create cafetoria from JSON', () {
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [],
      );
      final cafetoria = Cafetoria.fromJSON({
        'saldo': 0,
        'days': [day.toJSON()],
      });
      expect(cafetoria.saldo, 0);
      expect(cafetoria.days.map((day) => day.toJSON()), [day.toJSON()]);
      expect(
        cafetoria.days[0].date.millisecondsSinceEpoch ~/ 1000,
        cafetoria.timeStamp,
      );
    });

    test('Can create JSON from cafetoria', () {
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [],
      );
      final cafetoria = Cafetoria(
        saldo: 0,
        days: [day],
      );
      expect(
        cafetoria.toJSON(),
        {
          'saldo': 0,
          'days': [day.toJSON()],
        },
      );
    });

    test('Can create cafetoria from JSON from cafetoria', () {
      final day = CafetoriaDay(
        date: DateTime(2019, 7, 1),
        menus: [],
      );
      final cafetoria = Cafetoria(
        saldo: 0,
        days: [day],
      );
      expect(
        Cafetoria.fromJSON(cafetoria.toJSON()).toJSON(),
        cafetoria.toJSON(),
      );
    });
  });
}
