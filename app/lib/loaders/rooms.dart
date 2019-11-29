import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// RoomsLoader class
class RoomsLoader extends Loader {
  // ignore: public_member_api_docs
  RoomsLoader() : super(Keys.rooms);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Rooms.fromJSON(json);

  @override
  Rooms get data => object;
}
