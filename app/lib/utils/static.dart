import 'package:ginko/loaders/aixformation.dart';
import 'package:ginko/loaders/cafetoria.dart';
import 'package:ginko/loaders/calendar.dart';
import 'package:ginko/loaders/device.dart';
import 'package:ginko/loaders/releases.dart';
import 'package:ginko/loaders/selection.dart';
import 'package:ginko/loaders/settings.dart';
import 'package:ginko/loaders/substitution_plan.dart';
import 'package:ginko/loaders/timetable.dart';
import 'package:ginko/loaders/updates.dart';
import 'package:ginko/loaders/user.dart';
import 'package:ginko/plugins/firebase/firebase.dart';
import 'package:ginko/plugins/storage/storage.dart';

// ignore: avoid_classes_with_only_static_members
/// Static class
/// handles all app wide static objects
class Static {
  // ignore: public_member_api_docs
  static Storage storage;

  // ignore: public_member_api_docs
  static bool online;

  // ignore: public_member_api_docs
  static VoidCallback rebuildTimetable;

  // ignore: public_member_api_docs
  static FutureCallbackShouldRender refreshSubstitutionPlan;

  // ignore: public_member_api_docs
  static FutureCallbackShouldRender refreshCafetoria;

  // ignore: public_member_api_docs
  static FutureCallbackShouldRender refreshAiXformation;

  // ignore: public_member_api_docs
  static TimetableLoader timetable = TimetableLoader();

  // ignore: public_member_api_docs
  static SubstitutionPlanLoader substitutionPlan = SubstitutionPlanLoader();

  // ignore: public_member_api_docs
  static CalendarLoader calendar = CalendarLoader();

  // ignore: public_member_api_docs
  static CafetoriaLoader cafetoria = CafetoriaLoader();

  // ignore: public_member_api_docs
  static AiXformationLoader aiXformation = AiXformationLoader();

  // ignore: public_member_api_docs
  static UserLoader user = UserLoader();

  // ignore: public_member_api_docs
  static DeviceLoader device = DeviceLoader();

  // ignore: public_member_api_docs
  static SelectionLoader selection = SelectionLoader();

  // ignore: public_member_api_docs
  static UpdatesLoader updates = UpdatesLoader();

  // ignore: public_member_api_docs
  static SettingsLoader settings = SettingsLoader();

  // ignore: public_member_api_docs
  static ReleasesLoader releases = ReleasesLoader();

  // ignore: public_member_api_docs
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging();
}

typedef VoidCallback = void Function();
typedef FutureCallback = Future Function();
typedef FutureCallbackShouldRender = Future Function(bool shouldRender);
