library flutter_platform_storage;

import 'dart:convert';
import 'dart:io' hide Platform;

import 'package:flutter_platform/flutter_platform.dart';
import 'package:flutter_platform_storage/flutter_platform_storage_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage class
/// handles storage on mobile and desktop devices
class Storage extends StorageBase {
  static SharedPreferences _sharedPreferences;
  static File _file;
  static Map<String, dynamic> _data;
  static Platform _platform;

  @override
  Future init() async {
    _platform = Platform();
    if (_platform.isDesktop) {
      _file = File('.data.json');
      if (!_file.existsSync()) {
        _file.writeAsStringSync('{}');
      }
      _data = json.decode(_file.readAsStringSync());
    } else if (_platform.isMobile) {
      _sharedPreferences = await SharedPreferences.getInstance();
    } else {
      print(_platform.platformName);
    }
  }

  @override
  int getInt(String key, {int defaultValue}) {
    if (_platform.isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getInt(key);
    }
  }

  @override
  void setInt(String key, int value) {
    if (_platform.isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setInt(key, value);
    }
    _save();
  }

  static void _save() {
    if (_platform.isDesktop) {
      _file.writeAsStringSync(json.encode(_data));
    }
  }

  @override
  String getString(String key) {
    if (_platform.isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getString(key);
    }
  }

  @override
  void setString(String key, String value) {
    if (_platform.isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setString(key, value);
    }
    _save();
  }

  @override
  bool getBool(String key) {
    if (_platform.isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getBool(key);
    }
  }

  @override
  void setBool(String key, bool value) {
    if (_platform.isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setBool(key, value);
    }
    _save();
  }
}
