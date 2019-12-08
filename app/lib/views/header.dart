import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/main.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/pwa/pwa.dart';
import 'package:ginko/utils/static.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';

/// Header class
/// renders the app bar
class Header extends StatefulWidget {
  // ignore: public_member_api_docs
  const Header({
    @required this.pages,
    @required this.user,
    this.initialPage = 0,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final List<Page> pages;

  // ignore: public_member_api_docs
  final User user;

  // ignore: public_member_api_docs
  final int initialPage;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with AfterLayoutMixin<Header> {
  int _page = 0;
  bool _permissionsGranted = true;
  bool _permissionsChecking = false;
  bool _canInstall = false;
  bool _installing = false;
  PWA _pwa;

  @override
  Future afterFirstLayout(BuildContext context) async {
    setState(() {
      _page = widget.initialPage;
    });
    _pwa = PWA();
    if (Platform().isWeb) {
      _permissionsGranted =
          await Static.firebaseMessaging.hasNotificationPermissions();
      _canInstall = _pwa.canInstall();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => _page + 1 > widget.pages.length
      ? Container()
      : Scaffold(
          appBar: AppBar(
            title: Text(widget.pages[_page].name),
            elevation: 0,
            actions: [
              if (_permissionsChecking)
                FlatButton(
                  onPressed: () {},
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              if (!_permissionsGranted && !_permissionsChecking)
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      _permissionsChecking = true;
                    });
                    _permissionsGranted = await Static.firebaseMessaging
                        .requestNotificationPermissions();
                    await AppState.updateTokens(context);
                    setState(() {
                      _permissionsChecking = false;
                    });
                  },
                  child: Icon(
                    Icons.notifications_off,
                    color: Colors.white,
                  ),
                ),
              if (_installing)
                FlatButton(
                  onPressed: () {},
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              if (_canInstall && !_installing)
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      _installing = true;
                    });
                    await _pwa.install();
                    _canInstall = _pwa.canInstall();
                    setState(() {
                      _installing = false;
                    });
                  },
                  child: Icon(
                    MdiIcons.cellphoneArrowDown,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 111,
                          margin: EdgeInsets.only(bottom: 5),
                          child: SvgPicture.asset('images/logo_white.svg'),
                        ),
                        Text(
                          '${widget.user.fullName} - ${widget.user.grade}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                for (final page in widget.pages)
                  ListTile(
                    leading: Icon(
                      page.icon,
                      color: Colors.black,
                    ),
                    title: Text(page.name),
                    onTap: () {
                      setState(() {
                        _page = widget.pages.indexOf(page);
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
          body: widget.pages[_page].child,
        );
}

// ignore: public_member_api_docs
class Page {
  // ignore: public_member_api_docs
  Page({
    @required this.name,
    @required this.icon,
    @required this.child,
  });

  // ignore: public_member_api_docs
  final Widget child;

  // ignore: public_member_api_docs
  final IconData icon;

  // ignore: public_member_api_docs
  final String name;
}
