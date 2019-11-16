import 'dart:convert';
import 'dart:io';

import 'package:backend/backend.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Notification class
/// create notifications and send them to users
class Notification {
  // ignore: public_member_api_docs
  Notification(
    this.title,
    this.body,
    this.bigBody, {
    this.data,
  });

  // ignore: public_member_api_docs
  factory Notification.fromJSON(json) => Notification(
        json['title'],
        json['body'],
        json['bigbody'],
        data: json['data'],
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'title': title,
        'body': body,
        'bigbody': bigBody,
        'data': data,
      };

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
