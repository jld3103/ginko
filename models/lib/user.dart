import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// User class
/// describes a user
/// There are no setters for username and password,
/// because then a new user object gets created
class User {
  // ignore: public_member_api_docs
  User({
    @required String username,
    @required String password,
    @required this.grade,
    @required this.language,
    @required List<UserValue> selection,
    @required List<String> tokens,
  }) {
    _username = username;
    _password = password;
    this.selection = selection ?? [];
    this.tokens = tokens ?? [];
  }

  // ignore: public_member_api_docs
  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
        password: json['password'],
        grade: UserValue.fromJSON(json['grade']),
        language: UserValue.fromJSON(json['language']),
        selection: json['selection'] == null
            ? []
            : json['selection']
                .map((i) => UserValue.fromJSON(i))
                .toList()
                .cast<UserValue>(),
        tokens: json['tokens'] == null ? [] : json['tokens'].cast<String>(),
      );

  // ignore: public_member_api_docs
  factory User.fromEncryptedJSON(Map<String, dynamic> json,
          String originalUsername, String originalPassword) =>
      User(
        username: originalUsername,
        password: originalPassword,
        grade: UserValue.fromJSON(json['grade']),
        language: UserValue.fromJSON(json['language']),
        selection: json['selection'] == null
            ? []
            : json['selection']
                .map((i) => UserValue.fromJSON(i))
                .toList()
                .cast<UserValue>(),
        tokens: json['tokens'] == null ? [] : json['tokens'].cast<String>(),
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'username': _username,
        'password': _password,
        'grade': grade.toJSON(),
        'language': language.toJSON(),
        'selection': selection.map((i) => i.toJSON()).toList(),
        'tokens': tokens,
      };

  // ignore: public_member_api_docs
  Map<String, dynamic> toEncryptedJSON() => {
        'username': encryptedUsername,
        'password': encryptedPassword,
        'grade': grade.toJSON(),
        'language': language.toJSON(),
        'selection': selection.map((i) => i.toJSON()).toList(),
        'tokens': tokens,
      };

  String _username;
  String _password;

  // ignore: public_member_api_docs
  UserValue grade;

  // ignore: public_member_api_docs
  UserValue language;

  // ignore: public_member_api_docs
  List<UserValue> selection;

  // ignore: public_member_api_docs
  List<String> tokens = [];

  // ignore: public_member_api_docs
  String get username => _username;

  // ignore: public_member_api_docs
  String get password => _password;

  // ignore: public_member_api_docs
  String get encryptedUsername =>
      sha256.convert(utf8.encode(_username)).toString();

  // ignore: public_member_api_docs
  String get encryptedPassword =>
      sha256.convert(utf8.encode(_password)).toString();

  // ignore: public_member_api_docs
  String getSelection(String key) {
    final values = selection.where((i) => i.key == key).toList();
    if (values.length != 1) {
      return null;
    }
    return values[0].value;
  }

  // ignore: public_member_api_docs
  void setSelection(String key, String value) {
    final values = selection.where((i) => i.key == key).toList();
    if (values.isEmpty) {
      selection.add(UserValue(key, value));
    } else {
      values[0].value = value;
    }
  }
}

/// UserValue class
/// describes a value of the user config
class UserValue {
  // ignore: public_member_api_docs
  UserValue(this.key, value, [DateTime modified]) {
    _value = value;
    _modified = modified ?? DateTime.now();
  }

  // ignore: public_member_api_docs
  factory UserValue.fromJSON(Map<String, dynamic> json) => UserValue(
        json['key'],
        json['value'],
        json['modified'] == null
            ? DateTime.now()
            : DateTime.parse(json['modified']),
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'key': key,
        'value': value,
        'modified': _modified.toIso8601String(),
      };

  // ignore: public_member_api_docs, type_annotate_public_apis
  set value(value) {
    _value = value;
    _modified = DateTime.now();
  }

  // ignore: public_member_api_docs
  dynamic get value => _value;

  // ignore: public_member_api_docs
  DateTime get modified => _modified;

  // ignore: public_member_api_docs
  final String key;
  dynamic _value;
  DateTime _modified;
}
