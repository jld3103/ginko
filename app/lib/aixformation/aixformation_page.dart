import 'package:flutter/material.dart';
import 'package:ginko/aixformation/aixformation_row.dart';
import 'package:ginko/utils/size_limit.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/utils/theme.dart';

// ignore: public_member_api_docs
class AiXformationPage extends StatelessWidget {
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
        ),
        body: Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: Static.aiXformation.data.posts
                .map((post) => Center(
                      child: SizeLimit(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: AiXformationRow(
                            post: post,
                          ),
                        ),
                      ),
                    ))
                .toList()
                .cast<Widget>(),
          ),
        ),
      );
}
