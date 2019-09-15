import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/utils/data.dart';
import 'package:ginko/utils/platform/platform.dart';
import 'package:ginko/views/aixformation/post.dart';
import 'package:models/models.dart';
import 'package:share/share.dart';
import 'package:translations/translations_app.dart';
import 'package:url_launcher/url_launcher.dart';

/// AiXformation class
/// describes the AiXformation widget
class AiXformation extends StatefulWidget {
  @override
  _AiXformationState createState() => _AiXformationState();
}

class _AiXformationState extends State<AiXformation> {
  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        children: Data.posts.posts
            .map((post) => Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Text(
                              AppTranslations.of(context).pageAiXformation,
                            ),
                            actions: <Widget>[
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
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: post.thumbnailUrl,
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
                                Text(
                                  post.author,
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
                                Text(
                                  outputDateFormat.format(post.date),
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
                ))
            .toList()
            .cast<Widget>(),
      );
}
