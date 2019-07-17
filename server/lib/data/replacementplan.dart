import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/data/unitplan.dart';
import 'package:server/extra/replacementplan.dart';
import 'package:server/notification.dart';
import 'package:server/parsers/replacementplan.dart';
import 'package:server/users.dart';

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
    final previous = replacementPlan;
    replacementPlan = ReplacementPlanExtra.mergeReplacementPlans(
        plans.cast<ReplacementPlan>());
    if (previous != null &&
        json.encode(previous.toJSON()) !=
            json.encode(replacementPlan.toJSON())) {
      print('Fire notifications!');

      for (final encryptedUsername in Users.encryptedUsernames) {
        final user = Users.getUser(encryptedUsername);
        for (final day in replacementPlan
            .replacementPlans[grades.indexOf(user.grade)].replacementPlanDays) {
          final changes = replacementPlan
              .replacementPlans[grades.indexOf(user.grade)].changes
              .where((change) {
            final block = UnitPlanData
                .unitPlan
                .unitPlans[grades.indexOf(user.grade)]
                .days[day.date.weekday - 1]
                .lessons[change.unit]
                .block;
            final key = Keys.selection(block, isWeekA(day.date));
            final userSelected = user.selection[key];
            final originalSubject = change.getMatchingClasses(
                UnitPlanData.unitPlan.unitPlans[grades.indexOf(user.grade)]);
            return userSelected == originalSubject.identifier;
          }).toList();
          // ignore: prefer_interpolation_to_compose_strings
          final title = [
                'Montag',
                'Dienstag',
                'Mittwoch',
                'Donnerstag',
                'Freitag',
                'Samstag',
                'Sonntag',
              ][day.date.weekday - 1] +
              ' ${outputDateFormat.format(day.date)}';
          final body = '${changes.length} Änderungen';
          final lines = [];
          var previousUnit = -1;
          for (final change in changes) {
            if (change.unit != previousUnit) {
              lines.add('<b>${change.unit + 1}. Stunde:</b>');
              previousUnit = change.unit;
            }

            final buffer = StringBuffer();
            if (change.subject != null && change.subject.isNotEmpty) {
              buffer.write(change.subject);
            }
            if (change.teacher != null && change.teacher.isNotEmpty) {
              buffer.write(' ${change.teacher}');
            }
            buffer.write(':');
            if (change.changed.subject != null &&
                change.changed.subject.isNotEmpty) {
              buffer.write(' ${change.changed.subject}');
            }
            if (change.changed.info != null && change.changed.info.isNotEmpty) {
              buffer.write(' ${change.changed.info}');
            }
            if (change.changed.teacher != null &&
                change.changed.teacher.isNotEmpty) {
              buffer.write(' ${change.changed.teacher}');
            }
            if (change.changed.room != null && change.changed.room.isNotEmpty) {
              buffer.write(' ${change.changed.room}');
            }
            lines.add(buffer.toString());
          }
          final bigBody = lines.join('<br/>');
          for (final token in user.tokens) {
            await Notification.send(token, title, body, bigBody, data: {
              Keys.type: Keys.replacementPlan,
            });
          }
        }
      }
    } else {
      print('Nothing changed');
    }
    for (final replacementPlanForGrade in replacementPlan.replacementPlans) {
      for (final change in replacementPlanForGrade.changes) {
        change.getMatchingClasses(UnitPlanData
            .unitPlan.unitPlans[grades.indexOf(replacementPlanForGrade.grade)]);
      }
    }
  }
}

Future main(List<String> arguments) async {
  await setupDateFormats();
  Config.load();
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
          change.getMatchingClasses(UnitPlanData.unitPlan
              .unitPlans[grades.indexOf(replacementPlanForGrade.grade)]);
        }
      }
    }
  } else {
    await ReplacementPlanData.load();
  }
}
