import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:server/config.dart';

/// Notification class
/// create notifications and send them to users
class Notification {
  /// Create a simple notification
  static Future<bool> send(
    String token,
    String title,
    String body, {
    String bigBody,
    Map<String, dynamic> data,
  }) async {
    data ??= {};

    if (data.isNotEmpty) {
      data['data'] = json.decode(json.encode(data));
    }
    if (data['data'] == null) {
      data['data'] = {};
    }
    data['data']['title'] = title;
    data['data']['body'] = body;
    if (bigBody != null) {
      data['data']['bigBody'] = bigBody;
    }
    data['to'] = token;
    final response = json.decode((await Dio().post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
      options: Options(
        contentType: ContentType.json,
        headers: {
          HttpHeaders.authorizationHeader: 'key=${Config.fcmServerKey}'
        },
      ),
    ))
        .toString());
    if (response['results']
        .where((a) => a['error'] != null)
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }

  /// Check if a token is still registered
  static Future<bool> checkToken(String token) async {
    final data = {
      'registration_ids': [token],
      'dry_run': true,
    };
    final response = json.decode((await Dio().post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
      options: Options(
        contentType: ContentType.json,
        headers: {
          HttpHeaders.authorizationHeader: 'key=${Config.fcmServerKey}'
        },
      ),
    ))
        .toString());
    if (response['results']
        .where((a) => a['error'] != null)
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }
}
