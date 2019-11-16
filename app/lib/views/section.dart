import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: public_member_api_docs
class Section extends StatefulWidget {
  // ignore: public_member_api_docs
  const Section({
    @required this.children,
    @required this.title,
    this.margin = 10.0,
    this.paddingTop = 10.0,
    this.paddingBottom = 20.0,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final List<Widget> children;

  // ignore: public_member_api_docs
  final String title;

  // ignore: public_member_api_docs

  // ignore: public_member_api_docs
  final double margin;

  // ignore: public_member_api_docs
  final double paddingTop;

  // ignore: public_member_api_docs
  final double paddingBottom;

  @override
  _SectionState createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(widget.margin),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(widget.title),
              ),
              Container(
                  padding: EdgeInsets.only(
                    top: widget.paddingTop,
                    bottom: widget.paddingBottom,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // List of items
                  child: Column(
                    children: widget.children,
                  )),
            ],
          ),
        ),
      );
}
