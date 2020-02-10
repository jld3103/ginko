import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ginko/utils/custom_button.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

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
    _substitutionPlanNotifications = Static.settings.data
        .getSettings(Keys.substitutionPlanNotifications, true);
    _aiXformationNotifications =
        Static.settings.data.getSettings(Keys.aiXformationNotifications, true);
    _cafetoriaNotifications =
        Static.settings.data.getSettings(Keys.cafetoriaNotifications, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Einstellungen'),
          elevation: 2,
        ),
        body: Center(
          child: SizeLimit(
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(5),
                children: [
                  CheckboxListTile(
                    title: Text('Vertretungsplanbenachrichtigungen anzeigen'),
                    value: _substitutionPlanNotifications,
                    onChanged: (value) async {
                      setState(() {
                        _substitutionPlanNotifications = value;
                        Static.settings.data.setSettings(
                            Keys.substitutionPlanNotifications, value);
                        Static.settings.save();
                      });
                      try {
                        await Static.settings.forceLoadOnline();
                        // ignore: empty_catches
                      } on DioError {}
                    },
                  ),
                  CheckboxListTile(
                    title: Text('AiXformation-Benachrichtigungen anzeigen'),
                    value: _aiXformationNotifications,
                    onChanged: (value) async {
                      setState(() {
                        _aiXformationNotifications = value;
                        Static.settings.data
                            .setSettings(Keys.aiXformationNotifications, value);
                        Static.settings.save();
                      });
                      try {
                        await Static.settings.forceLoadOnline();
                        // ignore: empty_catches
                      } on DioError {}
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Cafétoria-Benachrichtigungen anzeigen'),
                    value: _cafetoriaNotifications,
                    onChanged: (value) async {
                      setState(() {
                        _cafetoriaNotifications = value;
                        Static.settings.data
                            .setSettings(Keys.cafetoriaNotifications, value);
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
                      child: CustomButton(
                        onPressed: () {
                          Static.user.clear();
                          Static.device.clear();
                          Static.selection.clear();
                          Static.updates.clear();
                          Static.settings.clear();
                          Static.substitutionPlan.clear();
                          Static.timetable.clear();
                          Static.calendar.clear();
                          Static.aiXformation.clear();
                          Static.cafetoria.clear();
                          Static.releases.clear();
                          Static.subjects.clear();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Text('Abmelden'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
