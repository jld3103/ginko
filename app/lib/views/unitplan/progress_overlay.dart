import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// UnitPlanProgressRowOverlay class
class UnitPlanProgressRowOverlay extends StatelessWidget {
  // ignore: public_member_api_docs
  const UnitPlanProgressRowOverlay({
    @required this.height,
    @required this.progress,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final double height;

  // ignore: public_member_api_docs
  final double progress;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: height * (1 - progress)),
        child: Container(
          color: Colors.black.withOpacity(0.15),
        ),
      );
}
