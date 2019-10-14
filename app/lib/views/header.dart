import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/main.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/pwa/pwa.dart';
import 'package:models/models.dart';

/// Header class
/// renders the app bar
class Header extends StatefulWidget {
  // ignore: public_member_api_docs
  const Header({
    @required this.pages,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final List<Page> pages;

  // ignore: public_member_api_docs
  final User user;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int _page = 0;
  bool _permissionsGranted = true;
  bool _permissionsChecking = false;
  bool _canInstall = false;
  bool _installing = false;
  PWA _pwa;

  @override
  void initState() {
    _pwa = PWA();
    if (Platform().isWeb) {
      WidgetsBinding.instance.addPostFrameCallback((a) async {
        _permissionsGranted =
            await Data.firebaseMessaging.hasNotificationPermissions();
        _canInstall = await _pwa.canInstall();
        setState(() {});
      });
    }
    super.initState();
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
                    await AppState.updateTokens(context);
                    _permissionsGranted = await Data.firebaseMessaging
                        .hasNotificationPermissions();
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
                    _canInstall = await _pwa.canInstall();
                    setState(() {
                      _installing = false;
                    });
                  },
                  child: Icon(
                    Icons.file_download,
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
                          height: 109,
                          margin: EdgeInsets.only(bottom: 5),
                          child: SvgPicture.asset('images/logo_white.svg'),
                        ),
                        Text(
                          widget.user.grade.value,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
