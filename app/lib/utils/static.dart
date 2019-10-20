import 'package:ginko/plugins/storage/storage.dart';

// ignore: avoid_classes_with_only_static_members
/// Static class
/// handles all app wide static objects
class Static {
  // ignore: public_member_api_docs
  static Storage storage;

  // ignore: public_member_api_docs
  static VoidCallback rebuildUnitPlan;

  // ignore: public_member_api_docs
  static VoidCallback rebuildReplacementPlan;
}

typedef VoidCallback = void Function();
