import 'dart:async';
import 'dart:convert';

import 'package:app/utils/static.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform/flutter_platform.dart';
import 'package:http/http.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

// ignore: avoid_classes_with_only_static_members
/// Data class
/// responsible for loading all the data from the server
class Data {
  static String _protocol = 'https';
  static String _host;
  static int _port = 80;

  // ignore: public_member_api_docs
  static bool online = false;

  // ignore: public_member_api_docs
  static UnitPlanForGrade unitPlan;

  // ignore: public_member_api_docs
  static Calendar calendar;

  // ignore: public_member_api_docs
  static Cafetoria cafetoria;

  // ignore: public_member_api_docs
  static ReplacementPlanForGrade replacementPlan;

  static User _user;

  // ignore: public_member_api_docs
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  // ignore: public_member_api_docs, avoid_setters_without_getters
  static set user(User user) {
    _user = user;
    Static.storage.setJSON(Keys.user, user.toJSON());
  }

  // ignore: public_member_api_docs, avoid_setters_without_getters
  static User get user => _user;

  // ignore: public_member_api_docs
  static String get locale => _user.language;

  // ignore: public_member_api_docs
  static String getSelection(String key) => _user.getSelection(key);

  // ignore: public_member_api_docs
  static void setSelection(String key, String value) {
    _user.setSelection(key, value);
    _updateUser();
  }

  /// Setup the config of the server
  static void setup([int port, String host, String protocol]) {
    _protocol = protocol;
    _host = host;
    _port = port;
  }

  /// Check if the server config is valid
  static bool checkSetup() {
    if (_protocol != 'https' && _protocol != 'http') {
      throw Exception('Wrong protocol: $_protocol');
    }
    if (_host == null || _host.isEmpty) {
      throw Exception('Wrong host: $_host');
    }
    if (_port == null || _port < 0 || _port > 65535) {
      throw Exception('Wrong port: ${_port ?? 'null'}');
    }
    return true;
  }

  /// Return the base url of the server
  // ignore: missing_return
  static String get baseUrl {
    if (checkSetup()) {
      return '$_protocol://$_host:$_port';
    }
    return null;
  }

  static Future _updateUser() async {
    print('Updating user');
    Static.storage.setJSON(Keys.user, _user.toJSON());
    final parameters = {
      Keys.user: json.encode(_user?.toEncryptedJSON()),
    };
    print(parameters);
    try {
      await Client()
          .get(
              '$baseUrl/?${parameters.keys.map((name) => '$name=${parameters[name]}').join('&')}')
          .timeout(Duration(seconds: 3));
      // ignore: empty_catches
    } on Exception {}
  }

  /// Load all the data from the server
  static Future<ErrorCode> load(BuildContext context) async {
    if (Static.storage.has(Keys.unitPlan)) {
      unitPlan =
          UnitPlanForGrade.fromJSON(Static.storage.getJSON(Keys.unitPlan));
    }
    if (Static.storage.has(Keys.calendar)) {
      calendar = Calendar.fromJSON(Static.storage.getJSON(Keys.calendar));
    }
    if (Static.storage.has(Keys.cafetoria)) {
      cafetoria = Cafetoria.fromJSON(Static.storage.getJSON(Keys.cafetoria));
    }
    if (Static.storage.has(Keys.replacementPlan)) {
      replacementPlan = ReplacementPlanForGrade.fromJSON(
          Static.storage.getJSON(Keys.replacementPlan));
    }
    if (Static.storage.has(Keys.user)) {
      _user = User.fromJSON(Static.storage.getJSON(Keys.user));
      if (Platform().isAndroid) {
        _user.tokens = (_user.tokens..add(await firebaseMessaging.getToken()))
            .toSet()
            .toList();
      }
    }
    final parameters = {
      Keys.unitPlan: unitPlan == null ? 0 : unitPlan.timeStamp,
      Keys.calendar: calendar == null ? 0 : calendar.timeStamp,
      Keys.cafetoria: cafetoria == null ? 0 : cafetoria.timeStamp,
      Keys.replacementPlan:
          replacementPlan == null ? 0 : replacementPlan.timeStamp,
      Keys.user: json.encode(_user?.toEncryptedJSON()),
    };

    try {
      final response = await Client()
          .get(
              '$baseUrl/?${parameters.keys.map((name) => '$name=${parameters[name]}').join('&')}')
          .timeout(Duration(seconds: 3));
      if (response.statusCode != 200) {
        print(response.statusCode);
        return ErrorCode.wrongCredentials;
      }
      final data = json.decode(response.body);
      for (final key in data.keys.where((key) => key != 'status')) {
        print('$key updated');
      }
      if (data[Keys.unitPlan] != null) {
        unitPlan = UnitPlanForGrade.fromJSON(data[Keys.unitPlan]);
        Static.storage.setJSON(Keys.unitPlan, data[Keys.unitPlan]);
      }
      if (data[Keys.calendar] != null) {
        calendar = Calendar.fromJSON(data[Keys.calendar]);
        Static.storage.setJSON(Keys.calendar, data[Keys.calendar]);
      }
      if (data[Keys.cafetoria] != null) {
        cafetoria = Cafetoria.fromJSON(data[Keys.cafetoria]);
        Static.storage.setJSON(Keys.cafetoria, data[Keys.cafetoria]);
      }
      if (data[Keys.replacementPlan] != null) {
        replacementPlan =
            ReplacementPlanForGrade.fromJSON(data[Keys.replacementPlan]);
        Static.storage
            .setJSON(Keys.replacementPlan, data[Keys.replacementPlan]);
      }
      if (data[Keys.user] != null) {
        user = User.fromJSON(data[Keys.user]);
        Static.storage.setJSON(Keys.user, data[Keys.user]);
      }

      var updatedSelection = false;
      if (unitPlan != null) {
        for (final day in unitPlan.days) {
          for (final lesson in day.lessons) {
            if (lesson.subjects.length == 1 &&
                _user.getSelection(Keys.selection(lesson.block, true)) ==
                    null &&
                _user.getSelection(Keys.selection(lesson.block, false)) ==
                    null) {
              _user
                ..setSelection(Keys.selection(lesson.block, true),
                    lesson.subjects[0].identifier)
                ..setSelection(Keys.selection(lesson.block, false),
                    lesson.subjects[0].identifier);
              updatedSelection = true;
            }
          }
        }
      }
      if (updatedSelection) {
        // ignore: unawaited_futures
        _updateUser();
      }
      if (AppTranslations.of(context).locale.languageCode != _user.language) {
        _user.language = AppTranslations.of(context).locale.languageCode;
        // ignore: unawaited_futures
        _updateUser();
      }
      online = true;
      return ErrorCode.none;
    } on Exception catch (e) {
      print(e);
      if (user == null) {
        return ErrorCode.wrongCredentials;
      }
      return ErrorCode.offline;
    }
  }
}

/// ErrorCode enum
/// error codes for communicating data state internally
enum ErrorCode {
  // ignore: public_member_api_docs
  none,
  // ignore: public_member_api_docs
  offline,
  // ignore: public_member_api_docs
  wrongCredentials,
}
