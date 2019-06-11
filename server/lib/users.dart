import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

// ignore: avoid_classes_with_only_static_members
/// Users class
/// handles all user related things
class Users {
  /// Map of all users
  static Map<String, String> users = {};

  /// Loads all users
  static void load() {
    final Map<String, String> data = json
        .decode(File('users.json').readAsStringSync())
        .cast<String, String>();
    for (var username in data.keys) {
      final password = sha256.convert(utf8.encode(data[username])).toString();
      username = sha256.convert(utf8.encode(username)).toString();
      users[username] = password;
    }
  }
}
