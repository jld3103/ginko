import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

/// AppSettings class
/// handles all app settings
class AppSettings {
  /// Get the settings for a key
  static bool get(String key, [bool defaultValue]) =>
      Static.settings.data.getSettings(Keys.settingsKey(key), defaultValue);

  /// Set the settings for a key
  static void set(String key, bool value) =>
      Static.settings.data.setSettings(Keys.settingsKey(key), value);
}
