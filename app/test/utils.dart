import 'package:ginko/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:translations/translations_app.dart';

Widget makeTestableWidget(Widget child) => MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        theme: theme,
        localizationsDelegates: [
          AppTranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: child,
      ),
    );

// ignore: avoid_annotating_with_dynamic
typedef DataCallback = void Function(dynamic data);

class DialogTester extends StatefulWidget {
  const DialogTester(this.dialog, {@required this.dataCallback, Key key})
      : super(key: key);

  final Widget dialog;

  final DataCallback dataCallback;

  @override
  _DialogTesterState createState() => _DialogTesterState();
}

class _DialogTesterState extends State<DialogTester> {
  dynamic _data;

  dynamic get data => _data;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (a) => showDialog(
        context: context,
        builder: (context) => widget.dialog,
      ).then(widget.dataCallback),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container();
}
