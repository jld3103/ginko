import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// CalendarHandler class
class CalendarHandler extends Handler {
  // ignore: public_member_api_docs
  CalendarHandler(MySqlConnection mySqlConnection)
      : super(Keys.calendar, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        'SELECT data FROM data_calendar ORDER BY date_time DESC LIMIT 1;');
    final calendar =
        Calendar.fromJSON(json.decode(results.toList()[0][0].toString()));
    return Tuple2(calendar.toJSON(), calendar.timeStamp.toString());
  }

  @override
  Future update(Config config) async {
    final calendar = await CalendarParser.extract(
      await CalendarParser.download(
        config.websiteUsername,
        config.websitePassword,
      ),
    );
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_calendar (date_time, data) VALUES (\'${calendar.timeStamp}\', \'${json.encode(calendar.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(calendar.toJSON())}\';');
  }
}
