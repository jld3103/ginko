import 'package:flutter/material.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:ginko/utils/svg/svg.dart';

/// Header class
/// renders the app bar
class Header extends StatefulWidget {
  // ignore: public_member_api_docs
  const Header({
    @required this.pages,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final List<Page> pages;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int _page = 0;

  @override
  Widget build(BuildContext context) => _page + 1 > widget.pages.length
      ? Container()
      : Scaffold(
          appBar: Platform().isWeb &&
                  getScreenSize(MediaQuery.of(context).size.width) ==
                      ScreenSize.small
              ? null
              : AppBar(
                  title: Text(widget.pages[_page].name),
                  elevation: 0,
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
                          Data.user.grade.value,
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
