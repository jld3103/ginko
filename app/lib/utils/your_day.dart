import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/storage/storage.dart';
import 'package:ginko/utils/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:models/models.dart';
import 'package:translations/translations_server.dart';

/// YourDay class
/// a summary notification of your day
class YourDay {
  static Future _checkNotification() async {
    final now = DateTime.now();
    if (now.weekday < 6) {
      final day = DateTime(now.year, now.month, now.day);

      Static.storage = Storage();
      await Static.storage.init();
      await Data.loadOffline();

      final lessonCount = Data.unitPlan.days[day.weekday - 1]
          .userLessonsCount(Data.user, isWeekA(day));
      if (now.isAfter(day.add(Duration(hours: 7, minutes: 54))) &&
          now.isBefore(day.add(Times.getUnitTimes(lessonCount - 1)[1]))) {
        debugPrint('Showing notification');
        await _showNotification();
        debugPrint(
            // ignore: lines_longer_than_80_chars
            'Canceling notification at ${day.add(Times.getUnitTimes(lessonCount - 1)[1]).add(Duration(minutes: 5))}');
        await AndroidAlarmManager.oneShotAt(
          day
              .add(Times.getUnitTimes(lessonCount - 1)[1])
              .add(Duration(minutes: 5)),
          1,
          _cancelNotification,
          rescheduleOnReboot: true,
          exact: true,
        );
      } else {
        debugPrint('Canceling notification because of wrong time');
        await _cancelNotification();
      }
    } else {
      debugPrint('Canceling notification because of wrong weekday');
      await _cancelNotification();
    }
  }

  static Future _repeater() async {
    await AndroidAlarmManager.initialize();
    await _checkNotification();
    final now = DateTime.now();
    var fireOffRepeater = DateTime(now.year, now.month, now.day, 7, 55);
    if (now.isAfter(fireOffRepeater)) {
      fireOffRepeater = fireOffRepeater.add(Duration(days: 1));
    }
    debugPrint('Firing again at $fireOffRepeater');
    await AndroidAlarmManager.oneShotAt(
      fireOffRepeater,
      0,
      _repeater,
      rescheduleOnReboot: true,
      exact: true,
    );
  }

  static Future _cancelNotification() async {
    await FlutterLocalNotificationsPlugin().cancel(5);
  }

  static Future _showNotification() async {
    await initializeDateFormatting(Data.user.language.value, null);
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final events = Data.calendar.getEventsForTimeSpan(start, end);
    final subjects = [];
    final changes = [];
    for (final lesson in Data.unitPlan.days[now.weekday - 1].lessons) {
      for (final subject in lesson.subjects) {
        // ignore: missing_required_param
        if (subject.identifier == Subject(subject: 'FR').identifier) {
          break;
        }
        if (subject.identifier == Selection.get(lesson.block, isWeekA(now))) {
          subjects.add(subject);
          changes.addAll(subject.getMatchingChanges(Data.replacementPlan));
          break;
        }
      }
    }
    final body = [];
    if (events.isNotEmpty) {
      body.add('<b>Termine:</b>');
    }
    for (final event in events) {
      body.add('<i>${event.name}</i>: ${event.dateString(Data.user)}');
    }
    if (subjects.isNotEmpty) {
      body.add('<b>Stundenplan:</b>');
    }
    for (final s in subjects) {
      final unit = s.unit + 1;
      final subject =
          ServerTranslations.subjects(Data.user.language.value)[s.subject];
      final room = s.room ?? '';
      body.add('$unit. <i>$subject</i> $room');
      for (final change in changes.where((change) => change.unit == s.unit)) {
        final buffer = StringBuffer()..write('&nbsp;' * 3);
        if (change.changed.subject != null &&
            change.changed.subject.isNotEmpty &&
            change.subject != change.changed.subject) {
          buffer.write(
              // ignore: lines_longer_than_80_chars
              ' ${ServerTranslations.subjects(Data.user.language.value)[change.changed.subject]}');
        }
        if (change.changed.info != null && change.changed.info.isNotEmpty) {
          buffer.write(' ${change.changed.info}');
        }
        if (change.changed.room != null &&
            change.changed.room.isNotEmpty &&
            change.room != change.changed.room) {
          buffer.write(' ${change.changed.room}');
        }
        if (change.changed.teacher != null &&
            change.changed.teacher.isNotEmpty &&
            change.teacher != change.changed.teacher) {
          buffer.write(' ${change.changed.teacher}');
        }
        body.add(buffer.toString());
      }
    }
    final title =
        // ignore: lines_longer_than_80_chars
        '${ServerTranslations.weekdays(Data.user.language.value)[now.weekday - 1]} ${outputDateFormat.format(now)}';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid =
        AndroidInitializationSettings('logo_white');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    final styleInformation =
        events.isEmpty && subjects.isEmpty && changes.isEmpty
            ? DefaultStyleInformation(false, false)
            : BigTextStyleInformation(
                body.join('<br/>'),
                contentTitle: title,
                htmlFormatBigText: true,
              );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      ticker: 'ticker',
      color: theme.accentColor,
      autoCancel: false,
      style: events.isEmpty && subjects.isEmpty && changes.isEmpty
          ? AndroidNotificationStyle.Default
          : AndroidNotificationStyle.BigText,
      styleInformation: styleInformation,
      ongoing: true,
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      5,
      title,
      // ignore: lines_longer_than_80_chars
      '${events.length} Termine ${subjects.length} Stunden ${changes.length} Änderungen',
      platformChannelSpecifics,
    );
  }

  /// Init your day
  static Future init() async {
    if (Platform().isAndroid) {
      await _repeater();
    }
  }
}
