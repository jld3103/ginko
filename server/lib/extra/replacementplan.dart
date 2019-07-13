import 'package:models/models.dart';

class ReplacementPlanExtra {
  /// Merge all replacement plans for two days
  static ReplacementPlan mergeReplacementPlans(
      List<ReplacementPlan> replacementPlans) {
    if (replacementPlans[0].replacementPlans[0].timeStamp ==
        replacementPlans[1].replacementPlans[0].timeStamp) {
      if (replacementPlans[0]
          .replacementPlans[0]
          .replacementPlanDays[0]
          .updated
          .isAfter(replacementPlans[1]
              .replacementPlans[0]
              .replacementPlanDays[0]
              .updated)) {
        return replacementPlans[0];
      } else {
        return replacementPlans[1];
      }
    } else {
      return ReplacementPlan(
          replacementPlans: replacementPlans[0]
              .replacementPlans
              .map((replacementPlan) => replacementPlan.grade)
              .map((grade) => ReplacementPlanForGrade(
                    grade: grade,
                    replacementPlanDays: replacementPlans[0]
                        .replacementPlans[replacementPlans[0]
                            .replacementPlans
                            .map((replacementPlan) => replacementPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .replacementPlanDays
                      ..addAll(replacementPlans[1]
                          .replacementPlans[replacementPlans[1]
                              .replacementPlans
                              .map((replacementPlan) => replacementPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .replacementPlanDays),
                    changes: replacementPlans[0]
                        .replacementPlans[replacementPlans[0]
                            .replacementPlans
                            .map((replacementPlan) => replacementPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .changes
                      ..addAll(replacementPlans[1]
                          .replacementPlans[replacementPlans[1]
                              .replacementPlans
                              .map((replacementPlan) => replacementPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .changes),
                  ))
              .toList());
    }
  }
}
