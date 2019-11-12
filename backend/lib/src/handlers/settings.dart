import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

/// SettingsHandler class
class SettingsHandler {
  // ignore: public_member_api_docs
  const SettingsHandler(MySqlConnection mySqlConnection)
      : _mySqlConnection = mySqlConnection;

  final MySqlConnection _mySqlConnection;

  /// Update the settings into the database
  Future<bool> updateSettings(
    LoginHandler login,
    HttpRequest request,
    String content,
  ) async {
    try {
      final user = await login.getUser(request);
      final settings = Settings.fromJSON(json.decode(content));
      for (final value in settings.settings) {
        final results = await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT date_time FROM users_settings WHERE username = \'${user.username}\' AND settings_key = \'${value.key}\';');
        if (results.toList().isNotEmpty) {
          final DateTime date = results.toList()[0][0];
          if (!value.modified.isAfter(date)) {
            continue;
          }
        }
        await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'INSERT INTO users_settings (username, settings_key, settings_value, date_time) VALUES (\'${user.username}\', \'${value.key}\', \'${value.value ? 1 : 0}\', \'${value.modified.toString().substring(0, value.modified.toString().length - 1)}\') ON DUPLICATE KEY UPDATE settings_value = \'${value.value ? 1 : 0}\', date_time = \'${value.modified.toString().substring(0, value.modified.toString().length - 1)}\';');
      }
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

  /// Get the latest settings from the database
  Future<List<Map<String, dynamic>>> getSettings(
    LoginHandler login,
    HttpRequest request,
  ) async {
    final user = await login.getUser(request);
    final results = await _mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT settings_key, settings_value, date_time FROM users_settings WHERE username = \'${user.username}\';');
    return Settings(results
            .map((row) => SettingsValue(row[0].toString(), row[1] == 1, row[2]))
            .toList()
            .cast<SettingsValue>()
            .toList())
        .toJSON();
  }
}
