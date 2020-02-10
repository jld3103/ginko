import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/utils/static.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

// ignore: public_member_api_docs
class UpdatesWidget extends StatefulWidget {
  @override
  _UpdatesWidgetState createState() => _UpdatesWidgetState();
}

class _UpdatesWidgetState extends State<UpdatesWidget>
    with AfterLayoutMixin<UpdatesWidget> {
  @override
  Future afterFirstLayout(BuildContext context) async {
    final platform = Platform();
    if ((platform.isDesktop || platform.isAndroid) &&
        Static.releases.data != null &&
        Version.parse(Static.releases.data.version) >
            Version.parse(await Static.releases.getCurrentAppVersion())) {
      print('An update should be available');
      if (platform.isAndroid) {
        final appUpdateInfo = await InAppUpdate.checkForUpdate();
        if (appUpdateInfo.updateAvailable &&
            appUpdateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate().then((_) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erfolgreich aktualisiert'),
                ),
              );
            });
          });
        }
      }
      if (platform.isDesktop) {
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 30),
          content: Text('Eine neue App-Version ist verfügbar'),
          action: SnackBarAction(
            label: 'Aktualisieren',
            onPressed: () {
              launch(Static.releases.data.url);
            },
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container();
}
