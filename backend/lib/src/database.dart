import 'package:mysql1/mysql1.dart';

/// Database class
class Database {
  /// Create all default tables
  static Future createDefaultTables(MySqlConnection mySqlConnection) async {
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_password (username VARCHAR(7) NOT NULL, password TEXT NOT NULL, UNIQUE KEY unique_username (username)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_grade (username VARCHAR(7) NOT NULL, grade TEXT NOT NULL, UNIQUE KEY unique_username (username)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_full_name (username VARCHAR(7) NOT NULL, full_name TEXT NOT NULL, UNIQUE KEY unique_username (username)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_devices (username VARCHAR(7) NOT NULL, token VARCHAR(255) NOT NULL, language TEXT NOT NULL, os TEXT NOT NULL, UNIQUE KEY unique_username (username, token)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_selection (username VARCHAR(7) NOT NULL, selection_key VARCHAR(255) NOT NULL, selection_value TEXT NOT NULL, date_time DATETIME NOT NULL, UNIQUE KEY unique_username (username, selection_key)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS users_settings (username VARCHAR(7) NOT NULL, settings_key VARCHAR(255) NOT NULL, settings_value BOOLEAN NOT NULL, date_time DATETIME NOT NULL, UNIQUE KEY unique_username (username, settings_key)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_substitution_plan (date_time DATE NOT NULL, update_time DATETIME NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time, update_time)) ENGINE = InnoDB;');
    await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'CREATE TABLE IF NOT EXISTS data_timetable (date_time DATE NOT NULL, week_a BOOLEAN NOT NULL, data LONGTEXT NOT NULL, UNIQUE KEY unique_date_time (date_time, week_a)) ENGINE = InnoDB;');
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
  }
}
