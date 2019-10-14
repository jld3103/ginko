import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ginko/aixformation.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:models/models.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// AiXformationPost class
/// describes the AiXformation post widget
class AiXformationPost extends StatelessWidget {
  // ignore: public_member_api_docs
  const AiXformationPost({
    @required this.post,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Post post;

  // ignore: public_member_api_docs
  final User user;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizeLimit(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 12,
                    ),
                    Container(
                      width: 5,
                      height: 1,
                      color: Colors.transparent,
                    ),
                    Text(
                      post.author ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 1,
                      color: Colors.transparent,
                    ),
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 12,
                    ),
                    Container(
                      width: 5,
                      height: 1,
                      color: Colors.transparent,
                    ),
                    Text(
                      outputDateFormat(user.language.value).format(post.date),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Platform().isWeb
                      ? Stack(
                          children: [
                            AiXformationPage.getLoadingPlaceholder(context),
                            FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: post.fullUrl,
                            ),
                          ],
                        )
                      : CachedNetworkImage(
                          imageUrl: post.fullUrl,
                          placeholder: (context, url) =>
                              AiXformationPage.getLoadingPlaceholder(context),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                ),
              ],
            ),
          ),
          Center(
            child: SizeLimit(
              child: Html(
                data: post.content,
                onLinkTap: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw Exception('Could not launch $url');
                  }
                },
                onImageTap: (src) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(),
                      body: Center(
                        child: CachedNetworkImage(
                          imageUrl: src,
                          placeholder: (context, url) => Container(
                            height: 56,
                            width: 56,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ));
                },
              ),
            ),
          ),
        ],
      );
}
