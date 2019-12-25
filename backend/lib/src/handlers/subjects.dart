import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// SubjectsHandler class
class SubjectsHandler extends Handler {
  // ignore: public_member_api_docs
  SubjectsHandler(MySqlConnection mySqlConnection)
      : super(Keys.subjects, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        'SELECT data FROM data_subjects ORDER BY date_time DESC LIMIT 1;');
    final subjects =
        Subjects.fromJSON(json.decode(results.toList()[0][0].toString()));
    return Tuple2(subjects.toJSON(), subjects.date.toIso8601String());
  }

  @override
  Future update() async {
    final subjects = SubjectsParser.extract(await loadUNSTFFile());
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_subjects (date_time, data) VALUES (\'${subjects.date.toIso8601String()}\', \'${json.encode(subjects.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(subjects.toJSON())}\';');
  }
}
