import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/data/unitplan.dart';
import 'package:server/extra/replacementplan.dart';
import 'package:server/parsers/replacementplan.dart';
import 'package:server/users.dart';

// ignore: avoid_classes_with_only_static_members
/// ReplacementPlanData class
/// handles all replacement plan storing
class ReplacementPlanData {
  // ignore: public_member_api_docs
  static ReplacementPlan replacementPlan;

  // ignore: public_member_api_docs
  static ReplacementPlan previous;

  /// Complete all changes using the unit plan
  static void complete() {
    replacementPlan.replacementPlans =
        replacementPlan.replacementPlans.map((plan) {
      plan.changes = plan.changes.map((change) {
        final matchingClasses = change.getMatchingSubjectsByUnitPlan(
            UnitPlanData.unitPlan.unitPlans[grades.indexOf(plan.grade)]);
        if (matchingClasses.length == 1) {
          change.complete(matchingClasses[0]);
        }
        return change;
      }).toList();
      return plan;
    }).toList();
  }

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
    UnitPlanData.complete();
    ReplacementPlanData.complete();
    previous ??= replacementPlan;
    if (previous.replacementPlans[0].replacementPlanDays[0].updated !=
            replacementPlan
                .replacementPlans[0].replacementPlanDays[0].updated ||
        previous.replacementPlans[0].replacementPlanDays[1].updated !=
            replacementPlan
                .replacementPlans[0].replacementPlanDays[1].updated ||
        Config.dev) {
      print('Fire notifications!');

      for (final username in Users.usernames) {
        final user = Users.getUser(username);
        final days = replacementPlan
            .replacementPlans[grades.indexOf(user.grade.value)]
            .replacementPlanDays;
        for (final day in days) {
          final oldDay = previous
              .replacementPlans[grades.indexOf(user.grade.value)]
              .replacementPlanDays[days.indexOf(day)];
          final oldNotification = ReplacementPlanExtra.createNotification(
            user,
            UnitPlanData.unitPlan.unitPlans[grades.indexOf(user.grade.value)],
            previous.replacementPlans[grades.indexOf(user.grade.value)],
            oldDay,
          );
          final notification = ReplacementPlanExtra.createNotification(
            user,
            UnitPlanData.unitPlan.unitPlans[grades.indexOf(user.grade.value)],
            replacementPlan.replacementPlans[grades.indexOf(user.grade.value)],
            day,
          );
          if (oldNotification.title != notification.title ||
              oldNotification.body != notification.body ||
              oldNotification.bigBody != notification.bigBody ||
              Config.dev) {
            try {
              final unregisteredTokens = [];
              for (final token in user.tokens) {
                final tokenRegistered = await notification.send(token);
                if (!tokenRegistered) {
                  unregisteredTokens.add(token);
                }
              }
              for (final unregisteredToken in unregisteredTokens) {
                Users.removeToken(username, unregisteredToken);
              }
              // ignore: avoid_catches_without_on_clauses
            } catch (e) {
              print(e);
            }
          }
        }
      }
      previous = ReplacementPlan.fromJSON(
          json.decode(json.encode(replacementPlan.toJSON())));
    } else {
      print('Nothing changed');
    }
    for (final replacementPlanForGrade in replacementPlan.replacementPlans) {
      for (final change in replacementPlanForGrade.changes) {
        final subjects = change.getMatchingSubjectsByUnitPlan(UnitPlanData
            .unitPlan.unitPlans[grades.indexOf(replacementPlanForGrade.grade)]);
        if (subjects.length != 1) {
          // TODO(jld3103): Uncomment when new unit plan is available
          /*
          print(
              // ignore: lines_longer_than_80_chars
              "Filter wasn't able to figure out the original subject for this change:");
          print(change.toJSON());
          print(UnitPlanData
              .unitPlan
              .unitPlans[grades.indexOf(replacementPlanForGrade.grade)]
              .days[change.date.weekday - 1]
              .lessons[change.unit]
              .subjects
              .map((subject) => subject.toJSON())
              .toList());
           */
        }
      }
    }
  }
}

Future main(List<String> arguments) async {
  await setupDateFormats();
  Config.loadFromDefault();
  Config.dev = true;
  Users.load();
  await UnitPlanData.load();
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
      final replacementPlansForGrade =
          ReplacementPlanParser.extract(parse(File(file).readAsStringSync()));
      for (final replacementPlanForGrade in replacementPlansForGrade) {
        for (final change in replacementPlanForGrade.changes) {
          change.getMatchingSubjectsByUnitPlan(UnitPlanData.unitPlan
              .unitPlans[grades.indexOf(replacementPlanForGrade.grade)]);
        }
      }
    }
  } else {
    await ReplacementPlanData.load();
  }
}
