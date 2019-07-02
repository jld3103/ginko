import 'package:meta/meta.dart';

/// Cafetoria class
/// describes the cafetoria menus for a week
class Cafetoria {
  // ignore: public_member_api_docs
  Cafetoria({
    @required this.saldo,
    @required this.days,
  });

  /// Creates a Cafetoria object from json
  factory Cafetoria.fromJSON(json) => Cafetoria(
        saldo: json['saldo'] == null
            ? null
            : double.parse(json['saldo'].toString()),
        days: json['days']
            .map((day) => CafetoriaDay.fromJSON(day))
            .toList()
            .cast<CafetoriaDay>(),
      );

  /// Creates json from a Cafetoria object
  Map<String, dynamic> toJSON() => {
        'saldo': saldo,
        'days': days.map((day) => day.toJSON()).toList(),
      };

  /// Get the time stamp of this object
  int get timeStamp =>
      days.isNotEmpty ? days[0].date.millisecondsSinceEpoch ~/ 1000 : 0;

  // ignore: public_member_api_docs
  final double saldo;

  // ignore: public_member_api_docs
  final List<CafetoriaDay> days;
}

/// CafetoriaDay class
/// describes the cafetoria menus for a day
class CafetoriaDay {
  // ignore: public_member_api_docs
  CafetoriaDay({
    @required this.date,
    @required this.menus,
  });

  /// Creates a CafetoriaDay object from json
  factory CafetoriaDay.fromJSON(json) => CafetoriaDay(
        date: DateTime.parse(json['date']),
        menus: json['menus']
            .map((day) => CafetoriaMenu.fromJSON(day))
            .toList()
            .cast<CafetoriaMenu>(),
      );

  /// Creates json from a CafetoriaDay object
  Map<String, dynamic> toJSON() => {
        'date': date.toIso8601String(),
        'menus': menus.map((menu) => menu.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  final DateTime date;

  // ignore: public_member_api_docs
  final List<CafetoriaMenu> menus;
}

/// CafetoriaMenu class
/// describes a cafetoria menu
class CafetoriaMenu {
  // ignore: public_member_api_docs
  CafetoriaMenu({
    @required this.name,
    @required this.times,
    @required this.price,
  });

  /// Creates a CafetoriaMenu object from json
  factory CafetoriaMenu.fromJSON(json) => CafetoriaMenu(
        name: json['name'],
        times: json['times']
            .map((time) => Duration(
                  hours: int.parse(time.split(':')[0]),
                  minutes: int.parse(time.split(':')[1]),
                ))
            .toList()
            .cast<Duration>(),
        price: double.parse(json['price'].toString()),
      );

  /// Creates json from a CafetoriaMenu object
  Map<String, dynamic> toJSON() => {
        'name': name,
        'times': times.map((time) {
          final hour = (time.inHours.toString().length == 1 ? '0' : '') +
              time.inHours.toString();
          final minute =
              ((time.inMinutes % 60).toString().length == 1 ? '0' : '') +
                  (time.inMinutes % 60).toString();
          return '$hour:$minute';
        }).toList(),
        'price': price,
      };

  // ignore: public_member_api_docs
  final String name;

  // ignore: public_member_api_docs
  final List<Duration> times;

  // ignore: public_member_api_docs
  final double price;
}
