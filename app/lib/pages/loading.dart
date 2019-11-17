import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// LoadingPage class
/// describes the loading widget
class LoadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingPageState();
}

/// LoadingPageState class
/// describes the state of the loading widget
class LoadingPageState extends State<LoadingPage>
    with AfterLayoutMixin<LoadingPage> {
  @override
  Future afterFirstLayout(BuildContext context) async {
    try {
      Static.user.loadOffline();
      Static.device.loadOffline();
      Static.device.object = Device(
        token: Static.device.data == null ? '' : Static.device.data.token,
        os: Platform().platformName,
        language: AppTranslations.of(context).locale.languageCode,
      );
      Static.selection.loadOffline();
      if (Static.selection.data == null) {
        Static.selection.object = Selection([]);
      }
      Static.updates.loadOffline();
      if (Static.updates.data == null) {
        Static.updates.object = {};
      }
      Static.settings.loadOffline();
      if (Static.settings.data == null) {
        Static.settings.object = Settings([]);
      }
      Static.substitutionPlan.loadOffline();
      Static.timetable.loadOffline();
      Static.calendar.loadOffline();
      Static.teachers.loadOffline();
      Static.aiXformation.loadOffline();
      Static.cafetoria.loadOffline();
      Static.releases.loadOffline();
      final credentialsCorrect = await Static.user.forceLoadOnline();
      if (credentialsCorrect) {
        try {
          final storedUpdates = Static.updates.data;
          await Static.updates.forceLoadOnline();
          final fetchedUpdates = Static.updates.data;
          Static.updates.object = storedUpdates;
          for (final key in fetchedUpdates.keys) {
            if (fetchedUpdates[key] != storedUpdates[key]) {
              print('Updating $key');
              switch (key) {
                case Keys.substitutionPlan:
                  await Static.substitutionPlan.loadOnline();
                  break;
                case Keys.timetable:
                  await Static.timetable.loadOnline();
                  break;
                case Keys.calendar:
                  await Static.calendar.loadOnline();
                  break;
                case Keys.teachers:
                  await Static.teachers.loadOnline();
                  break;
                case Keys.aiXformation:
                  await Static.aiXformation.loadOnline();
                  break;
                case Keys.cafetoria:
                  await Static.cafetoria.loadOnline();
                  break;
                case Keys.releases:
                  await Static.releases.loadOnline();
                  break;
                default:
                  print('unknown loader $key');
                  break;
              }
              Static.updates.data[key] = fetchedUpdates[key];
            }
          }
          await Static.selection.forceLoadOnline();
          await Static.settings.forceLoadOnline();
          if (Static.device.data.token != '') {
            await Static.device.forceLoadOnline();
          }
          // ignore: empty_catches
        } on DioError {}
        await Navigator.of(context).pushReplacementNamed('/home');
      } else {
        if (getScreenSize(MediaQuery.of(context).size.width) !=
                ScreenSize.small &&
            Platform().isWeb) {
          await Navigator.of(context).pushReplacementNamed('/choose');
        } else {
          await Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } on DioError {
      await Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) => Platform().isAndroid
      ? Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: SvgPicture.asset('images/logo_green.svg'),
          ),
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(AppTranslations.of(context).loadingTitle),
                  ],
                ),
              ),
            ],
          ),
        );
}
