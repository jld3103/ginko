import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// UpdatesLoader class
class UpdatesLoader extends Loader {
  // ignore: public_member_api_docs
  UpdatesLoader() : super(Keys.updates);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => json;

  @override
  Map<String, String> get data => object?.cast<String, String>();

  @override
  Map<String, dynamic> toJSON() => data;
}
