import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:server/config.dart';

/// Notification class
/// create notifications and send them to users
class Notification {
  /// Create a simple notification
  static Future send(
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
    final dio = Dio();
    await dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: data,
      options: Options(
        contentType: ContentType.json,
        headers: {
          HttpHeaders.authorizationHeader: 'key=${Config.fcmServerKey}'
        },
      ),
    );
  }
}
