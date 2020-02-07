import 'dart:convert';

import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parsers/parsers.dart';
import 'package:tuple/tuple.dart';

/// SubstitutionPlanHandler class
class SubstitutionPlanHandler extends Handler {
  // ignore: public_member_api_docs
  SubstitutionPlanHandler(
    MySqlConnection mySqlConnection,
    this.timetableHandler,
    this.selectionHandler,
    this.subjectsHandler,
  ) : super(
          Keys.substitutionPlan,
          mySqlConnection,
        );

  // ignore: public_member_api_docs
  final TimetableHandler timetableHandler;

  // ignore: public_member_api_docs
  final SelectionHandler selectionHandler;

  // ignore: public_member_api_docs
  final SubjectsHandler subjectsHandler;

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
      for (final substitutionPlan in notificationPlans) {
        final devicesResults = await mySqlConnection.query(
            // ignore: lines_longer_than_80_chars
            'SELECT username, token FROM users_devices;');
        for (final row in devicesResults.toList()) {
          final username = row[0].toString();
          final token = row[1].toString();
          if (token == '') {
            continue;
          }
          final gradeResults = await mySqlConnection.query(
              // ignore: lines_longer_than_80_chars
              'SELECT grade FROM users_grade WHERE username = \'$username\';');
          final grade = gradeResults.toList()[0][0].toString();
          final settingsResults = await mySqlConnection.query(
              // ignore: lines_longer_than_80_chars
              'SELECT settings_value FROM users_settings WHERE username = \'$username\' AND settings_key = \'${Keys.substitutionPlanNotifications}\';');
          bool showNotifications;
          if (settingsResults.isNotEmpty) {
            showNotifications = settingsResults.toList()[0][0] == 1;
          } else {
            showNotifications = true;
          }
          if (showNotifications) {
            final notification = await _createNotification(
              TimetableForGrade.fromJSON(
                (await timetableHandler.fetchLatest(User(
                  grade: grade,
                  username: null,
                  password: null,
                )))
                    .item1,
              ),
              substitutionPlan.substitutionPlans[grades.indexOf(grade)],
              substitutionPlan.substitutionPlans[grades.indexOf(grade)]
                  .substitutionPlanDays[0],
              await selectionHandler.getSelection(username),
              subjectsHandler,
              notificationPlans.indexOf(substitutionPlan),
              mySqlConnection,
            );
            if (notifications[json.encode(notification.toJSON())] == null) {
              notifications[json.encode(notification.toJSON())] = [];
            }
            notifications[json.encode(notification.toJSON())].add(token);
          }
        }
      }
      for (final notification in notifications.keys) {
        final n = Notification.fromJSON(json.decode(notification));
        final cached = await Notifications.checkNotificationCached(
            n, mySqlConnection, notifications[notification]);
        await Notifications.sendNotification(
          n,
          notifications[notification]
              .where((t) => !cached[notifications[notification].indexOf(t)])
              .toList(),
        );
      }
    }
  }

  static Future<Notification> _createNotification(
    TimetableForGrade timetableForGrade,
    SubstitutionPlanForGrade substitutionPlanForGrade,
    SubstitutionPlanDay substitutionPlanDay,
    Selection selection,
    SubjectsHandler subjectsHandler,
    int index,
    MySqlConnection mySqlConnection,
  ) async {
    final subjects =
        Subjects.fromJSON((await subjectsHandler.fetchLatest(null)).item1);
    final changes = substitutionPlanForGrade.changes
        .where((change) => change.date == substitutionPlanDay.date)
        .where((change) {
      final s = timetableForGrade
          .days[substitutionPlanDay.date.weekday - 1].lessons[change.unit];
      final userSelected = selection.getSelection(s.block);
      final matchingSubjects =
          s.subjects.where((s) => change.subjectMatches(s)).toList();
      if (matchingSubjects.length != 1) {
        return true;
      }
      return userSelected == matchingSubjects[0].identifier;
    }).toList();
    final title =
        // ignore: lines_longer_than_80_chars
        '${weekdays[substitutionPlanDay.date.weekday - 1]} ${outputDateFormat.format(substitutionPlanDay.date)}';
    final lines = [];
    for (final change in changes) {
      final completedChange = change.completedByLesson(
          timetableForGrade.days[change.date.weekday - 1].lessons[change.unit]);

      final buffer = StringBuffer()..write('<b>${change.unit + 1}.</b> ');

      if (completedChange.subject != null &&
          completedChange.subject.isNotEmpty) {
        buffer.write(
            // ignore: lines_longer_than_80_chars
            '${Subjects.fromJSON((await subjectsHandler.fetchLatest(null)).item1).subjects[completedChange.subject]} ');
      }
      if (completedChange.type == SubstitutionPlanChangeTypes.freeLesson) {
        buffer.write(subjects.subjects['fr']);
      }
      if (completedChange.type == SubstitutionPlanChangeTypes.exam) {
        buffer.write(subjects.subjects['kl']);
      }
      if (completedChange.type == SubstitutionPlanChangeTypes.changed) {
        buffer.write(subjects.subjects['ae']);
      }
      if (completedChange.changed.info != null) {
        buffer.write(' ${completedChange.changed.info}');
      }
      lines.add(buffer.toString());
    }
    final bigBody = lines.isEmpty ? 'Keine Änderungen' : lines.join('<br/>');
    final body = changes.isEmpty
        ? 'Keine Änderungen'
        : changes.length == 1
            ? lines[0]
            // ignore: lines_longer_than_80_chars
            : '${changes.length} Änderungen';
    return Notification(
      '${Keys.substitutionPlan}-$index',
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
              .map((substitutionPlan) => substitutionPlan.grade)
              .map((grade) => SubstitutionPlanForGrade(
                    grade: grade,
                    substitutionPlanDays: substitutionPlans[0]
                        .substitutionPlans[substitutionPlans[0]
                            .substitutionPlans
                            .map((substitutionPlan) => substitutionPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .substitutionPlanDays
                      ..addAll(substitutionPlans[1]
                          .substitutionPlans[substitutionPlans[1]
                              .substitutionPlans
                              .map((substitutionPlan) => substitutionPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .substitutionPlanDays),
                    changes: substitutionPlans[0]
                        .substitutionPlans[substitutionPlans[0]
                            .substitutionPlans
                            .map((substitutionPlan) => substitutionPlan.grade)
                            .toList()
                            .indexOf(grade)]
                        .changes
                      ..addAll(substitutionPlans[1]
                          .substitutionPlans[substitutionPlans[1]
                              .substitutionPlans
                              .map((substitutionPlan) => substitutionPlan.grade)
                              .toList()
                              .indexOf(grade)]
                          .changes),
                  ))
              .toList());
    }
  }
}
