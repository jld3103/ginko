import 'package:flutter/material.dart';

// ignore: public_member_api_docs, must_be_immutable
class CustomLinearProgressIndicator extends SizedBox
    implements PreferredSizeWidget {
  // ignore: public_member_api_docs
  CustomLinearProgressIndicator({
    Key key,
    Color backgroundColor,
  }) : super(
          key: key,
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: backgroundColor,
          ),
        );

  @override
  Size preferredSize = Size(double.infinity, 3);
}
