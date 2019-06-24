import 'dart:async';
import 'dart:convert';

import 'package:app/utils/storage/storage_holder.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:models/models.dart';

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

  /// Load all the data from the server
  static Future<int> load() async {
    if (StorageHolder.storage.getString(Keys.unitPlan) != null) {
      unitPlan = UnitPlanForGrade.fromJSON(
          json.decode(StorageHolder.storage.getString(Keys.unitPlan)));
    }
    if (StorageHolder.storage.getString(Keys.calendar) != null) {
      calendar = Calendar.fromJSON(
          json.decode(StorageHolder.storage.getString(Keys.calendar)));
    }
    final parameters = {
      Keys.username: sha256
          .convert(
          utf8.encode(StorageHolder.storage.getString(Keys.username) ?? ''))
          .toString(),
      Keys.password: sha256
          .convert(
          utf8.encode(StorageHolder.storage.getString(Keys.password) ?? ''))
          .toString(),
      Keys.grade: StorageHolder.storage.getString(Keys.grade) ?? '',
      Keys.unitPlan:
          unitPlan == null ? 0 : unitPlan.date.millisecondsSinceEpoch / 1000,
      Keys.calendar:
          calendar == null ? 0 : calendar.years.reduce((a, b) => a * 10000 + b),
    };

    try {
      final response = await Client().get(
          '$baseUrl/?${parameters.keys.map((name) => '$name=${parameters[name]}').join('&')}');
      if (response.statusCode != 200) {
        print(response.statusCode);
        return 2;
      }
      final data = json.decode(response.body);
      if (data[Keys.unitPlan] != null) {
        unitPlan = UnitPlanForGrade.fromJSON(data[Keys.unitPlan]);
        StorageHolder.storage
            .setString(Keys.unitPlan, json.encode(data[Keys.unitPlan]));
      }
      if (data[Keys.calendar] != null) {
        calendar = Calendar.fromJSON(data[Keys.calendar]);
        StorageHolder.storage
            .setString(Keys.calendar, json.encode(data[Keys.calendar]));
      }
      online = true;
      return 0;
    } on Exception catch (e) {
      print(e);
      return 1;
    }
  }
}
