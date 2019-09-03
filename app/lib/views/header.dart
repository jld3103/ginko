import 'package:flutter/material.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/utils/screen_sizes.dart';
import 'package:translations/translations_app.dart';

/// Header class
/// renders the app bar
class Header extends StatelessWidget {
  // ignore: public_member_api_docs
  const Header({
    @required this.child,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: Platform().isWeb &&
                getScreenSize(MediaQuery.of(context).size.width) ==
                    ScreenSize.small
            ? null
            : AppBar(
                title: Text(AppTranslations.of(context).appName),
                elevation: 0,
              ),
        body: child,
      );
}
