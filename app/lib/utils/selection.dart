import 'package:ginko/utils/data.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// Selection class
/// handles all unit plan selections
class Selection {
  /// Get the selection for a day and unit
  static String get(String block, bool weekA) =>
      Data.getSelection(Keys.selection(block, weekA));

  /// Get the selection for a day and unit
  static void set(String block, bool weekA, String identifier) =>
      Data.setSelection(Keys.selection(block, weekA), identifier);
}
