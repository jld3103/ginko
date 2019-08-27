import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:translations/translations_app.dart';

/// Loading class
/// describes the loading widget
class Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

/// LoadingState class
/// describes the state of the loading widget
class LoadingState extends State<Loading> {
  @override
  void initState() {
    Data.setup(443, 'api.app.viktoria.schule', 'https');
    Data.load().then((code) {
      if (code == ErrorCode.wrongCredentials) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      while (!mounted) {}
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Platform().isAndroid
      ? Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: SvgPicture.asset('images/logo_green.svg'),
          ),
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Text(AppTranslations.of(context).loadingTitle),
                  ],
                ),
              ),
            ],
          ),
        );
}
