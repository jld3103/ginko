import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// TeachersHandler class
class TeachersHandler extends Handler {
  // ignore: public_member_api_docs
  TeachersHandler(MySqlConnection mySqlConnection)
      : super(Keys.teachers, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        'SELECT data FROM data_teachers ORDER BY date_time DESC LIMIT 1;');
    final teachers =
        Teachers.fromJSON(json.decode(results.toList()[0][0].toString()));
    return Tuple2(teachers.toJSON(), teachers.date.toIso8601String());
  }

  @override
  Future update(Config config) async {
    final teachers = await TeachersParser.extract(
      await TeachersParser.download(
        config.websiteUsername,
        config.websitePassword,
      ),
    );
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_teachers (date_time, data) VALUES (\'${teachers.date.toIso8601String()}\', \'${json.encode(teachers.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(teachers.toJSON())}\';');
  }
}
