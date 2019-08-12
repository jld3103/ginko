library svg;

import 'package:flutter/material.dart';

/// SvgPictureRendererBase class
/// abstract svg renderer
abstract class SvgPictureRendererBase extends StatefulWidget {
  // ignore: public_member_api_docs
  const SvgPictureRendererBase(this.svg, {Key key}) : super(key: key);

  // ignore: public_member_api_docs
  final String svg;
}
