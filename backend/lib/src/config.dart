import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

/// Config class
class Config {
  // ignore: public_member_api_docs
  Config() : _log = Logger('Config');

  final Logger _log;

  int _port;
  String _websiteUsername;
  String _websitePassword;
  String _dbHost;
  int _dbPort;
  String _dbUsername;
  String _dbPassword;
  String _dbName;
  String _cafetoriaUsername;
  String _cafetoriaPassword;

  /// Whether to fetch all data on start
  bool fetchOnStart = true;

  /// Whether to log all requests made to the server
  bool verbose = false;

  /// The port of the web server
  int get port => _port;

  /// The username of the website
  String get websiteUsername => _websiteUsername;

  /// The password of the website
  String get websitePassword => _websitePassword;

  /// The host of the database
  String get dbHost => _dbHost;

  /// The port of the database
  int get dbPort => _dbPort;

  /// The username of the database user
  String get dbUsername => _dbUsername;

  /// The password of the database user
  String get dbPassword => _dbPassword;

  /// The name of the database
  String get dbName => _dbName;

  /// The username of the cafetoria service user
  String get cafetoriaUsername => _cafetoriaUsername;

  /// The password of the cafetoria service user
  String get cafetoriaPassword => _cafetoriaPassword;

  /// Loads the config from file if it exists else from environment variables
  void load() {
    final file = File('config.json');
    var data = {};
    if (!file.existsSync()) {
      _log.warning(
          // ignore: lines_longer_than_80_chars
          'Did you forget to create config.json? Using environment variables instead.');
      data = Platform.environment;
    } else {
      data = json.decode(file.readAsStringSync());
    }
    _port = _readInt(data, 'port');
    _websiteUsername = _readString(data, 'website_username');
    _websitePassword = _readString(data, 'website_password');
    _dbHost = _readString(data, 'db_host');
    _dbPort = _readInt(data, 'db_port');
    _dbUsername = _readString(data, 'db_username');
    _dbPassword = _readString(data, 'db_password');
    _dbName = _readString(data, 'db_name');
    _cafetoriaUsername = _readString(data, 'cafetoria_username');
    _cafetoriaPassword = _readString(data, 'cafetoria_password');
  }

  dynamic _readValue(Map<String, dynamic> data, String key) {
    if (key != key.toLowerCase()) {
      _log.warning('Please provide the key in lower case: $key.');
      exit(1);
    }
    if (data[key] != null) {
      return data[key];
    }
    if (data[key.toUpperCase()] != null) {
      return data[key.toUpperCase()];
    }
    _log.warning('Key $key not found in config.');
    exit(1);
  }

  String _readString(Map<String, dynamic> data, String key) =>
      _readValue(data, key);

  int _readInt(Map<String, dynamic> data, String key) {
    final value = _readValue(data, key);
    try {
      return value;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return int.parse(value);
    }
  }
}
