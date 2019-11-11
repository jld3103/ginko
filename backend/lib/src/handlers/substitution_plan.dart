import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// SubstitutionPlanHandler class
class SubstitutionPlanHandler extends Handler {
  // ignore: public_member_api_docs
  SubstitutionPlanHandler(MySqlConnection mySqlConnection)
      : super(Keys.substitutionPlan, mySqlConnection);

  /// Fetch the latest version from the database
  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_substitution_plan ORDER BY update_time DESC LIMIT 2;');
    final substitutionPlan = _mergeSubstitutionPlans(results
            .toList()
            .map((row) =>
                SubstitutionPlan.fromJSON(json.decode(row[0].toString())))
            .toList()
            .cast<SubstitutionPlan>())
        .substitutionPlans
        .where((substitutionPlan) => substitutionPlan.grade == user.grade)
        .single;
    return Tuple2(
        substitutionPlan.toJSON(),
        substitutionPlan.substitutionPlanDays
            .map((day) => day.date.toIso8601String())
            .join(''));
  }

  /// Update the data from the website into the database
  @override
  Future update(Config config) async {
    final substitutionPlans = [
      SubstitutionPlan(
        substitutionPlans: SubstitutionPlanParser.extract(
          await SubstitutionPlanParser.download(
            true,
            config.websiteUsername,
            config.websitePassword,
          ),
        ),
      ),
      SubstitutionPlan(
        substitutionPlans: SubstitutionPlanParser.extract(
          await SubstitutionPlanParser.download(
            false,
            config.websiteUsername,
            config.websitePassword,
          ),
        ),
      ),
    ];
    for (final substitutionPlan in substitutionPlans) {
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_substitution_plan (date_time, update_time, data) VALUES (\'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].date.toIso8601String()}\', \'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].updated.toIso8601String()}\', \'${json.encode(substitutionPlan.toJSON())}\') ON DUPLICATE KEY UPDATE data = \'${json.encode(substitutionPlan.toJSON())}\', update_time = \'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].updated.toIso8601String()}\';');
    }
  }

  static SubstitutionPlan _mergeSubstitutionPlans(
      List<SubstitutionPlan> substitutionPlans) {
    if (substitutionPlans[0].substitutionPlans[0].timeStamp ==
        substitutionPlans[1].substitutionPlans[0].timeStamp) {
      if (substitutionPlans[0]
          .substitutionPlans[0]
          .substitutionPlanDays[0]
          .updated
          .isAfter(substitutionPlans[1]
              .substitutionPlans[0]
              .substitutionPlanDays[0]
              .updated)) {
        return substitutionPlans[0];
      } else {
        return substitutionPlans[1];
      }
    } else {
      return SubstitutionPlan(
          substitutionPlans: substitutionPlans[0]
              .substitutionPlans
              .map((replacementPlan) => replacementPlan.grade)
              .map((grade) => SubstitutionPlanForGrade(
                    grade: grade,
                    substitutionPlanDays: substitutionPlans[0]
                        .substitutionPlans[substitutionPlans[0]
                            .substitutionPlans
                            .map((replacementPlan) => replacementPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .substitutionPlanDays
                      ..addAll(substitutionPlans[1]
                          .substitutionPlans[substitutionPlans[1]
                              .substitutionPlans
                              .map((replacementPlan) => replacementPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .substitutionPlanDays),
                    changes: substitutionPlans[0]
                        .substitutionPlans[substitutionPlans[0]
                            .substitutionPlans
                            .map((replacementPlan) => replacementPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .changes
                      ..addAll(substitutionPlans[1]
                          .substitutionPlans[substitutionPlans[1]
                              .substitutionPlans
                              .map((replacementPlan) => replacementPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .changes),
                  ))
              .toList());
    }
  }
}
