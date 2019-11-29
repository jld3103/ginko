import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// RoomsHandler class
class RoomsHandler extends Handler {
  // ignore: public_member_api_docs
  RoomsHandler(
    MySqlConnection mySqlConnection,
    this.timetableHandler,
  ) : super(Keys.rooms, mySqlConnection);

  // ignore: public_member_api_docs
  final TimetableHandler timetableHandler;

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection
        .query('SELECT data FROM data_rooms ORDER BY date_time DESC LIMIT 1;');
    final rooms =
        Rooms.fromJSON(json.decode(results.toList()[0][0].toString()));
    return Tuple2(rooms.toJSON(), rooms.date.toIso8601String());
  }

  @override
  Future update() async {
    final timetables = [];
    for (final grade in grades) {
      final timetable =
          // ignore: missing_required_param_with_details
          TimetableForGrade.fromJSON((await timetableHandler.fetchLatest(User(
        grade: grade,
      )))
              .item1);
      timetables.add(timetable);
    }
    final rooms = RoomsParser.extract(timetables.cast<TimetableForGrade>());
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_rooms (date_time, data) VALUES (\'${rooms.date.toIso8601String()}\', \'${json.encode(rooms.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(rooms.toJSON())}\';');
  }
}
