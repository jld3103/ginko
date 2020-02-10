import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: public_member_api_docs
class ListGroupHeader extends StatelessWidget {
  // ignore: public_member_api_docs
  const ListGroupHeader({
    @required this.title,
    @required this.children,
    this.center = false,
    this.counter = 0,
    this.onTap,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final String title;

  // ignore: public_member_api_docs
  final List<Widget> children;

  // ignore: public_member_api_docs
  final bool center;

  // ignore: public_member_api_docs
  final int counter;

  // ignore: public_member_api_docs
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          bottom: 10,
          left: 5,
          right: 5,
          top: 5,
        ),
        child: Card(
          elevation: 3,
          child: Column(
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  height: TabBar(
                    tabs: const [],
                  ).preferredSize.height,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ),
                      if (counter > 0)
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(right: 9),
                            child: Text(
                              '+${counter >= 10 ? counter : '$counter '}',
                              style: GoogleFonts.ubuntuMono(
                                fontSize: 20,
                                textStyle: TextStyle(
                                  color: textColor(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ...children,
            ],
          ),
        ),
      );
}
