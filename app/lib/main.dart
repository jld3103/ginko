import 'package:app/home.dart';
import 'package:app/loading.dart';
import 'package:app/login.dart';
import 'package:app/utils/localizations.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  await Storage.init();

  runApp(MaterialApp(
    title: 'Ginko',
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF64A441),
      accentColor: Color(0xFF5BC638),
      fontFamily: 'Roboto',
    ),
    localizationsDelegates: [
      AppLocalizationDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('de'),
    ],
    initialRoute: '/loading',
    routes: <String, WidgetBuilder>{
      '/': (context) => Container(),
      '/loading': (context) => Scaffold(body: Loading()),
      '/login': (context) => Scaffold(body: Login()),
      '/home': (context) => Scaffold(body: Home()),
    },
  ));
}
