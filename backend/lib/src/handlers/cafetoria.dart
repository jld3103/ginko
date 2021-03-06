import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// CafetoriaHandler class
class CafetoriaHandler extends Handler {
  // ignore: public_member_api_docs
  CafetoriaHandler(MySqlConnection mySqlConnection)
      : super(Keys.cafetoria, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_cafetoria WHERE date_time > \'${monday(DateTime.now()).subtract(Duration(seconds: 1)).toIso8601String()}\';');
    final cafetoria = Cafetoria(
      saldo: null,
      days: results
          .toList()
          .map((row) => CafetoriaDay.fromJSON(json.decode(row[0].toString())))
          .cast<CafetoriaDay>()
          .toList(),
    );
    return Tuple2(cafetoria.toJSON(),
        cafetoria.days.map((day) => day.date.toIso8601String()).join(''));
  }

  @override
  Future update() async {
    final cafetoria = CafetoriaParser.extract(
      await CafetoriaParser.download(
        Config.cafetoriaUsername,
        Config.cafetoriaPassword,
      ),
      false,
    );
    final notificationDays = [];
    for (final day in cafetoria.days) {
      final dataString = json
          .encode(day.toJSON())
          .replaceAll('\\n', '')
          .replaceAll('"', '\\"');
      final results = await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT data FROM data_cafetoria WHERE date_time = \'${day.date}\';');
      if (results.isNotEmpty) {
        final storedData = results.toList()[0][0].toString();
        if (storedData == dataString) {
          continue;
        }
      }
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_cafetoria (date_time, data) VALUES (\'${day.date}\', \'$dataString\') ON DUPLICATE KEY UPDATE data = \'$dataString\';');
      notificationDays.add(day);
    }
    if (notificationDays.isNotEmpty) {
      // ignore: omit_local_variable_types
      const title = 'Cafétoria';
      final body =
          // ignore: lines_longer_than_80_chars
          '${notificationDays.length} Tage';
      final bigBody = notificationDays
          .map((day) =>
              // ignore: lines_longer_than_80_chars
              '${weekdays[day.date.weekday - 1]} (${day.menus.length} Menüs)')
          .join('<br/>');
      final notification = Notification(
        Keys.cafetoria,
        title,
        body,
        bigBody,
        data: {
          Keys.type: Keys.cafetoria,
        },
      );
      final tokens = <String>[];
      final devicesResults = await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT username, token FROM users_devices;');
      for (final row in devicesResults.toList()) {
        final username = row[0].toString();
        final token = row[1].toString();
        if (token == '') {
          continue;
        }
        final settingsResults = await mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT settings_value FROM users_settings WHERE username = \'$username\' AND settings_key = \'${Keys.cafetoriaNotifications}\';');
        bool showNotifications;
        if (settingsResults.isNotEmpty) {
          showNotifications = settingsResults.toList()[0][0] == 1;
        } else {
          showNotifications = true;
        }
        if (showNotifications) {
          tokens.add(token);
        }
      }
      final cached = await Notifications.checkNotificationCached(
          notification, mySqlConnection, tokens);
      await Notifications.sendNotification(notification,
          tokens.where((t) => !cached[tokens.indexOf(t)]).toList());
    }
  }
}
