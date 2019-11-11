import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// UserLoader class
class UserLoader extends Loader {
  // ignore: public_member_api_docs
  UserLoader() : super(Keys.user);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => User.fromJSON(json);

  @override
  User get data => object;
}
