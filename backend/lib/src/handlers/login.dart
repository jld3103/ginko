import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

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
      final username = decodedString.split(':')[0].toLowerCase();
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
      final data = await (Dio()
            ..options = BaseOptions(
              headers: {
                'authorization':
                    // ignore: lines_longer_than_80_chars
                    'Basic ${base64.encode(utf8.encode('$username:$password'))}',
              },
              responseType: ResponseType.plain,
              connectTimeout: 10000,
              receiveTimeout: 10000,
            ))
          .get('http://89.1.28.21/login');
      final grade = json.decode(data.toString())['grade'];
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_password (username, password) VALUES (\'$username\' , \'$hashedPassword\') ON DUPLICATE KEY UPDATE password = \'$hashedPassword\';');
      await _mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO users_grade (username, grade) VALUES (\'$username\' , \'$grade\') ON DUPLICATE KEY UPDATE grade = \'$grade\';');
      return true;
    } on DioError {
      return false;
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
    final username = decodedString.split(':')[0].toLowerCase();
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
    return User(
      username: username,
      password: password,
      grade: grade,
    );
  }
}
