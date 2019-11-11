import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// SelectionLoader class
class SelectionLoader extends Loader {
  // ignore: public_member_api_docs
  SelectionLoader() : super(Keys.selection);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Selection.fromJSON(json);

  @override
  Selection get data => object;

  @override
  // ignore: type_annotate_public_apis
  List get body => data?.toJSON();

  @override
  bool get post => true;

  @override
  List<dynamic> toJSON() => data.toJSON();
}
