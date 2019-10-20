import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/views/aixformation/post.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:models/models.dart';
import 'package:share/share.dart';
import 'package:translations/translations_app.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// AiXformationPage class
/// describes the AiXformation widget
class AiXformationPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const AiXformationPage({
    @required this.posts,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Posts posts;

  // ignore: public_member_api_docs
  final User user;

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        children: posts.posts
            .map(
              (post) => SizeLimit(
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text(
                              AppTranslations.of(context).pageAiXformation,
                            ),
                            actions: [
                              IconButton(
                                icon: Icon(Icons.open_in_new),
                                onPressed: () async {
                                  final url = post.url;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                              ),
                              if (Platform().isMobile)
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {
                                    Share.share(post.url);
                                  },
                                ),
                            ],
                          ),
                          body: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            children: [
                              AiXformationPost(
                                post: post,
                                user: user,
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                        leading: Platform().isWeb
                            ? Stack(
                                children: [
                                  getLoadingPlaceholder(context),
                                  FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: post.thumbnailUrl,
                                  ),
                                ],
                              )
                            : CachedNetworkImage(
                                imageUrl: post.thumbnailUrl,
                                placeholder: (context, url) =>
                                    getLoadingPlaceholder(context),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                        title: Text(
                          post.title,
                        ),
                        subtitle: Column(
                          children: [
                            Row(
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
                              ],
                            ),
                            Row(
                              children: [
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
                                  outputDateFormat(user.language.value)
                                      .format(post.date),
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList()
            .cast<Widget>(),
      );

  // ignore: public_member_api_docs
  static Widget getLoadingPlaceholder(BuildContext context) => Container(
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
      );
}
