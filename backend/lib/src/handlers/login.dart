import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:nextcloud/nextcloud.dart';

/// LoginHandler class
class LoginHandler {
  // ignore: public_member_api_docs
  const LoginHandler(MySqlConnection mySqlConnection)
      : _mySqlConnection = mySqlConnection;

  final MySqlConnection _mySqlConnection;

  /// check the login
  Future<bool> checkLogin(HttpRequest request) async {
    try {
      if (request.headers.value('authorization') == null ||
          !request.headers.value('authorization').contains(' ')) {
        return false;
      }
      final encodedString =
          request.headers.value('authorization').split(' ')[1];
      final decodedString = utf8.decode(base64.decode(encodedString));
      final username = decodedString.split(':')[0];
      final password = decodedString.split(':')[1];
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      final results = await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT password FROM users_password WHERE username = \'$username\';');
      if (results.isNotEmpty) {
        final storedPasswordHash = results.toList()[0][0].toString();
        if (storedPasswordHash == hashedPassword) {
          return true;
        }
      }
      final client =
          NextCloudClient('nextcloud.aachen-vsa.logoip.de', username, password);
      final metaData = await client.metaData.getMetaData();
      var grade = metaData.groups.singleWhere((group) =>
          grades.contains(group.toUpperCase()) ||
          grades.contains(group.toLowerCase()));
      if (!grades.contains(grade)) {
        grade = grade.toUpperCase();
      }
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_password (username, password) VALUES (\'$username\' , \'$hashedPassword\') ON DUPLICATE KEY UPDATE password = \'$hashedPassword\';');
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_grade (username, grade) VALUES (\'$username\' , \'$grade\') ON DUPLICATE KEY UPDATE grade = \'$grade\';');
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_full_name (username, full_name) VALUES (\'$username\' , \'${metaData.fullName}\') ON DUPLICATE KEY UPDATE full_name = \'${metaData.fullName}\';');
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

  /// Fetch all user info from the database
  Future<User> getUser(HttpRequest request) async {
    final encodedString = request.headers.value('authorization').split(' ')[1];
    final decodedString = utf8.decode(base64.decode(encodedString));
    final username = decodedString.split(':')[0];
    final password = (await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT password FROM users_password WHERE username = \'$username\';'))
        .toList()[0][0]
        .toString();
    final grade = (await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT grade FROM users_grade WHERE username = \'$username\';'))
        .toList()[0][0]
        .toString();
    final fullName = (await _mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT full_name FROM users_full_name WHERE username = \'$username\';'))
        .toList()[0][0]
        .toString();
    return User(
      username: username,
      password: password,
      grade: grade,
      fullName: fullName,
    );
  }
}
