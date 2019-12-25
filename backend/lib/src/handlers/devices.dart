import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

/// DevicesHandler class
class DevicesHandler {
  // ignore: public_member_api_docs
  const DevicesHandler(MySqlConnection mySqlConnection)
      : _mySqlConnection = mySqlConnection;

  final MySqlConnection _mySqlConnection;

  /// Update a device into the database
  Future<bool> updateDevice(
    LoginHandler login,
    HttpRequest request,
    String content,
  ) async {
    try {
      final user = await login.getUser(request);
      final device = Device.fromJSON(json.decode(content));
      final date = DateTime.now()
          .toString()
          .substring(0, DateTime.now().toString().length - 1);
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_devices (username, token, os, version, last_active) VALUES (\'${user.username}\', \'${device.token}\', \'${device.os}\', \'${device.version}\', \'$date\') ON DUPLICATE KEY UPDATE version = \'${device.version}\', last_active = \'$date\';');
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }
}
