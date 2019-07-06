import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/parsers/unitplan.dart';
import 'package:server/path.dart';
import 'package:test/test.dart';

void main() {
  group('Unit plan parser', () {
    test('Can parse HTML data correctly', () {
      final plans = [
        UnitPlan(
          unitPlans: UnitPlanParser.extract(Document.html(File(
                  '${Path.getBasePath}tests/files/server/parsers/unitplan_left.html')
              .readAsStringSync())),
        ),
        UnitPlan(
          unitPlans: UnitPlanParser.extract(Document.html(File(
                  '${Path.getBasePath}tests/files/server/parsers/unitplan_right.html')
              .readAsStringSync())),
        ),
      ];

      expect(
        UnitPlanParser.mergeUnitPlans(plans.cast<UnitPlan>()).toJSON(),
        UnitPlan.fromJSON(json.decode(File(
                    '${Path.getBasePath}tests/files/server/parsers/unitplan.json')
                .readAsStringSync()))
            .toJSON(),
      );
    });

    test('Can download without error', () async {
      Config.load(true);
      expect(await UnitPlanParser.download(true) is Document, true);
      expect(await UnitPlanParser.download(false) is Document, true);
    });
  });
}
