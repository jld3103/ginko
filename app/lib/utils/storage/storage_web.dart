library storage;
// ignore_for_file: uri_does_not_exist

import 'dart:convert';
import 'dart:html';

import 'package:app/utils/storage/storage_base.dart';

// ignore: undefined_identifier
final _localStorage = window.localStorage;

/// Storage class
/// handles storage on web devices
class Storage extends StorageBase {
  @override
  // ignore: missing_return
  Future init() {}

  @override
  int getInt(String key) =>
      _localStorage.containsKey(key) ? int.tryParse(_localStorage[key]) : null;

  @override
  void setInt(String key, int value) => _localStorage[key] = '$value';

  @override
  String getString(String key) =>
      _localStorage.containsKey(key) ? _localStorage[key] : null;

  @override
  void setString(String key, String value) => _localStorage[key] = '$value';

  @override
  bool getBool(String key) =>
      _localStorage.containsKey(key) ? _localStorage[key] == 'true' : null;

  @override
  void setBool(String key, bool value) => _localStorage[key] = '$value';

  @override
  Map<String, dynamic> getJSON(String key) => json.decode(getString(key));

  @override
  void setJSON(String key, Map<String, dynamic> value) =>
      setString(key, json.encode(value));

  @override
  bool has(String key) => _localStorage[key] != null;
}
