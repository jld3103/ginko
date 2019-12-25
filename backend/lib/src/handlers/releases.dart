import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// ReleasesHandler class
class ReleasesHandler extends Handler {
  // ignore: public_member_api_docs
  ReleasesHandler(MySqlConnection mySqlConnection)
      : super('releases', mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_releases ORDER BY date_time DESC LIMIT 1;');
    final release =
        Release.fromJSON(json.decode(results.toList()[0][0].toString()));
    return Tuple2(release.toJSON(), release.version);
  }

  @override
  Future update() async {
    final releases = ReleasesParser.extract(
      json.decode(await ReleasesParser.download(Config.githubToken)),
    );
    final dataString = json.encode(releases.toJSON());
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_releases (date_time, data) VALUES (\'${releases.published.toString().substring(0, releases.published.toString().length - 1)}\', \'$dataString\') ON DUPLICATE KEY UPDATE data = \'$dataString\';');
  }
}
