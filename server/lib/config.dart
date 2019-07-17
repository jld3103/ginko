import 'dart:convert';
import 'dart:io';

import 'package:server/path.dart';

// ignore: avoid_classes_with_only_static_members
/// Config class
/// handles all config things
class Config {
  // ignore: public_member_api_docs
  static String username;

  // ignore: public_member_api_docs
  static String password;

  // ignore: public_member_api_docs
  static String cafetoriaUsername;

  // ignore: public_member_api_docs
  static String cafetoriaPassword;

  // ignore: public_member_api_docs
  static String fcmServerKey;

  // ignore: public_member_api_docs
  static Map<String, String> headers;

  /// Load all config
  static void load([bool environment = false]) {
    if (File('${Path.getBasePath}server/config.json').existsSync()) {
      environment = false;
    }
    final Map<String, dynamic> data = environment
        ? Platform.environment
        : json.decode(
            File('${Path.getBasePath}server/config.json').readAsStringSync());
    username = data['username'];
    password = data['password'];
    cafetoriaUsername = data['cafetoriaUsername'];
    cafetoriaPassword = data['cafetoriaPassword'];
    fcmServerKey = data['fcmServerKey'];
    headers = {
      'authorization':
          // ignore: lines_longer_than_80_chars
          'Basic ${base64Encode(utf8.encode('${Config.username}:${Config.password}'))}',
    };
  }
}
