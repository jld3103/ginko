import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// SubjectsLoader class
class SubjectsLoader extends Loader {
  // ignore: public_member_api_docs
  SubjectsLoader() : super(Keys.subjects);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Subjects.fromJSON(json);

  @override
  Subjects get data => object;
}
