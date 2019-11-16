import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// AiXformationHandler class
class AiXformationHandler extends Handler {
  // ignore: public_member_api_docs
  AiXformationHandler(MySqlConnection mySqlConnection)
      : super(Keys.aiXformation, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_aixformation ORDER BY date_time DESC LIMIT 1;');
    final posts =
        AiXformation.fromJSON(json.decode(results.toList()[0][0].toString()));
    final unescapedAiXformation = AiXformation(
      date: posts.date,
      posts: posts.posts
          .map((post) => Post(
                id: post.id,
                date: post.date,
                title: post.title,
                content: post.content.replaceAll('\\"', '\"'),
                url: post.url,
                thumbnailUrl: post.thumbnailUrl,
                mediumUrl: post.mediumUrl,
                fullUrl: post.fullUrl,
                author: post.author,
                tags: post.tags,
              ))
          .toList(),
    );
    return Tuple2(unescapedAiXformation.toJSON(),
        unescapedAiXformation.date.toIso8601String());
  }

  @override
  Future update() async {
    var cache = {
      'users': {},
      'media': {},
      'tags': {},
    };
    final users = await mySqlConnection
        .query('SELECT id, name FROM data_aixformation_users;');
    for (final user in users.toList()) {
      cache['users'][user[0].toString()] = user[1].toString();
    }
    final media = await mySqlConnection.query(
        'SELECT id, thumbnail, medium, full FROM data_aixformation_media;');
    for (final medium in media.toList()) {
      cache['media'][medium[0].toString()] = {};
      cache['media'][medium[0].toString()]['thumbnail'] = medium[1].toString();
      cache['media'][medium[0].toString()]['medium'] = medium[2].toString();
      cache['media'][medium[0].toString()]['full'] = medium[3].toString();
    }
    final tags = await mySqlConnection
        .query('SELECT id, name FROM data_aixformation_tags;');
    for (final tag in tags.toList()) {
      cache['tags'][tag[0].toString()] = tag[1].toString();
    }
    final data = await AiXformationParser.extract(
      json.decode(await AiXformationParser.download()),
      cache: cache,
    );
    final posts = data.item1;
    final escapedAiXformation = AiXformation(
      date: posts.date,
      posts: posts.posts
          .map((post) => Post(
                id: post.id,
                date: post.date,
                title: post.title,
                content: post.content
                    .replaceAll('\"', '\\"')
                    .replaceAll('\n', '<br/>'),
                url: post.url,
                thumbnailUrl: post.thumbnailUrl,
                mediumUrl: post.mediumUrl,
                fullUrl: post.fullUrl,
                author: post.author,
                tags: post.tags,
              ))
          .toList(),
    );
    final dataString = json.encode(escapedAiXformation.toJSON());
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_aixformation WHERE date_time = \'${posts.date}\';');
    if (results.isNotEmpty) {
      final storedData = results.toList()[0][0].toString();
      if (storedData == dataString) {
        return;
      }
    }
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'INSERT INTO data_aixformation (date_time, data) VALUES (\'${posts.date}\', \'$dataString\') ON DUPLICATE KEY UPDATE data = \'$dataString\';');
    cache = data.item2.cast<String, Map<dynamic, dynamic>>();
    for (final id in cache['users'].keys) {
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_aixformation_users (id, name) VALUES (\'$id\', \'${cache['users'][id]}\') ON DUPLICATE KEY UPDATE name = \'${cache['users'][id]}\';');
    }
    for (final id in cache['media'].keys) {
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_aixformation_media (id, thumbnail, medium, full) VALUES (\'$id\', \'${cache['media'][id]['thumbnail']}\', \'${cache['media'][id]['medium']}\', \'${cache['media'][id]['full']}\') ON DUPLICATE KEY UPDATE thumbnail = \'${cache['media'][id]['thumbnail']}\', medium = \'${cache['media'][id]['medium']}\', full = \'${cache['media'][id]['full']}\';');
    }
    for (final id in cache['tags'].keys) {
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_aixformation_tags (id, name) VALUES (\'$id\', \'${cache['tags'][id]}\') ON DUPLICATE KEY UPDATE name = \'${cache['tags'][id]}\';');
    }
    final post = escapedAiXformation.posts
        .where((post) => post.date == escapedAiXformation.date)
        .single;
    final title = post.title;
    final body = '${post.content.substring(0, 500)}...';
    final bigBody = body;
    final notification = Notification(
      title,
      body,
      bigBody,
      data: {
        Keys.type: Keys.aiXformation,
      },
    );
    final tokens = [];
    final devicesResults = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT username, token FROM users_devices;');
    for (final row in devicesResults.toList()) {
      final username = row[0].toString();
      final token = row[1].toString();
      final settingsResults = await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT settings_value FROM users_settings WHERE username = \'$username\' AND settings_key = \'${Keys.settingsKey(Keys.aiXformationNotifications)}\';');
      bool showNotifications;
      if (settingsResults.isNotEmpty) {
        showNotifications = settingsResults.toList()[0][0] == 1;
      } else {
        showNotifications = true;
      }
      if (showNotifications) {
        tokens.add(token);
      }
    }
    await Notifications.sendNotification(notification, tokens.cast<String>());
  }
}
