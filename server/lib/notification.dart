import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:server/config.dart';

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
  final String title;

  // ignore: public_member_api_docs
  String body;

  // ignore: public_member_api_docs
  final String bigBody;

  // ignore: public_member_api_docs
  Map<String, dynamic> data;

  /// Send the notification to a token
  Future<bool> send(String token) async {
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
    if (response['results']
        .where((a) => a['error'] != null)
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }
}

/// Notifications class
/// notification utilities
class Notifications {
  /// Check if a token is still registered
  static Future<bool> checkToken(String token) async {
    final data = {
      'registration_ids': [token],
      'dry_run': true,
    };
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
    if (response['results']
        .where((a) => a['error'] != null)
        .toList()
        .isNotEmpty) {
      return false;
    }
    return true;
  }
}
