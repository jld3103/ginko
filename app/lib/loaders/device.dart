import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// DeviceLoader class
class DeviceLoader extends Loader {
  // ignore: public_member_api_docs
  DeviceLoader() : super(Keys.device);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => data;

  @override
  Device get data => object;

  @override
  // ignore: type_annotate_public_apis
  Map<String, dynamic> get body => data?.toJSON();

  @override
  bool get post => true;
}
