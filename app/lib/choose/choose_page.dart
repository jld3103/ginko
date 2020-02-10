import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/choose/choose_row.dart';
import 'package:ginko/choose/choose_utils.dart';
import 'package:ginko/utils/custom_button.dart';
import 'package:ginko/utils/custom_circular_progress_indicator.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: public_member_api_docs
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
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => launch(
                            'https://play.google.com/store/apps/details?id=de.ginko'),
                        child: Image.network(
                          'https://play.google.com/intl/en_us/badges/static/images/badges/de_badge_web_generic.png',
                          height: 100,
                        ),
                      ),
                      _loginButton,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // ignore: lines_longer_than_80_chars
                        'Du kannst entweder die Desktopanwendung herunterladen oder dich anmelden und die Ginko App als Webseite nutzen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textColor(context),
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
                                        CustomCircularProgressIndicator(),
                                      if (_release != null)
                                        ...(_release.assets
                                                .where((asset) =>
                                                    getOS(asset) != null)
                                                .toList()
                                                  ..sort((a, b) => getOS(a)
                                                      .index
                                                      .compareTo(
                                                          getOS(b).index)))
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
                                child: _loginButton,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );

  Widget get _loginButton => CustomButton(
        margin: EdgeInsets.all(10),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: Text(
          'Anmelden',
          style: TextStyle(
            color: darkColor,
          ),
        ),
      );
}
