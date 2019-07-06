import 'dart:async';

import 'package:models/models.dart';
import 'package:server/parsers/cafetoria.dart';

// ignore: avoid_classes_with_only_static_members
/// CafetoriaData class
/// handles all cafetoria storing
class CafetoriaData {
  // ignore: public_member_api_docs
  static Cafetoria cafetoria;

  /// Load cafetoria
  static Future load() async {
    cafetoria =
        CafetoriaParser.extract(await CafetoriaParser.download(), false);
  }
}
