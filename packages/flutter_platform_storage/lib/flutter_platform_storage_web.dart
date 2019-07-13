library flutter_platform_storage;

import 'dart:convert';
import 'dart:html';

import 'package:flutter_platform_storage/flutter_platform_storage_base.dart';

final localStorage = window.localStorage;

/// Storage class
/// handles storage on web devices
class Storage extends StorageBase {
  @override
  // ignore: missing_return
  Future init() {}

  @override
  int getInt(String key) {
    if (localStorage.containsKey(key)) {
      return int.tryParse(localStorage[key]);
    }
    // ignore: avoid_returning_null
    return null;
  }

  @override
  void setInt(String key, int value) {
    localStorage[key] = '$value';
  }

  @override
  String getString(String key) {
    if (localStorage.containsKey(key)) {
      return localStorage[key];
    }
    return null;
  }

  @override
  void setString(String key, String value) {
    localStorage[key] = '$value';
  }

  @override
  bool getBool(String key) {
    if (localStorage.containsKey(key)) {
      return localStorage[key] == 'true';
    }
    // ignore: avoid_returning_null
    return null;
  }

  @override
  void setBool(String key, bool value) {
    localStorage[key] = '$value';
  }

  @override
  Map<String, dynamic> getJSON(String key) {
    return json.decode(this.getString(key));
  }

  @override
  void setJSON(String key, Map<String, dynamic> value) {
    this.setString(key, json.encode(value));
  }

  @override
  bool has(String key) {
    return localStorage[key] != null;
  }
}
