import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/choose/choose_row.dart';
import 'package:ginko/choose/choose_utils.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  // ignore: lines_longer_than_80_chars
                  'Du kannst entweder die Desktopanwendung herunterladen oder dich anmelden und die Ginko App als Webseite nutzen',
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
                                          .where(
                                              (asset) => getOS(asset) != null)
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
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              },
                              child: Text('Anmelden'),
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
        ),
      );
}
