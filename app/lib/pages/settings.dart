import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/utils/settings.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// SettingsPage class
/// describes the Settings widget
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _substitutionPlanNotifications;
  bool _aiXformationNotifications;
  bool _cafetoriaNotifications;

  @override
  void initState() {
    _substitutionPlanNotifications =
        AppSettings.get(Keys.substitutionPlanNotifications, true);
    _aiXformationNotifications =
        AppSettings.get(Keys.aiXformationNotifications, true);
    _cafetoriaNotifications =
        AppSettings.get(Keys.cafetoriaNotifications, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: SizeLimit(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            children: [
              CheckboxListTile(
                title: Text(AppTranslations.of(context)
                    .settingsShowSubstitutionPlanNotifications),
                value: _substitutionPlanNotifications,
                onChanged: (value) async {
                  setState(() {
                    _substitutionPlanNotifications = value;
                    AppSettings.set(
                      Keys.substitutionPlanNotifications,
                      value,
                    );
                    Static.settings.save();
                  });
                  try {
                    await Static.settings.forceLoadOnline();
                    // ignore: empty_catches
                  } on DioError {}
                },
              ),
              CheckboxListTile(
                title: Text(AppTranslations.of(context)
                    .settingsShowAiXformationNotifications),
                value: _aiXformationNotifications,
                onChanged: (value) async {
                  setState(() {
                    _aiXformationNotifications = value;
                    AppSettings.set(
                      Keys.aiXformationNotifications,
                      value,
                    );
                    Static.settings.save();
                  });
                  try {
                    await Static.settings.forceLoadOnline();
                    // ignore: empty_catches
                  } on DioError {}
                },
              ),
              CheckboxListTile(
                title: Text(AppTranslations.of(context)
                    .settingsShowCafetoriaNotifications),
                value: _cafetoriaNotifications,
                onChanged: (value) async {
                  setState(() {
                    _cafetoriaNotifications = value;
                    AppSettings.set(
                      Keys.cafetoriaNotifications,
                      value,
                    );
                    Static.settings.save();
                  });
                  try {
                    await Static.settings.forceLoadOnline();
                    // ignore: empty_catches
                  } on DioError {}
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      // ignore: missing_required_param
                      Static.user.object = null;
                      Static.user.save();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    child: Text(AppTranslations.of(context).settingsLogout),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
