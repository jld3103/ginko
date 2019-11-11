import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// User class
/// describes a user
class User {
  // ignore: public_member_api_docs
  User({
    @required this.username,
    @required this.password,
    @required this.grade,
    @required this.fullName,
  });

  // ignore: public_member_api_docs
  factory User.fromJSON(Map<String, dynamic> json) => User(
        username: json['username'],
        password: json['password'],
        grade: json['grade'],
        fullName: json['fullName'],
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'username': username,
        'password': password,
        'grade': grade,
        'fullName': fullName,
      };

  // ignore: public_member_api_docs
  Map<String, dynamic> toSafeJSON() => {
        'username': username,
        'password': sha256.convert(utf8.encode(password)).toString(),
        'grade': grade,
        'fullName': fullName,
      };

  // ignore: public_member_api_docs
  String username;

  // ignore: public_member_api_docs
  String password;

  // ignore: public_member_api_docs
  String grade;

  // ignore: public_member_api_docs
  String fullName;
}
