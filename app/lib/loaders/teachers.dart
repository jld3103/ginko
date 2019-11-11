import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// TeachersLoader class
class TeachersLoader extends Loader {
  // ignore: public_member_api_docs
  TeachersLoader() : super(Keys.teachers);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Teachers.fromJSON(json);

  @override
  Teachers get data => object;
}
