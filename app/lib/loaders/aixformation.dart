import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// AiXformationLoader class
class AiXformationLoader extends Loader {
  // ignore: public_member_api_docs
  AiXformationLoader() : super(Keys.aiXformation);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => AiXformation.fromJSON(json);

  @override
  AiXformation get data => object;
}
