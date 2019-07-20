import 'package:models/models.dart';
import 'package:server/data/replacementplan.dart';
import 'package:server/extra/unitplan.dart';
import 'package:server/parsers/unitplan.dart';

// ignore: avoid_classes_with_only_static_members
/// UnitPlanData class
/// handles all unit plan storing
class UnitPlanData {
  // ignore: public_member_api_docs
  static UnitPlan unitPlan;

  /// Complete all changes using the unit plan
  static void complete() {
    unitPlan.unitPlans = unitPlan.unitPlans.map((plan) {
      plan.days = plan.days.map((day) {
        day.lessons = day.lessons.map((lesson) {
          lesson.subjects = lesson.subjects.map((subject) {
            subject
                .getMatchingChanges(
                    ReplacementPlanData.replacementPlan
                        .replacementPlans[grades.indexOf(plan.grade)],
                    UnitPlanData.unitPlan.unitPlans[grades.indexOf(plan.grade)])
                .forEach(subject.complete);
            return subject;
          }).toList();
          return lesson;
        }).toList();
        return day;
      }).toList();
      return plan;
    }).toList();
  }

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
    unitPlan = UnitPlanExtra.mergeUnitPlans(plans.cast<UnitPlan>());
  }
}
