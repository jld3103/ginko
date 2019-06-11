import 'dart:convert';
import 'dart:io' show File, Platform;

import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members, avoid_classes_with_only_static_members
/// Storage class
/// handles all storage things
class Storage {
  static SharedPreferences _sharedPreferences;
  static File _file;
  static Map<String, dynamic> _data;

  /// Initialize the storage
  static Future init() async {
    if (_isDesktop) {
      _file = File('.data.json');
      if (!_file.existsSync()) {
        _file.writeAsStringSync('{}');
      }
      _data = json.decode(_file.readAsStringSync());
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  // ignore: public_member_api_docs
  static void setString(String key, String value) {
    if (_isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setString(key, value);
    }
    _save();
  }

  // ignore: public_member_api_docs
  static void setStringList(String key, List<String> value) {
    if (_isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setStringList(key, value);
    }
    _save();
  }

  // ignore: public_member_api_docs
  static void setBool(String key, bool value) {
    if (_isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setBool(key, value);
    }
    _save();
  }

  // ignore: public_member_api_docs
  static void setInt(String key, int value) {
    if (_isDesktop) {
      _data[key] = value;
    } else {
      _sharedPreferences.setInt(key, value);
    }
    _save();
  }

  // ignore: public_member_api_docs
  static String getString(String key) {
    if (_isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getString(key);
    }
  }

  // ignore: public_member_api_docs
  static List<dynamic> getStringList(String key) {
    if (_isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getStringList(key);
    }
  }

  // ignore: public_member_api_docs
  static bool getBool(String key) {
    if (_isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getBool(key);
    }
  }

  // ignore: public_member_api_docs
  static int getInt(String key) {
    if (_isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.getInt(key);
    }
  }

  // ignore: public_member_api_docs
  static dynamic get(String key) {
    if (_isDesktop) {
      return _data[key];
    } else {
      return _sharedPreferences.get(key);
    }
  }

  // ignore: public_member_api_docs
  static void remove(String key) {
    if (_isDesktop) {
      _data.remove(key);
    } else {
      _sharedPreferences.remove(key);
    }
    _save();
  }

  // ignore: public_member_api_docs
  static Set<String> getKeys() {
    if (_isDesktop) {
      return _data.keys.toSet();
    } else {
      return _sharedPreferences.getKeys();
    }
  }

  static void _save() {
    if (_isDesktop) {
      _file.writeAsStringSync(json.encode(_data));
    }
  }

  static bool get _isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
