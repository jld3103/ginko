import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// Users class
/// handles all user related things
class Users {
  /// List of all users
  static List<User> _users = [];

  /// Update the grade of a user
  static void updateGrade(String encryptedUsername, UserValue grade) {
    if (getUser(encryptedUsername).grade.modified.isBefore(grade.modified)) {
      getUser(encryptedUsername).grade.value = grade.value;
      File('../server/users.json').writeAsStringSync(
          json.encode(_users.map((user) => user.toJSON()).toList()));
    }
  }

  /// Update the language of a user
  static void updateLanguage(String encryptedUsername, UserValue language) {
    if (getUser(encryptedUsername)
        .language
        .modified
        .isBefore(language.modified)) {
      getUser(encryptedUsername).language.value = language.value;
      File('../server/users.json').writeAsStringSync(
          json.encode(_users.map((user) => user.toJSON()).toList()));
    }
  }

  /// Update the selection of a user
  static void updateSelection(
      String encryptedUsername, List<UserValue> selection) {
    for (final value in selection) {
      final values = getUser(encryptedUsername)
          .selection
          .where((i) => i.key == value.key)
          .toList();
      if (values.length != 1) {
        getUser(encryptedUsername).selection.add(value);
      } else {
        if (values[0].modified.isBefore(value.modified)) {
          values[0].value = value.value;
        }
      }
    }
    File('../server/users.json').writeAsStringSync(
        json.encode(_users.map((user) => user.toJSON()).toList()));
  }

  /// Update the tokens of a user
  static void updateTokens(String encryptedUsername, List<String> tokens) {
    getUser(encryptedUsername).tokens =
        (getUser(encryptedUsername).tokens..addAll(tokens)).toSet().toList();
    File('../server/users.json').writeAsStringSync(
        json.encode(_users.map((user) => user.toJSON()).toList()));
  }

  /// Remove a token of a user
  static void removeToken(String encryptedUsername, String token) {
    getUser(encryptedUsername).tokens = getUser(encryptedUsername).tokens
      ..remove(token);
    File('../server/users.json').writeAsStringSync(
        json.encode(_users.map((user) => user.toJSON()).toList()));
  }

  /// Get a user by their encrypted username
  static User getUser(String encryptedUsername) => _users
      .where((user) => user.encryptedUsername == encryptedUsername)
      .toList()[0];

  /// Get a list of all encrypted usernames
  static List<String> get encryptedUsernames =>
      _users.map((user) => user.encryptedUsername).toList();

  /// Loads all users
  static void load() {
    _users = json
        .decode(File('../server/users.json').readAsStringSync())
        .map((i) => User.fromJSON(i))
        .toList()
        .cast<User>();
  }
}
