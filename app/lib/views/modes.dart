import 'package:flutter/material.dart';

typedef Builder = Widget Function(BuildContext context, int index);

/// PageMode class
/// renders days as pages
class PageMode extends StatefulWidget {
  // ignore: public_member_api_docs
  const PageMode(this.builder);

  // ignore: public_member_api_docs
  final Builder builder;

  @override
  State<StatefulWidget> createState() => PageModeState();
}

/// PageModeState class
/// describes the state of the page mode widget
class PageModeState extends State<PageMode> {
  @override
  Widget build(BuildContext context) => PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: widget.builder,
      );
}

/// ListMode class
/// renders days as lists
class ListMode extends StatefulWidget {
  // ignore: public_member_api_docs
  const ListMode(this.builder);

  // ignore: public_member_api_docs
  final Builder builder;

  @override
  State<StatefulWidget> createState() => ListModeState();
}

/// ListModeState class
/// describes the state of the list mode widget
class ListModeState extends State<ListMode> {
  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(bottom: 30),
              child: widget.builder(context, index),
            ),
      );
}
