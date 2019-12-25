import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:tuple/tuple.dart';

// ignore: public_member_api_docs
abstract class Handler {
  // ignore: public_member_api_docs
  const Handler(this.name, this.mySqlConnection);

  // ignore: public_member_api_docs
  final String name;

  // ignore: public_member_api_docs
  final MySqlConnection mySqlConnection;

  // ignore: public_member_api_docs
  Future update() async {}

  // ignore: public_member_api_docs
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user);

  // ignore: public_member_api_docs
  Future<String> fetchLatestResourceID(User user) async => sha256
      .convert(utf8.encode(json.encode((await fetchLatest(user)).item1)))
      .toString();
}
