/// Settings class
class Settings {
  // ignore: public_member_api_docs
  Settings(this.settings);

  // ignore: public_member_api_docs
  factory Settings.fromJSON(json) => Settings(json
      .map((value) => SettingsValue.fromJSON(value))
      .toList()
      .cast<SettingsValue>()
      .toList());

  // ignore: public_member_api_docs
  List<dynamic> toJSON() => settings.map((value) => value.toJSON()).toList();

  // ignore: public_member_api_docs
  final List<SettingsValue> settings;

  /// Get the value of a settings key
  bool getSettings(String key, [bool defaultValue]) {
    final values = settings.where((i) => i.key == key).toList();
    if (values.length != 1) {
      return defaultValue;
    }
    return values[0].value;
  }

  /// Set the value of a settings key
  void setSettings(String key, bool value) {
    final values = settings.where((i) => i.key == key).toList();
    if (values.isEmpty) {
      settings.add(SettingsValue(key, value));
    } else {
      values[0].value = value;
    }
  }
}

/// SettingsValue class
/// describes a value of the user config
class SettingsValue {
  // ignore: public_member_api_docs
  SettingsValue(this.key, bool value, [DateTime modified]) {
    _value = value;
    _modified = modified ?? DateTime.now();
  }

  // ignore: public_member_api_docs
  factory SettingsValue.fromJSON(Map<String, dynamic> json) => SettingsValue(
        json['key'],
        json['value'],
        json['modified'] == null
            ? DateTime.now()
            : DateTime.parse(json['modified']),
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'key': key,
        'value': value,
        'modified': _modified.toIso8601String(),
      };

  // ignore: public_member_api_docs, type_annotate_public_apis
  set value(value) {
    _value = value;
    _modified = DateTime.now();
  }

  // ignore: public_member_api_docs
  bool get value => _value;

  // ignore: public_member_api_docs
  DateTime get modified => _modified;

  // ignore: public_member_api_docs
  final String key;
  bool _value;
  DateTime _modified;
}
