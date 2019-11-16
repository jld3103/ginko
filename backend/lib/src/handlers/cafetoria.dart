import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_server.dart';
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
        'SELECT data FROM data_cafetoria ORDER BY date_time DESC LIMIT 5;');
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
      final dataString = json.encode(day.toJSON()).replaceAll('\\n', '');
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
      final Map<String, List<String>> notifications = {};
      for (final locale in LocalesList.locales) {
        final title = ServerTranslations.pageCafetoria(locale);
        final body =
            // ignore: lines_longer_than_80_chars
            '${notificationDays.length} ${ServerTranslations.cafetoriaDays(locale)}';
        final bigBody = notificationDays
            .map((day) =>
                // ignore: lines_longer_than_80_chars
                '${ServerTranslations.weekdays(locale)[day.date.weekday - 1]} (${day.menus.length} ${ServerTranslations.cafetoriaMenus(locale)})')
            .join('<br/>');
        final notification = Notification(
          title,
          body,
          bigBody,
          data: {
            Keys.type: Keys.cafetoria,
          },
        );
        final devicesResults = await mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT username, token FROM users_devices WHERE language = \'$locale\';');
        for (final row in devicesResults.toList()) {
          final username = row[0].toString();
          final token = row[1].toString();
          final settingsResults = await mySqlConnection.query(
              // ignore: lines_longer_than_80_chars
              'SELECT settings_value FROM users_settings WHERE username = \'$username\' AND settings_key = \'${Keys.settingsKey(Keys.cafetoriaNotifications)}\';');
          bool showNotifications;
          if (settingsResults.isNotEmpty) {
            showNotifications = settingsResults.toList()[0][0] == 1;
          } else {
            showNotifications = true;
          }
          if (showNotifications) {
            if (notifications[json.encode(notification.toJSON())] == null) {
              notifications[json.encode(notification.toJSON())] = [];
            }
            notifications[json.encode(notification.toJSON())].add(token);
          }
        }
      }
      for (final notification in notifications.keys) {
        await Notifications.sendNotification(
          Notification.fromJSON(json.decode(notification)),
          notifications[notification],
        );
      }
    }
  }
}
