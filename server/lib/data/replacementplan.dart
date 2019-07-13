import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/extra/replacementplan.dart';
import 'package:server/parsers/replacementplan.dart';

// ignore: avoid_classes_with_only_static_members
/// ReplacementPlanData class
/// handles all replacement plan storing
class ReplacementPlanData {
  // ignore: public_member_api_docs
  static ReplacementPlan replacementPlan;

  /// Load all replacement plans
  static Future load() async {
    final plans = [];
    for (var i = 0; i < 2; i++) {
      final dayOne = i == 0;
      plans.add(
        ReplacementPlan(
          replacementPlans: ReplacementPlanParser.extract(
            await ReplacementPlanParser.download(dayOne),
          ),
        ),
      );
    }
    replacementPlan = ReplacementPlanExtra.mergeReplacementPlans(
        plans.cast<ReplacementPlan>());
  }
}

Future main(List<String> arguments) async {
  await setupDateFormats();
  if (arguments.isNotEmpty) {
    var files = [];
    for (final arg in arguments) {
      if (FileSystemEntity.isDirectorySync(arg)) {
        files = files
          ..addAll(Directory(arg)
              .listSync(recursive: true)
              .map((entity) => entity.path)
              .toList());
      } else {
        files.add(arg);
      }
    }
    for (final file in files
        .where((file) => file.split('.').reversed.toList()[0] == 'html')
        .where((file) => File(file).existsSync())
        .toList()) {
      //print(file);
      ReplacementPlanParser.extract(parse(File(file).readAsStringSync()));
    }
  } else {
    Config.load();
    await ReplacementPlanData.load();
  }
}
