import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// CafetoriaLoader class
class CafetoriaLoader extends Loader {
  // ignore: public_member_api_docs
  CafetoriaLoader() : super(Keys.cafetoria);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Cafetoria.fromJSON(json);

  @override
  Cafetoria get data => object;
}
