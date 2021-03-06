import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ginko/aixformation/aixformation_utils.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/utils/theme.dart';
import 'package:models/models.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: public_member_api_docs
class AiXformationPost extends StatefulWidget {
  // ignore: public_member_api_docs
  const AiXformationPost({
    @required this.post,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Post post;

  @override
  _AiXformationPostState createState() => _AiXformationPostState();
}

class _AiXformationPostState extends State<AiXformationPost> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _loaded = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'AiXformation',
            style: TextStyle(
              color: textColor(context),
            ),
          ),
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(
                Icons.open_in_new,
                color: textColor(context),
              ),
              onPressed: () => launch(widget.post.url),
            ),
            if (Platform().isMobile)
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: textColor(context),
                ),
                onPressed: () {
                  Share.share(widget.post.url);
                },
              ),
          ],
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: widget.post.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: _controller.complete,
              onPageFinished: (url) {
                setState(() {
                  _loaded = true;
                });
              },
              gestureNavigationEnabled: true,
            ),
            if (!_loaded)
              Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: getLoadingPlaceholder(context),
                ),
              ),
          ],
        ),
      );
}
