import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// TimetableSelection class
/// handles all timetable selections
class TimetableSelection {
  /// Get the selection for a day and unit
  static String get(String block, bool weekA) =>
      Static.selection.data.getSelection(Keys.selectionBlock(block, weekA));

  /// Get the selection for a day and unit
  static void set(String block, bool weekA, String identifier) =>
      Static.selection.data
          .setSelection(Keys.selectionBlock(block, weekA), identifier);
}
