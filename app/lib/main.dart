import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ginko/loaders/loader.dart';
import 'package:ginko/pages/aixformation.dart';
import 'package:ginko/pages/cafetoria.dart';
import 'package:ginko/pages/choose.dart';
import 'package:ginko/pages/cloud.dart';
import 'package:ginko/pages/home.dart';
import 'package:ginko/pages/loading.dart';
import 'package:ginko/pages/login.dart';
import 'package:ginko/pages/settings.dart';
import 'package:ginko/pages/substitution_plan.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/storage/storage.dart';
import 'package:ginko/plugins/system_locale/system_locale.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:ginko/views/header.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:package_info/package_info.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

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
      '/choose': (context) => Scaffold(
            body: ChoosePage(),
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
  static final _channel = MethodChannel('de.ginko');

  final List<Page> _pages = [];

  @override
  Future afterFirstLayout(BuildContext context) async {
    setState(() {
      _pages.addAll(
        [
          Page(
            name: AppTranslations.of(context).pageStart,
            icon: Icons.home,
            child: HomePage(),
          ),
          Page(
            name: AppTranslations.of(context).pageSubstitutionPlan,
            icon: Icons.format_list_numbered,
            child: SubstitutionPlanPage(),
          ),
          Page(
            name: AppTranslations.of(context).pageCloud,
            icon: Icons.cloud,
            child: CloudPage(),
          ),
          Page(
            name: AppTranslations.of(context).pageCafetoria,
            icon: Icons.restaurant,
            child: CafetoriaPage(),
          ),
          Page(
            name: AppTranslations.of(context).pageAiXformation,
            icon: MdiIcons.newspaper,
            child: AiXformationPage(),
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
    if (Platform().isMobile || Platform().isWeb) {
      Static.firebaseMessaging.configure(
        onLaunch: (data) async {
          print('onLaunch: $data');
          await _backgroundNotification(data);
        },
        onResume: (data) async {
          print('onResume: $data');
          await _backgroundNotification(data);
        },
        onMessage: (data) async {
          print('onMessage: $data');
          await _foregroundNotification(data);
        },
      );
      await updateTokens(context);
    }
    if (Platform().isAndroid) {
      await _channel.invokeMethod('channel_registered');
    }
    if (Platform().isDesktop &&
        Version.parse(Static.releases.data.version) >
            Version.parse(await Static.releases.getCurrentAppVersion())) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 30),
        content: Text(AppTranslations.of(context).newAppVersionAvailable),
        action: SnackBarAction(
          label: AppTranslations.of(context).upgrade,
          onPressed: () {
            launch(Static.releases.data.url);
          },
        ),
      ));
    }
  }

  Future _foregroundNotification(Map<String, dynamic> data) async {
    FutureCallbackShouldRender refreshCallback;
    Loader loader;
    String route;
    String text;
    switch (data[Keys.type]) {
      case Keys.substitutionPlan:
        refreshCallback = Static.refreshSubstitutionPlan;
        loader = Static.substitutionPlan;
        route = '/substitutionplan';
        text = AppTranslations.of(context).newSubstitutionPlan;
        break;
      case Keys.cafetoria:
        refreshCallback = Static.refreshCafetoria;
        loader = Static.cafetoria;
        route = '/cafetoria';
        text = AppTranslations.of(context).newCafetoria;
        break;
      case Keys.aiXformation:
        refreshCallback = Static.refreshAiXformation;
        loader = Static.aiXformation;
        route = '/aixformation';
        text = AppTranslations.of(context).newAiXformationArticle;
        break;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      action: refreshCallback == null
          ? SnackBarAction(
              label: AppTranslations.of(context).open,
              onPressed: () async {
                await loader.forceLoadOnline();
                await Navigator.of(context).pushReplacementNamed(route);
              },
            )
          : null,
      content: Text(text),
    ));
    if (refreshCallback != null) {
      await refreshCallback(true);
    }
  }

  Future _backgroundNotification(Map<String, dynamic> data) async {
    switch (data['type']) {
      case Keys.substitutionPlan:
        await Static.substitutionPlan.forceLoadOnline();
        await Navigator.of(context).pushReplacementNamed('/substitutionplan');
        break;
      case Keys.cafetoria:
        await Static.cafetoria.forceLoadOnline();
        await Navigator.of(context).pushReplacementNamed('/cafetoria');
        break;
      case Keys.aiXformation:
        await Static.aiXformation.forceLoadOnline();
        await Navigator.of(context).pushReplacementNamed('/aixformation');
        break;
      default:
        print('Unknown key: ${data['type']}');
        break;
    }
  }

  /// Update all tokens
  static Future updateTokens(BuildContext context) async {
    if ((Platform().isMobile || Platform().isWeb) &&
        await Static.firebaseMessaging.hasNotificationPermissions()) {
      final token = await Static.firebaseMessaging.getToken();
      if (token != 'null') {
        final packageInfo = await PackageInfo.fromPlatform();
        Static.device.object = Device(
          token: token,
          os: Platform().platformName,
          language: AppTranslations.of(context).locale.languageCode,
          version: '${packageInfo.version}+${packageInfo.buildNumber}',
        );
        try {
          await Static.device.forceLoadOnline();
          // ignore: empty_catches
        } on DioError {}
      }
    }
  }

  @override
  Widget build(BuildContext context) => Header(
        pages: _pages,
        user: Static.user.data,
        initialPage: widget.initialPage,
      );
}
