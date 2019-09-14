import 'dart:async';
import 'dart:convert';

import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/parsers/aixformation.dart';

// ignore: avoid_classes_with_only_static_members
/// AiXformationData class
/// handles all cafetoria storing
class AiXformationData {
  // ignore: public_member_api_docs
  static Posts posts;

  /// Load cafetoria
  static Future load() async {
    posts = await AiXformationParser.extract(
        json.decode(await AiXformationParser.download()));
  }
}

Future main(List<String> arguments) async {
  await setupDateFormats();
  Config.load();
  Config.dev = true;
  await AiXformationData.load();
}
