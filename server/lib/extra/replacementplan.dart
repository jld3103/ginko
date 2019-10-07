import 'package:models/models.dart';
import 'package:server/notification.dart';
import 'package:translations/translations_server.dart';

/// ReplacementPlanExtra class
/// extras for replacement plan parsing
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

  /// Create a notification for a user's changes
  static Notification createNotification(
    User user,
    UnitPlanForGrade unitPlanForGrade,
    ReplacementPlanForGrade replacementPlanForGrade,
    ReplacementPlanDay day, {
    bool formatting = true,
  }) {
    final changes = replacementPlanForGrade.changes
        .where((change) => change.date == day.date)
        .where((change) {
      final block = unitPlanForGrade
          .days[day.date.weekday - 1].lessons[change.unit].block;
      final key = Keys.selection(block, isWeekA(day.date));
      final userSelected = user.getSelection(key);
      final originalSubjects =
          change.getMatchingSubjectsByUnitPlan(unitPlanForGrade);
      if (originalSubjects.length != 1) {
        return true;
      }
      return userSelected == originalSubjects[0].identifier;
    }).toList();
    final title =
        // ignore: lines_longer_than_80_chars
        '${ServerTranslations.weekdays(user.language.value)[day.date.weekday - 1]} ${outputDateFormat(user.language.value).format(day.date)}';
    final lines = [];
    var previousUnit = -1;
    for (final change in changes) {
      if (change.unit != previousUnit) {
        lines.add(
            // ignore: lines_longer_than_80_chars
            '${formatting ? '<b>' : ''}${change.unit + 1}. ${ServerTranslations.unit(user.language.value)}:${formatting ? '</b>' : ''}');
        previousUnit = change.unit;
      }

      final buffer = StringBuffer();
      if (change.subject != null && change.subject.isNotEmpty) {
        buffer.write(
            ServerTranslations.subjects(user.language.value)[change.subject]);
      }
      if (change.room != null && change.room.isNotEmpty) {
        buffer.write(' ${change.room}');
      }
      if (change.teacher != null && change.teacher.isNotEmpty) {
        buffer.write(' ${change.teacher}');
      }
      buffer.write(':');
      if (change.changed.subject != null &&
          change.changed.subject.isNotEmpty &&
          change.subject != change.changed.subject) {
        buffer.write(
            // ignore: lines_longer_than_80_chars
            ' ${ServerTranslations.subjects(user.language.value)[change.changed.subject]}');
      }
      if (change.changed.room != null && change.room != change.changed.room) {
        buffer.write(' ${change.changed.room}');
      }
      if (change.changed.teacher != null &&
          change.teacher != change.changed.teacher) {
        buffer.write(' ${change.changed.teacher}');
      }
      if (change.type == ChangeTypes.freeLesson) {
        buffer.write(
            // ignore: lines_longer_than_80_chars
            ' ${ServerTranslations.replacementPlanFreeLesson(user.language.value)}');
      }
      if (change.type == ChangeTypes.exam) {
        buffer.write(
            // ignore: lines_longer_than_80_chars
            ' ${ServerTranslations.replacementPlanExam(user.language.value)}');
      }
      if (change.changed.info != null) {
        buffer.write(' ${change.changed.info}');
      }
      lines.add(buffer.toString());
    }
    final bigBody = lines.isEmpty
        ? ServerTranslations.notificationsNoChanges(user.language.value)
        : lines.join('${formatting ? '<br/>' : '\n'}');
    final body = changes.isEmpty
        ? ServerTranslations.notificationsNoChanges(user.language.value)
        // ignore: lines_longer_than_80_chars
        : '${changes.length} ${ServerTranslations.notificationsChanges(user.language.value)}';
    return Notification(
      title,
      body,
      bigBody,
      data: {
        Keys.type: Keys.replacementPlan,
        Keys.weekday: day.date.weekday - 1,
      },
    );
  }
}
