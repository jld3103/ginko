import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

// ignore: avoid_classes_with_only_static_members
/// Config class
class Config {
  static final Logger _log = Logger('Config');

  static int _port;
  static String _websiteUsername;
  static String _websitePassword;
  static String _dbHost;
  static int _dbPort;
  static String _dbUsername;
  static String _dbPassword;
  static String _dbName;
  static String _cafetoriaUsername;
  static String _cafetoriaPassword;
  static String _fcmServerKey;
  static String _ghToken;

  /// Whether to fetch all data on start
  static bool fetchOnStart = true;

  /// Whether to log all requests made to the server
  static bool verbose = false;

  /// The port of the web server
  static int get port => _port;

  /// The username of the website
  static String get websiteUsername => _websiteUsername;

  /// The password of the website
  static String get websitePassword => _websitePassword;

  /// The host of the database
  static String get dbHost => _dbHost;

  /// The port of the database
  static int get dbPort => _dbPort;

  /// The username of the database user
  static String get dbUsername => _dbUsername;

  /// The password of the database user
  static String get dbPassword => _dbPassword;

  /// The name of the database
  static String get dbName => _dbName;

  /// The username of the cafetoria service user
  static String get cafetoriaUsername => _cafetoriaUsername;

  /// The password of the cafetoria service user
  static String get cafetoriaPassword => _cafetoriaPassword;

  /// The fcm server key
  static String get fcmServerKey => _fcmServerKey;

  /// The Github token to access the API
  static String get githubToken => _ghToken;

  /// Loads the config from file if it exists else from environment variables
  static void load() {
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
    _fcmServerKey = _readString(data, 'fcm_server_key');
    _ghToken = _readString(data, 'gh_token');
  }

  static dynamic _readValue(Map<String, dynamic> data, String key) {
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

  static String _readString(Map<String, dynamic> data, String key) =>
      _readValue(data, key);

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = _readValue(data, key);
    try {
      return value;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return int.parse(value);
    }
  }
}
