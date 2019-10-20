import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ginko/pages/aixformation.dart';
import 'package:ginko/pages/cafetoria.dart';
import 'package:ginko/pages/home.dart';
import 'package:ginko/pages/loading.dart';
import 'package:ginko/pages/login.dart';
import 'package:ginko/pages/replacementplan.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/pwa/pwa.dart';
import 'package:ginko/plugins/storage/storage.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/selection.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:ginko/views/header.dart';
import 'package:ginko/views/unitplan/scan.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_app.dart';

Future main() async {
  if (Platform().isDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  WidgetsFlutterBinding.ensureInitialized();

  if (!await PWA().navigateLoadingIfNeeded()) {
    Static.storage = Storage();
    await Static.storage.init();

    runApp(MaterialApp(
      title: 'Ginko',
      theme: theme,
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
        '/replacementplan': (context) => Scaffold(
              body: App(
                initialPage: 1,
              ),
            ),
        '/cafetoria': (context) => Scaffold(
              body: App(
                initialPage: 2,
              ),
            ),
        '/aixformation': (context) => Scaffold(
              body: App(
                initialPage: 3,
              ),
            ),
      },
    ));
  }
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
              user: Data.user,
              unitPlan: Data.unitPlan,
              replacementPlan: Data.replacementPlan,
              calendar: Data.calendar,
              cafetoria: Data.cafetoria,
              updateUser: Data.updateUser,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageReplacementPlan,
            icon: Icons.format_list_numbered,
            child: ReplacementPlanPage(
              user: Data.user,
              replacementPlan: Data.replacementPlan,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageCafetoria,
            icon: Icons.restaurant,
            child: CafetoriaPage(
              user: Data.user,
              cafetoria: Data.cafetoria,
            ),
          ),
          Page(
            name: AppTranslations.of(context).pageAiXformation,
            icon: MdiIcons.newspaper,
            child: AiXformationPage(
              user: Data.user,
              posts: Data.posts,
            ),
          ),
        ],
      );
    });
    if (!Data.online) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(AppTranslations.of(context).homeOffline),
      ));
    }
    if (Platform().isMobile) {
      await updateTokens(context);
    }
    Data.firebaseMessaging.configure(
      onLaunch: (data) async => _handleForegroundNotification(context, data),
      onResume: (data) async => _handleForegroundNotification(context, data),
      onMessage: (data) async => _handleForegroundNotification(context, data),
    );
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'background_notification') {
        await Data.load();
        await Navigator.of(context).pushReplacementNamed('/replacementplan');
      } else if (call.method == 'foreground_notification') {
        await _handleForegroundNotification(
            context, json.decode(json.encode(call.arguments)));
      }
    });
    if (Platform().isAndroid) {
      await _channel.invokeMethod('channel_registered');
    }

    // Ask for scan
    if (isSeniorGrade(Data.user.grade.value) &&
        Platform().isMobile &&
        !(Static.storage.getBool(Keys.askedForScan) ?? false)) {
      Static.storage.setBool(Keys.askedForScan, true);
      var allDetected = true;
      for (final day in Data.unitPlan.days) {
        if (!allDetected) {
          break;
        }
        for (final lesson in day.lessons) {
          if (!allDetected) {
            break;
          }
          for (final weekA in [true, false]) {
            if (Selection.get(lesson.block, weekA) == null) {
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
            teachers: Data.teachers,
            unitPlan: Data.unitPlan,
          ),
        );
      }
    }
  }

  /// Update all tokens
  static Future updateTokens(BuildContext context) async {
    if (Platform().isMobile || Platform().isWeb) {
      final gotNullToken = await Data.firebaseMessaging.getToken() == 'null';
      await Data.firebaseMessaging.requestNotificationPermissions();

      // If the notification permissions were previously not granted
      // (means getting null as token) then get the token again and push it
      // to the server
      if (gotNullToken) {
        print('Got a token after requesting permissions');
        print('Updating tokens on server');
        await Data.updateUser();
      }
    }
  }

  static Future _handleForegroundNotification(
      BuildContext context, Map<String, dynamic> data) async {
    print(data);
    Scaffold.of(context).showSnackBar(SnackBar(
      action: Static.rebuildReplacementPlan == null
          ? SnackBarAction(
              label: AppTranslations.of(context).open,
              onPressed: () async {
                await Data.load();
                await Navigator.of(context)
                    .pushReplacementNamed('/replacementplan');
              },
            )
          : null,
      content: Text(AppTranslations.of(context).newReplacementPlan),
    ));
    if (Static.rebuildReplacementPlan != null) {
      await Data.load();
      Static.rebuildReplacementPlan();
    }
  }

  @override
  Widget build(BuildContext context) => Header(
        pages: _pages,
        user: Data.user,
        initialPage: widget.initialPage,
      );
}
