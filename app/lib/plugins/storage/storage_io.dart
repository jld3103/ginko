library storage;

import 'dart:convert';

import 'package:ginko/plugins/storage/storage_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage class
/// handles storage on mobile and desktop devices
class Storage extends StorageBase {
  static SharedPreferences _sharedPreferences;

  @override
  Future init() async =>
      _sharedPreferences = await SharedPreferences.getInstance();

  @override
  int getInt(String key, {int defaultValue}) => _sharedPreferences.getInt(key);

  @override
  void setInt(String key, int value) => _sharedPreferences.setInt(key, value);

  @override
  String getString(String key) => _sharedPreferences.getString(key);

  @override
  void setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  bool getBool(String key) => _sharedPreferences.getBool(key);

  @override
  void setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  @override
  dynamic getJSON(String key) => json.decode(getString(key));

  @override
  // ignore: type_annotate_public_apis
  void setJSON(String key, value) => setString(key, json.encode(value));

  @override
  bool has(String key) => _sharedPreferences.containsKey(key);
}
