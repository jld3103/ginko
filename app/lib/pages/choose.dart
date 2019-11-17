import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/choose/row.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:translations/translations_app.dart';

/// ChoosePage class
/// describes the Choose widget
class ChoosePage extends StatefulWidget {
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage>
    with AfterLayoutMixin<ChoosePage> {
  Release _release;

  @override
  void afterFirstLayout(BuildContext context) {
    Static.releases.forceLoadOnline().then((ok) {
      setState(() {
        _release = Static.releases.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                AppTranslations.of(context).chooseTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizeLimit(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_release == null)
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              if (_release != null)
                                ...(_release.assets
                                        .where((asset) => getOS(asset) != null)
                                        .toList()
                                          ..sort((a, b) => getOS(a)
                                              .index
                                              .compareTo(getOS(b).index)))
                                    .map((asset) => ChooseRow(
                                          asset: asset,
                                        ))
                                    .cast<Widget>()
                                    .toList(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            child:
                                Text(AppTranslations.of(context).loginSubmit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

// ignore: public_member_api_docs
enum OS {
  // ignore: public_member_api_docs
  linux,
  // ignore: public_member_api_docs
  mac,
  // ignore: public_member_api_docs
  windows,
}

// ignore: public_member_api_docs
String getFileExtension(Asset asset) => asset.name.split('.').last;

// ignore: public_member_api_docs
OS getOS(Asset asset) {
  if (getFileExtension(asset) == 'AppImage' ||
      getFileExtension(asset) == 'deb' ||
      getFileExtension(asset) == 'rpm' ||
      getFileExtension(asset) == 'snap') {
    return OS.linux;
  } else if (getFileExtension(asset) == 'dmg' ||
      getFileExtension(asset) == 'pkg') {
    return OS.mac;
  } else if (getFileExtension(asset) == 'msi') {
    return OS.windows;
  } else {
    return null;
  }
}

// ignore: public_member_api_docs
IconData getOSIcon(Asset asset) => getOS(asset) == OS.linux
    ? MdiIcons.linux
    : getOS(asset) == OS.mac ? MdiIcons.apple : MdiIcons.windows;

// ignore: public_member_api_docs
String getOSName(Asset asset) => getOS(asset) == OS.linux
    ? 'Linux'
    : getOS(asset) == OS.mac ? 'Mac' : 'Windows';
