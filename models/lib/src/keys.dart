// ignore: avoid_classes_with_only_static_members
/// Keys class
class Keys {
  // ignore: public_member_api_docs
  static const String username = 'username';

  // ignore: public_member_api_docs
  static const String password = 'password';

  // ignore: public_member_api_docs
  static const String grade = 'grade';

  // ignore: public_member_api_docs
  static const String timetable = 'timetable';

  // ignore: public_member_api_docs
  static const String selection = 'selection';

  // ignore: public_member_api_docs
  static String selectionBlock(String block, bool weekA) {
    if (block == null || weekA == null) {
      return 'selection';
    }
    return 'selection-$block-${weekA ? 'a' : 'b'}';
  }

  // ignore: public_member_api_docs
  static const String none = 'none';

  // ignore: public_member_api_docs
  static const String calendar = 'calendar';

  // ignore: public_member_api_docs
  static const String cafetoria = 'cafetoria';

  // ignore: public_member_api_docs
  static const String substitutionPlan = 'substitutionplan';

  // ignore: public_member_api_docs
  static const String user = 'user';

  // ignore: public_member_api_docs
  static const String askedForScan = 'askedforscan';

  // ignore: public_member_api_docs
  static const String teachers = 'teachers';

  // ignore: public_member_api_docs
  static const String weekday = 'weekday';

  // ignore: public_member_api_docs
  static const String aiXformation = 'aixformation';

  // ignore: public_member_api_docs
  static const String device = 'device';

  // ignore: public_member_api_docs
  static const String updates = 'updates';

  // ignore: public_member_api_docs
  static const String settings = 'settings';

  // ignore: public_member_api_docs
  static String settingsKey(String key) {
    if (key == null) {
      return 'settings';
    }
    return 'settings-$key';
  }

  // ignore: public_member_api_docs
  static const String substitutionPlanNotifications =
      'substitutionplannotifications';

  // ignore: public_member_api_docs
  static const String aiXformationNotifications = 'aixformationnotifications';

  // ignore: public_member_api_docs
  static const String cafetoriaNotifications = 'cafetorianotifications';

  // ignore: public_member_api_docs
  static const String type = 'type';

  // ignore: public_member_api_docs
  static const String releases = 'releases';
}