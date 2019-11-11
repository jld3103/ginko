import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// CafetoriaHandler class
class CafetoriaHandler extends Handler {
  // ignore: public_member_api_docs
  CafetoriaHandler(MySqlConnection mySqlConnection)
      : super(Keys.cafetoria, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_cafetoria ORDER BY date_time DESC LIMIT 5;');
    final cafetoria = Cafetoria(
      saldo: null,
      days: results
          .toList()
          .map((row) => CafetoriaDay.fromJSON(json.decode(row[0].toString())))
          .cast<CafetoriaDay>()
          .toList(),
    );
    return Tuple2(cafetoria.toJSON(),
        cafetoria.days.map((day) => day.date.toIso8601String()).join(''));
  }

  @override
  Future update(Config config) async {
    final cafetoria = CafetoriaParser.extract(
        await CafetoriaParser.download(
            config.cafetoriaUsername, config.cafetoriaPassword),
        false);
    for (final day in cafetoria.days) {
      final dataString = json.encode(day.toJSON()).replaceAll('\\n', '');
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_cafetoria (date_time, data) VALUES (\'${day.date}\', \'$dataString\') ON DUPLICATE KEY UPDATE data = \'$dataString\';');
    }
  }
}
