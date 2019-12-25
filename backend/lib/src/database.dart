import 'package:mysql1/mysql1.dart';

/// Database class
class Database {
  /// Create all default tables
  static Future createDefaultTables(MySqlConnection mySqlConnection) async {
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_password (username VARCHAR(8) NOT NULL, password TEXT NOT NULL, UNIQUE KEY unique_username (username)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_grade (username VARCHAR(8) NOT NULL, grade TEXT NOT NULL, UNIQUE KEY unique_username (username)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_devices (username VARCHAR(8) NOT NULL, token VARCHAR(255) NOT NULL, os TEXT NOT NULL, version TEXT NOT NULL, last_active DATETIME NOT NULL, UNIQUE KEY unique_username (username, token)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_selection (username VARCHAR(8) NOT NULL, selection_key VARCHAR(255) NOT NULL, selection_value TEXT NOT NULL, date_time DATETIME NOT NULL, UNIQUE KEY unique_username (username, selection_key)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_settings (username VARCHAR(8) NOT NULL, settings_key VARCHAR(255) NOT NULL, settings_value BOOLEAN NOT NULL, date_time DATETIME NOT NULL, UNIQUE KEY unique_username (username, settings_key)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_substitution_plan (date_time DATE NOT NULL, update_time DATETIME NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time, update_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_timetable (date_time DATE NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_calendar (date_time VARCHAR(8) NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_teachers (date_time DATE NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_aixformation (date_time DATETIME NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_aixformation_users (id INT NOT NULL, name TEXT NOT NULL, UNIQUE KEY unique_id (id)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_aixformation_tags (id INT NOT NULL, name TEXT NOT NULL, UNIQUE KEY unique_id (id)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_aixformation_media (id INT NOT NULL, thumbnail TEXT NOT NULL, medium TEXT NOT NULL, full TEXT NOT NULL, UNIQUE KEY unique_id (id)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_cafetoria (date_time DATE NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_releases (date_time DATETIME NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_subjects (date_time DATE NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_rooms (date_time DATE NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time)) ENGINE = InnoDB;');
  }
}
