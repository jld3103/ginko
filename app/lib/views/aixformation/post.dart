import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';

/// AiXformationPost class
/// describes the AiXformation post widget
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
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  widget.post.title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 12,
                    ),
                    Text(
                      widget.post.author,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 1,
                      color: Colors.transparent,
                    ),
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 12,
                    ),
                    Text(
                      outputDateFormat.format(widget.post.date),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.fullUrl,
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
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
          Html(
            data: widget.post.content,
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ));
            },
          ),
        ],
      );
}
