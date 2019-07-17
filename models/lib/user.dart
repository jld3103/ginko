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
    @required Map<String, String> selection,
    @required List<String> tokens,
  }) {
    _username = username;
    _password = password;
    this.selection = selection ?? {};
    this.tokens = tokens ?? [];
  }

  // ignore: public_member_api_docs
  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
        password: json['password'],
        grade: json['grade'],
        language: json['language'],
        selection: json['selection'] == null
            ? {}
            : json['selection'].cast<String, String>(),
        tokens: json['tokens'] == null ? [] : json['tokens'].cast<String>(),
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'username': _username,
        'password': _password,
        'grade': grade,
        'language': language,
        'selection': selection,
        'tokens': tokens,
      };

  // ignore: public_member_api_docs
  Map<String, dynamic> toEncryptedJSON() => {
        'username': encryptedUsername,
        'password': encryptedPassword,
        'grade': grade,
        'language': language,
        'selection': selection,
        'tokens': tokens,
      };

  String _username;
  String _password;

  // ignore: public_member_api_docs
  String grade;

  // ignore: public_member_api_docs
  String language;

  // ignore: public_member_api_docs
  Map<String, String> selection;

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
  String getSelection(String key) => selection[key];

  // ignore: public_member_api_docs
  void setSelection(String key, String value) {
    selection[key] = value;
  }
}
