import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_server.dart';
import 'package:tuple/tuple.dart';

/// SubstitutionPlanHandler class
class SubstitutionPlanHandler extends Handler {
  // ignore: public_member_api_docs
  SubstitutionPlanHandler(
    MySqlConnection mySqlConnection,
    this.timetableHandler,
    this.selectionHandler,
  ) : super(
          Keys.substitutionPlan,
          mySqlConnection,
        );

  // ignore: public_member_api_docs
  final TimetableHandler timetableHandler;

  // ignore: public_member_api_docs
  final SelectionHandler selectionHandler;

  /// Fetch the latest version from the database
  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final results = await mySqlConnection.query(
        // ignore: lines_longer_than_80_chars
        'SELECT data FROM data_substitution_plan ORDER BY update_time DESC LIMIT 2;');
    if (results.toList().length == 1) {
      return Tuple2(
        json.decode(results.toList()[0][0].toString()),
        SubstitutionPlanForGrade.fromJSON(
                json.decode(results.toList()[0][0].toString()))
            .substitutionPlanDays[0]
            .date
            .toIso8601String(),
      );
    }
    if (results.toList().isEmpty) {
      return Tuple2(
        SubstitutionPlanForGrade(
          grade: user.grade,
          substitutionPlanDays: [],
          changes: [],
        ).toJSON(),
        '',
      );
    }
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
          .join(''),
    );
  }

  /// Update the data from the website into the database
  @override
  Future update() async {
    final substitutionPlans = [
      SubstitutionPlan(
        substitutionPlans: SubstitutionPlanParser.extract(
          await SubstitutionPlanParser.download(
            true,
            Config.websiteUsername,
            Config.websitePassword,
          ),
        ),
      ),
      SubstitutionPlan(
        substitutionPlans: SubstitutionPlanParser.extract(
          await SubstitutionPlanParser.download(
            false,
            Config.websiteUsername,
            Config.websitePassword,
          ),
        ),
      ),
    ];
    // ignore: omit_local_variable_types
    final List<SubstitutionPlan> notificationPlans = [];
    for (final substitutionPlan in substitutionPlans) {
      final dataString = json.encode(substitutionPlan.toJSON());
      final results = await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'SELECT data FROM data_substitution_plan WHERE date_time = \'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].date.toIso8601String()}\' AND update_time = \'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].updated.toIso8601String()}\';');
      if (results.isNotEmpty) {
        final storedData = results.toList()[0][0].toString();
        if (storedData == dataString) {
          continue;
        }
      }
      await mySqlConnection.query(
          // ignore: lines_longer_than_80_chars
          'INSERT INTO data_substitution_plan (date_time, update_time, data) VALUES (\'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].date.toIso8601String()}\', \'${substitutionPlan.substitutionPlans[0].substitutionPlanDays[0].updated.toIso8601String()}\', \'$dataString\') ON DUPLICATE KEY UPDATE data = \'$dataString\';');
      notificationPlans.add(substitutionPlan);
    }
    if (notificationPlans.isNotEmpty) {
      // ignore: omit_local_variable_types
      final Map<String, List<String>> notifications = {};
      for (final locale in LocalesList.locales) {
        for (final substitutionPlan in notificationPlans) {
          final devicesResults = await mySqlConnection.query(
              // ignore: lines_longer_than_80_chars
              'SELECT username, token FROM users_devices WHERE language = \'$locale\';');
          for (final row in devicesResults.toList()) {
            final username = row[0].toString();
            final token = row[1].toString();
            final gradeResults = await mySqlConnection.query(
                // ignore: lines_longer_than_80_chars
                'SELECT grade FROM users_grade WHERE username = \'$username\';');
            final grade = gradeResults.toList()[0][0].toString();
            final settingsResults = await mySqlConnection.query(
                // ignore: lines_longer_than_80_chars
                'SELECT settings_value FROM users_settings WHERE username = \'$username\' AND settings_key = \'${Keys.settingsKey(Keys.substitutionPlanNotifications)}\';');
            bool showNotifications;
            if (settingsResults.isNotEmpty) {
              showNotifications = settingsResults.toList()[0][0] == 1;
            } else {
              showNotifications = true;
            }
            if (showNotifications) {
              final notification = _createNotification(
                TimetableForGrade.fromJSON(
                  (await timetableHandler.fetchLatest(User(
                    grade: grade,
                    username: null,
                    password: null,
                    fullName: null,
                  )))
                      .item1,
                ),
                substitutionPlan.substitutionPlans[grades.indexOf(grade)],
                substitutionPlan.substitutionPlans[grades.indexOf(grade)]
                    .substitutionPlanDays[0],
                await selectionHandler.getSelection(username),
                locale,
              );
              if (notifications[json.encode(notification.toJSON())] == null) {
                notifications[json.encode(notification.toJSON())] = [];
              }
              notifications[json.encode(notification.toJSON())].add(token);
            }
          }
        }
      }
      for (final notification in notifications.keys) {
        await Notifications.sendNotification(
          Notification.fromJSON(json.decode(notification)),
          notifications[notification],
        );
      }
    }
  }

  static Notification _createNotification(
    TimetableForGrade timetableForGrade,
    SubstitutionPlanForGrade substitutionPlanForGrade,
    SubstitutionPlanDay substitutionPlanDay,
    Selection selection,
    String language,
  ) {
    final changes = substitutionPlanForGrade.changes
        .where((change) => change.date == substitutionPlanDay.date)
        .where((change) {
      final block = timetableForGrade.days[substitutionPlanDay.date.weekday - 1]
          .lessons[change.unit].block;
      final key = Keys.selectionBlock(block, isWeekA(substitutionPlanDay.date));
      final userSelected = selection.getSelection(key);
      final originalSubjects =
          change.getMatchingSubjectsByTimetable(timetableForGrade);
      if (originalSubjects.length != 1) {
        return true;
      }
      return userSelected == originalSubjects[0].identifier;
    }).toList();
    final title =
        // ignore: lines_longer_than_80_chars
        '${ServerTranslations.weekdays(language)[substitutionPlanDay.date.weekday - 1]} ${outputDateFormat(language).format(substitutionPlanDay.date)}';
    final lines = [];
    for (final change in changes) {
      final completedChange = change.completed(
          timetableForGrade.days[change.date.weekday - 1].lessons[change.unit]);

      final buffer = StringBuffer()..write('<b>${change.unit + 1}.</b> ');

      if (completedChange.subject != null &&
          completedChange.subject.isNotEmpty) {
        buffer.write(
            // ignore: lines_longer_than_80_chars
            '${ServerTranslations.subjects(language)[completedChange.subject]} ');
      }
      if (completedChange.type == ChangeTypes.freeLesson) {
        buffer.write(ServerTranslations.substitutionPlanFreeLesson(language));
      }
      if (completedChange.type == ChangeTypes.exam) {
        buffer.write(ServerTranslations.substitutionPlanExam(language));
      }
      if (completedChange.type == ChangeTypes.changed) {
        buffer.write(ServerTranslations.substitutionPlanChanged(language));
      }
      if (completedChange.changed.info != null) {
        buffer.write(' ${completedChange.changed.info}');
      }
      lines.add(buffer.toString());
    }
    final bigBody = lines.isEmpty
        ? ServerTranslations.substitutionPlanNoChanges(language)
        : lines.join('<br/>');
    final body = changes.isEmpty
        ? ServerTranslations.substitutionPlanNoChanges(language)
        : changes.length == 1
            ? lines[0]
            // ignore: lines_longer_than_80_chars
            : '${changes.length} ${ServerTranslations.substitutionPlanChanges(language)}';
    return Notification(
      title,
      body,
      bigBody,
      data: {
        Keys.type: Keys.substitutionPlan,
        Keys.weekday: substitutionPlanDay.date.weekday - 1,
      },
    );
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
