import 'package:flutter/material.dart';

/// Get a widget by calling a function
typedef WidgetCallback = Widget Function();

/// Item class
/// describes an entry in a day
class Item {
  // ignore: public_member_api_docs
  Item({
    @required this.from,
    @required this.to,
    @required this.render,
  });

  // ignore: public_member_api_docs
  DateTime from;

  // ignore: public_member_api_docs
  DateTime to;

  // ignore: public_member_api_docs
  WidgetCallback render;
}
