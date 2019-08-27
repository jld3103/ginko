import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ginko/home.dart';
import 'package:ginko/loading.dart';
import 'package:ginko/login.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/storage/storage.dart';
import 'package:ginko/utils/theme.dart';
import 'package:translations/translation_locales_list.dart';
import 'package:translations/translations_app.dart';

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
    localizationsDelegates: [
      AppTranslationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales:
        LocalesList.locales.map((locale) => Locale(locale)).toList(),
    initialRoute: '/loading',
    routes: <String, WidgetBuilder>{
      '/': (context) => Container(),
      '/loading': (context) => Scaffold(body: Loading()),
      '/login': (context) => Scaffold(body: Login()),
      '/home': (context) => Scaffold(body: Home()),
    },
  ));
}
