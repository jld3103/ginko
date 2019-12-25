import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// TimetableHandler class
class TimetableHandler extends Handler {
  // ignore: public_member_api_docs
  TimetableHandler(MySqlConnection mySqlConnection)
      : super(Keys.timetable, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_timetable ORDER BY date_time DESC LIMIT 2;');
    final timetable =
        Timetable.fromJSON(json.decode(results.toList()[0][0].toString()))
            .timetables
            .where((timetable) => timetable.grade == user.grade)
            .single;
    return Tuple2(timetable.toJSON(), timetable.date.toIso8601String());
  }

  /// Update the data from the file into the database
  @override
  Future update() async {
    final timetable = TimetableParser.extract(await loadUNSTFFile());
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_timetable (date_time, data) VALUES (\'${timetable.timetables[0].date.toIso8601String()}\', \'${json.encode(timetable.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(timetable.toJSON())}\';');
  }
}
