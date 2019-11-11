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
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_devices (username, token, language, os) VALUES (\'${user.username}\', \'${device.token}\', \'${device.language}\', \'${device.os}\') ON DUPLICATE KEY UPDATE language = \'${device.language}\', os = \'${device.os}\';');
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }
}
