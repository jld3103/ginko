library svg;

// ignore_for_file: uri_does_not_exist
import 'dart:html';
import 'dart:svg';

import 'package:ginko/utils/svg/svg_base.dart';
import 'package:flutter/material.dart';

/// SvgPictureRenderer class
/// render a svg on web
class SvgPictureRenderer extends SvgPictureRendererBase {
  // ignore: public_member_api_docs
  const SvgPictureRenderer(String svg) : super(svg);

  @override
  _SvgPictureRendererState createState() => _SvgPictureRendererState();
}

class _SvgPictureRendererState extends State<SvgPictureRenderer> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((a) {
      // ignore: undefined_identifier
      final items = document.querySelectorAll('draw-rect');
      for (final item in items) {
        if (item.style.backgroundColor == 'rgb(18, 52, 86)' ||
            item.style.backgroundColor == 'transparent') {
          // ignore: undefined_identifier
          final svgContainer = document.createElement('svg');
          svgContainer.style.cssText = item.style.cssText;
          svgContainer.style.backgroundColor = 'transparent';
          // ignore: undefined_identifier
          final svgElement = SvgElement.svg(widget.svg);
          svgElement.style.cssText = item.style.cssText;
          svgElement.style.backgroundColor = 'transparent';
          svgContainer.nodes.add(svgElement);
          item.parentNode.replaceWith(svgContainer);
        }
      }
    });
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFF123456),
    );
  }
}
