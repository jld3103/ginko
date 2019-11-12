import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// SettingsLoader class
class SettingsLoader extends Loader {
  // ignore: public_member_api_docs
  SettingsLoader() : super(Keys.settings);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Settings.fromJSON(json);

  @override
  Settings get data => object;

  @override
  // ignore: type_annotate_public_apis
  List get body => data?.toJSON();

  @override
  bool get post => true;

  @override
  List<dynamic> toJSON() => data.toJSON();
}
