import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ginko/aixformation/aixformation_post.dart';
import 'package:ginko/app/app_page.dart';
import 'package:ginko/cafetoria/cafetoria_page.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';

typedef FutureCallback = Future Function();

// ignore: public_member_api_docs
class NotificationsWidget extends StatefulWidget {
  // ignore: public_member_api_docs
  const NotificationsWidget({
    @required this.fetchData,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final FutureCallback fetchData;

  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget>
    with AfterLayoutMixin<NotificationsWidget> {
  DateTime _lastSnackbar;

  /// Register everything needed for notifications
  Future _registerNotifications(BuildContext context) async {
    if (Platform().isMobile || Platform().isWeb) {
      Static.firebaseMessaging.configure(
        onLaunch: (data) async {
          print('onLaunch: $data');
          await _backgroundNotification(context, data);
        },
        onResume: (data) async {
          print('onResume: $data');
          await _backgroundNotification(context, data);
        },
        onMessage: (data) async {
          print('onMessage: $data');
          await _foregroundNotification(context, data);
        },
      );
    }
    await updateTokens(context);
    if (Platform().isAndroid) {
      await MethodChannel('de.ginko').invokeMethod('channel_registered');
    }
  }

  Future _foregroundNotification(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    FutureCallback callback;
    String text;
    switch (data[Keys.type]) {
      case Keys.substitutionPlan:
        callback = _openSubstitutionPlan;
        text = 'Neuer Vertretungsplan';
        break;
      case Keys.cafetoria:
        callback = _openCafetoria;
        text = 'Neue Cafetoria-Menüs';
        break;
      case Keys.aiXformation:
        // ignore: missing_required_param
        callback = () async => _openAiXformation(Post(url: data['url']));
        text = 'Neuer AiXformation-Artikel';
        break;
    }
    if (_lastSnackbar == null ||
        DateTime.now().difference(_lastSnackbar).inSeconds > 3) {
      Scaffold.of(context).showSnackBar(SnackBar(
        action: SnackBarAction(
          label: 'Öffnen',
          onPressed: () async {
            await widget.fetchData();
            await callback();
          },
        ),
        content: Text(
          text,
          style: TextStyle(
            color: lightColor,
          ),
        ),
      ));
      _lastSnackbar = DateTime.now();
    }
  }

  Future _backgroundNotification(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    switch (data['type']) {
      case Keys.substitutionPlan:
        await widget.fetchData();
        await _openSubstitutionPlan();
        break;
      case Keys.cafetoria:
        await widget.fetchData();
        await _openCafetoria();
        break;
      case Keys.aiXformation:
        await widget.fetchData();
        // ignore: missing_required_param
        await _openAiXformation(Post(url: data['url']));
        break;
      default:
        print('Unknown key: ${data[Keys.type]}');
        break;
    }
  }

  Future _openSubstitutionPlan() =>
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AppPage(
          page: 0,
          loading: false,
        ),
      ));

  Future _openCafetoria() => Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CafetoriaPage(),
      ));

  Future _openAiXformation(Post post) =>
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AiXformationPost(
          post: post,
        ),
      ));

  @override
  Widget build(BuildContext context) => Container();

  @override
  void afterFirstLayout(BuildContext context) =>
      _registerNotifications(context);
}

/// Update all tokens
Future updateTokens(BuildContext context) async {
  final platformName = Platform().platformName;
  final version = await Static.releases.getCurrentAppVersion();
  var token = '';
  if ((Platform().isMobile || Platform().isWeb) &&
      await Static.firebaseMessaging.hasNotificationPermissions()) {
    token = await Static.firebaseMessaging.getToken();
  }
  if (token != '' && token != 'null') {
    Static.device.object = Device(
      token: token,
      os: platformName,
      version: version,
    );
    try {
      await Static.device.forceLoadOnline();
      // ignore: empty_catches
    } on DioError {}
  }
}
