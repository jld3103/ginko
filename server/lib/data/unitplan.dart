import 'package:models/models.dart';
import 'package:models/unitplan.dart';
import 'package:server/parsers/unitplan.dart';

// ignore: avoid_classes_with_only_static_members
/// UnitPlanData class
/// handles all unit plan storing
class UnitPlanData extends UnitPlanParser {
  // ignore: public_member_api_docs
  static UnitPlan unitPlan;

  /// Load all unit plans
  static Future load() async {
    final plans = [];
    for (var i = 0; i < 2; i++) {
      final weekA = i == 0;
      plans.add(
        UnitPlan(
          unitPlans: UnitPlanParser.extract(
            await UnitPlanParser.download(weekA),
          ),
        ),
      );
    }
    unitPlan = UnitPlanParser.mergeUnitPlans(plans.cast<UnitPlan>());
  }
}
