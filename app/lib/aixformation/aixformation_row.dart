import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/aixformation/aixformation_post.dart';
import 'package:ginko/aixformation/aixformation_utils.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:models/models.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: public_member_api_docs
class AiXformationRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const AiXformationRow({
    @required this.post,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Post post;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AiXformationPost(
                post: post,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Platform().isWeb
                    ? Stack(
                        children: [
                          getLoadingPlaceholder(context),
                          FadeInImage.memoryNetwork(
                            height: 50,
                            width: 50,
                            placeholder: kTransparentImage,
                            image: post.thumbnailUrl,
                          ),
                        ],
                      )
                    : CachedNetworkImage(
                        imageUrl: post.thumbnailUrl,
                        placeholder: (context, url) =>
                            getLoadingPlaceholder(context),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black54,
                              size: 18,
                            ),
                            Container(
                              width: 5,
                              height: 1,
                              color: Colors.transparent,
                            ),
                            Text(
                              post.author ?? '',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.black54,
                              size: 18,
                            ),
                            Container(
                              width: 5,
                              height: 1,
                              color: Colors.transparent,
                            ),
                            Text(
                              outputDateFormat.format(post.date),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
