import 'package:app/utils/platform/platform_base.dart';

/// Platform class
/// handles platform on web devices
class Platform extends PlatformBase {
  // ignore: public_member_api_docs
  Platform() : super(isWeb: true);
}
