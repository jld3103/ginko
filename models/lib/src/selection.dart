/// Selection class
class Selection {
  // ignore: public_member_api_docs
  Selection(this.selection);

  // ignore: public_member_api_docs
  factory Selection.fromJSON(json) => Selection(json
      .map((value) => SelectionValue.fromJSON(value))
      .toList()
      .cast<SelectionValue>()
      .toList());

  // ignore: public_member_api_docs
  List<dynamic> toJSON() => selection.map((value) => value.toJSON()).toList();

  // ignore: public_member_api_docs
  final List<SelectionValue> selection;

  /// Get the value of a selection key
  String getSelection(String key) {
    final parts = key.split('-');
    if (parts.length > 3 && parts[3] == '5') {
      return 'null-MIT';
    }
    final values = selection.where((i) => i.key == key).toList();
    if (values.length != 1) {
      return null;
    }
    return values[0].value;
  }

  /// Set the value of a selection key
  void setSelection(String key, String value) {
    final values = selection.where((i) => i.key == key).toList();
    if (values.isEmpty) {
      selection.add(SelectionValue(key, value));
    } else {
      values[0].value = value;
    }
  }
}

/// SelectionValue class
/// describes a value of the user config
class SelectionValue {
  // ignore: public_member_api_docs
  SelectionValue(this.key, value, [DateTime modified]) {
    _value = value;
    _modified = modified ?? DateTime.now();
  }

  // ignore: public_member_api_docs
  factory SelectionValue.fromJSON(Map<String, dynamic> json) => SelectionValue(
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
  dynamic get value => _value;

  // ignore: public_member_api_docs
  DateTime get modified => _modified;

  // ignore: public_member_api_docs
  final String key;
  dynamic _value;
  DateTime _modified;
}
