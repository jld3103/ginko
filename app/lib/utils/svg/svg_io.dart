library svg;

import 'package:app/utils/svg/svg_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as real;

/// SvgPictureRenderer class
/// render a svg on Android/iOS/desktop
class SvgPictureRenderer extends SvgPictureRendererBase {
  // ignore: public_member_api_docs
  const SvgPictureRenderer(String svg) : super(svg);

  @override
  _SvgPictureRendererState createState() => _SvgPictureRendererState();
}

class _SvgPictureRendererState extends State<SvgPictureRenderer> {
  @override
  Widget build(BuildContext context) => real.SvgPicture.string(widget.svg);
}
