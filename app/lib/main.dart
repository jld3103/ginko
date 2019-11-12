import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ginko/pages/aixformation.dart';
import 'package:ginko/pages/cafetoria.dart';
import 'package:ginko/pages/cloud.dart';
import 'package:ginko/pages/home.dart';
import 'package:ginko/pages/loading.dart';
import 'package:ginko/pages/login.dart';
import 'package:ginko/pages/settings.dart';
import 'package:ginko/pages/substitution_plan.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/storage/storage.dart';
import 'package:ginko/plugins/system_locale/system_locale.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:ginko/views/header.dart';
import 'package:ginko/views/timetable/scan.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_app.dart';

Future main() async {
  if (Platform().isDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  WidgetsFlutterBinding.ensureInitialized();

  await SystemLocale().setSystemLocale();

  Static.storage = Storage();
  await Static.storage.init();

  runApp(MaterialApp(
    title: 'Ginko',
    theme: theme,
    locale: Locale(Intl.defaultLocale),
    localizationsDelegates: [
      AppTranslationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales:
        LocalesList.locales.map((locale) => Locale(locale)).toList(),
    routes: <String, WidgetBuilder>{
      '/': (context) => Scaffold(body: LoadingPage()),
      '/login': (context) => Scaffold(body: LoginPage()),
      '/home': (context) => Scaffold(
            body: App(
              initialPage: 0,
            ),
          ),
      '/substitutionplan': (context) => Scaffold(
            body: App(
              initialPage: 1,
            ),
          ),
      '/cloud': (context) => Scaffold(
            body: App(
              initialPage: 2,
            ),
          ),
      '/cafetoria': (context) => Scaffold(
            body: App(
              initialPage: 3,
            ),
          ),
      '/aixformation': (context) => Scaffold(
            body: App(
              initialPage: 4,
            ),
          ),
      '/settings': (context) => Scaffold(
            body: App(
              initialPage: 5,
            ),
          ),
    },
  ));
}

/// App class
/// describes the home widget
class App extends StatefulWidget {
  // ignore: public_member_api_docs
  const App({
    this.initialPage = 0,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final int initialPage;

  @override
  State<StatefulWidget> createState() => AppState();
}

/// AppState class
/// describes the state of the home widget
class AppState extends State<App>
    with TickerProviderStateMixin, AfterLayoutMixin<App> {
  static final _channel = MethodChannel('de.ginko.app');

  final List<Page> _pages = [];

  @override
  Future afterFirstLayout(BuildContext context) async {
    setState(() {
      _pages.addAll(
        [
          Page(
            name: AppTranslations.of(context).pageStart,
            icon: Icons.home,
            child: HomePage(
              device: Static.device.data,
              timetable: Static.timetable.data,
              substitutionPlan: Static.substitutionPlan.data,
              calendar: Static.calendar.data,
              cafetoria: Static.cafetoria.data,
              selection: Static.selection.data,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageSubstitutionPlan,
            icon: Icons.format_list_numbered,
            child: SubstitutionPlanPage(
              device: Static.device.data,
              substitutionPlan: Static.substitutionPlan.data,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageCloud,
            icon: Icons.cloud,
            child: CloudPage(
              user: Static.user.data,
              device: Static.device.data,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageCafetoria,
            icon: Icons.restaurant,
            child: CafetoriaPage(
              device: Static.device.data,
              cafetoria: Static.cafetoria.data,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageAiXformation,
            icon: MdiIcons.newspaper,
            child: AiXformationPage(
              device: Static.device.data,
              posts: Static.aiXformation.data,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageSettings,
            icon: Icons.settings,
            child: SettingsPage(),
          ),
        ],
      );
    });
    if (!Static.online) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(AppTranslations.of(context).homeOffline),
      ));
    }
    if (Platform().isMobile) {
      await updateTokens(context);
    }
    if (Platform().isMobile || Platform().isWeb) {
      Static.firebaseMessaging.configure(
        onLaunch: (data) async => _handleForegroundNotification(context, data),
        onResume: (data) async => _handleForegroundNotification(context, data),
        onMessage: (data) async => _handleForegroundNotification(context, data),
      );
    }
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'background_notification') {
        await Static.substitutionPlan.loadOnline();
        await Navigator.of(context).pushReplacementNamed('/substitutionplan');
      } else if (call.method == 'foreground_notification') {
        await _handleForegroundNotification(
            context, json.decode(json.encode(call.arguments)));
      }
    });
    if (Platform().isAndroid) {
      await _channel.invokeMethod('channel_registered');
    }

    // Ask for scan
    if (isSeniorGrade(Static.user.data.grade) &&
        Platform().isMobile &&
        !(Static.storage.getBool(Keys.askedForScan) ?? false)) {
      Static.storage.setBool(Keys.askedForScan, true);
      var allDetected = true;
      for (final day in Static.timetable.data.days) {
        if (!allDetected) {
          break;
        }
        for (final lesson in day.lessons) {
          if (!allDetected) {
            break;
          }
          for (final weekA in [true, false]) {
            if (TimetableSelection.get(lesson.block, weekA) == null) {
              allDetected = false;
              break;
            }
          }
        }
      }
      if (!allDetected) {
        await showDialog(
          context: context,
          builder: (context) => ScanDialog(
            teachers: Static.teachers.data,
            timetable: Static.timetable.data,
          ),
        );
      }
    }
  }

  /// Update all tokens
  static Future updateTokens(BuildContext context) async {
    if (Platform().isMobile || Platform().isWeb) {
      print(await Static.firebaseMessaging.getToken());
      await Static.firebaseMessaging.requestNotificationPermissions();
      final token = await Static.firebaseMessaging.getToken();
      if (token != 'null') {
        Static.device.object = Device(
          token: token,
          os: Platform().platformName,
          language: AppTranslations.of(context).locale.languageCode,
        );
        print('Updating tokens on server');
        try {
          await Static.device.loadOnline();
          // ignore: empty_catches
        } on DioError {}
      }
    }
  }

  static Future _handleForegroundNotification(
      BuildContext context, Map<String, dynamic> data) async {
    print(data);
    Scaffold.of(context).showSnackBar(SnackBar(
      action: Static.rebuildSubstitutionPlan == null
          ? SnackBarAction(
              label: AppTranslations.of(context).open,
              onPressed: () async {
                await Static.substitutionPlan.loadOnline();
                await Navigator.of(context)
                    .pushReplacementNamed('/substitutionplan');
              },
            )
          : null,
      content: Text(AppTranslations.of(context).newSubstitutionPlan),
    ));
    if (Static.rebuildSubstitutionPlan != null) {
      await Static.substitutionPlan.loadOnline();
      Static.rebuildSubstitutionPlan();
    }
  }

  @override
  Widget build(BuildContext context) => Header(
        pages: _pages,
        user: Static.user.data,
        initialPage: widget.initialPage,
      );
}
