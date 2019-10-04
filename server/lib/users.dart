import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// Users class
/// handles all user related things
class Users {
  /// List of all users
  static List<User> _users = [];

  /// Add a user to the database
  static void addUser(User user) {
    _users.add(User.fromJSON(user.toSafeJSON()));
    save();
  }

  /// Update the grade of a user
  static void updateGrade(String username, UserValue grade) {
    final user = getUser(username);
    if (user.grade.modified.isBefore(grade.modified)) {
      user.grade.value = grade.value;
      save();
    }
  }

  /// Update the language of a user
  static void updateLanguage(String username, UserValue language) {
    final user = getUser(username);
    if (user.language.modified.isBefore(language.modified)) {
      user.language.value = language.value;
      save();
    }
  }

  /// Update the selection of a user
  static void updateSelection(String username, List<UserValue> selection) {
    final user = getUser(username);
    for (final value in selection) {
      final values = user.selection.where((i) => i.key == value.key).toList();
      if (values.length != 1) {
        user.selection.add(value);
      } else {
        if (values[0].modified.isBefore(value.modified)) {
          values[0].value = value.value;
        }
      }
    }
    user.selection = user.selection
        .where((value) => value.key.startsWith('selection-${user.grade.value}'))
        .toList();
    save();
  }

  /// Update the tokens of a user
  static void updateTokens(String username, List<String> tokens) {
    getUser(username).tokens =
        (getUser(username).tokens..addAll(tokens)).toSet().toList();
    save();
  }

  /// Remove a token of a user
  static void removeToken(String username, String token) {
    final user = getUser(username);
    user.tokens = user.tokens..remove(token);
    save();
  }

  /// Get a user by their username
  static User getUser(String username) =>
      _users.where((user) => user.username == username).toList()[0];

  /// Get a list of all usernames
  static List<String> get usernames =>
      _users.map((user) => user.username).toList();

  /// Loads all users
  static void load() {
    _users = json
        .decode(File('../server/users.json').readAsStringSync())
        .map((i) => User.fromJSON(i))
        .toList()
        .cast<User>();
  }

  /// Save all users
  static void save() {
    File('../server/users.json').writeAsStringSync(
        json.encode(_users.map((user) => user.toJSON()).toList()));
  }
}
