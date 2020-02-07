import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mysql1/mysql1.dart';

/// Notification class
/// create notifications and send them to users
class Notification {
  // ignore: public_member_api_docs
  Notification(
    this.key,
    this.title,
    this.body,
    this.bigBody, {
    this.data,
  });

  // ignore: public_member_api_docs
  factory Notification.fromJSON(json) => Notification(
        json['key'],
        json['title'],
        json['body'],
        json['bigbody'],
        data: json['data'],
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'key': key,
        'title': title,
        'body': body,
        'bigbody': bigBody,
        'data': data,
      };

  // ignore: public_member_api_docs
  final String key;

  // ignore: public_member_api_docs
  final String title;

  // ignore: public_member_api_docs
  String body;

  // ignore: public_member_api_docs
  final String bigBody;

  // ignore: public_member_api_docs
  Map<String, dynamic> data;
}

// ignore: avoid_classes_with_only_static_members
/// Notifications class
/// notification utilities
class Notifications {
  static final _log = Logger('Notifications');

  // ignore: public_member_api_docs
  static Future<List<bool>> checkNotificationCached(
    Notification notification,
    MySqlConnection mySqlConnection,
    List<String> tokens,
  ) async {
    final l = [];
    final newValue = sha256
        .convert(utf8.encode(
            '${notification.title}${notification.body}${notification.bigBody}'))
        .toString();
    for (final token in tokens) {
      final results = await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT notifications_value FROM users_notifications WHERE token = \'$token\' AND notifications_key = \'${notification.key}\';');
      var cached = true;
      if (results.isEmpty) {
        cached = false;
      } else {
        final String value = results.toList()[0][0];
        if (value != newValue) {
          cached = false;
        }
      }
      if (!cached) {
        await mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'INSERT INTO users_notifications (token, notifications_key, notifications_value) VALUES (\'$token\', \'${notification.key}\', \'$newValue\') ON DUPLICATE KEY UPDATE notifications_value = \'$newValue\';');
      }
      l.add(cached);
    }
    return l.cast<bool>();
  }

  /// Send a notification to a token
  static Future sendNotification(
      Notification notification, List<String> tokens) async {
    if (tokens.isEmpty) {
      return;
    }
    // ignore: omit_local_variable_types
    final Map<String, dynamic> data = {};
    data['data'] = notification.data ?? {};
    data['data']['title'] = notification.title;
    data['data']['body'] = notification.body;
    if (notification.bigBody != null) {
      data['data']['bigBody'] = notification.bigBody;
    }
    data['registration_ids'] = tokens;
    await _send(data);
  }

  /// Check if a token is still registered
  static Future<bool> isTokenStillRegistered(String token) async {
    final data = {
      'registration_ids': [token],
      'dry_run': true,
    };
    return _send(data);
  }

  static Future<bool> _send(Map<String, dynamic> data) async {
    final dio = Dio()
      ..options = BaseOptions(
        contentType: 'application/json',
      );
    final response = json.decode((await dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'key=${Config.fcmServerKey}'
        },
      ),
    ))
        .toString());
    _log.fine(response);
    if (response['results']
        .where((a) => a['error'] != null)
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }
}
