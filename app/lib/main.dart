import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:ginko/aixformation/aixformation_page.dart';
import 'package:ginko/app/app_page.dart';
import 'package:ginko/cafetoria/cafetoria_page.dart';
import 'package:ginko/calendar/calendar_page.dart';
import 'package:ginko/choose/choose_page.dart';
import 'package:ginko/login/login_page.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/storage/storage.dart';
import 'package:ginko/settings/settings_page.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

Future main() async {
  if (Platform().isDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  WidgetsFlutterBinding.ensureInitialized();

  Static.storage = Storage();
  await Static.storage.init();

  runApp(MaterialApp(
    title: 'Ginko',
    theme: theme,
    routes: <String, WidgetBuilder>{
      '/': (context) => AppPage(),
      '/${Keys.timetable}': (context) => AppPage(
            page: 2,
            loading: false,
          ),
      '/${Keys.substitutionPlan}': (context) => AppPage(
            page: 0,
            loading: false,
          ),
      '/${Keys.login}': (context) => LoginPageWrapper(),
      '/${Keys.choose}': (context) => ChoosePage(),
      '/${Keys.cafetoria}': (context) => CafetoriaPage(),
      '/${Keys.aiXformation}': (context) => AiXformationPage(),
      '/${Keys.calendar}': (context) => CalendarPage(),
      '/${Keys.settings}': (context) => SettingsPage(),
    },
  ));
}
