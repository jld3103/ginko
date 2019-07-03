library flutter_platform_storage;

// ignore: uri_does_not_exist
import 'dart:html';

import 'package:flutter_platform_storage/flutter_platform_storage_base.dart';

/// Storage class
/// handles storage on web devices
class Storage extends StorageBase {
  @override
  // ignore: missing_return
  Future init() {}

  @override
  int getInt(String key) {
    if (window.localStorage.containsKey(key)) {
      return int.tryParse(window.localStorage[key]);
    }
    // ignore: avoid_returning_null
    return null;
  }

  @override
  void setInt(String key, int value) {
    window.localStorage[key] = '$value';
  }

  @override
  String getString(String key) {
    if (window.localStorage.containsKey(key)) {
      return window.localStorage[key];
    }
    return null;
  }

  @override
  void setString(String key, String value) {
    window.localStorage[key] = '$value';
  }

  @override
  bool getBool(String key) {
    if (window.localStorage.containsKey(key)) {
      return window.localStorage[key] == 'true';
    }
    // ignore: avoid_returning_null
    return null;
  }

  @override
  void setBool(String key, bool value) {
    window.localStorage[key] = '$value';
  }
}
