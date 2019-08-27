library svg;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ginko/utils/svg/svg.dart';
import 'package:http/http.dart' as http;

export 'package:ginko/utils/svg/svg_io.dart'
    if (dart.library.js) 'package:ginko/utils/svg/svg_web.dart';

/// SvgPicture class
/// render a svg on all Android/iOS/desktop/web
// ignore: must_be_immutable
class SvgPicture extends StatefulWidget {
  /// Render a svg from an asset
  SvgPicture.asset(this.assetName);

  /// Render a svg from a file
  SvgPicture.file(File file) {
    bytes = file.readAsStringSync();
  }

  /// Render a svg from bytes
  SvgPicture.memory(Uint8List bytes) {
    this.bytes = utf8.decode(bytes);
  }

  /// Render a svg from an URL
  SvgPicture.network(this.url);

  /// Render a svg from a string
  SvgPicture.string(this.bytes);

  // ignore: public_member_api_docs
  String assetName;

  // ignore: public_member_api_docs
  String bytes;

  // ignore: public_member_api_docs
  String url;

  @override
  _SvgPictureState createState() => _SvgPictureState();
}

class _SvgPictureState extends State<SvgPicture> {
  String _svg;

  @override
  void initState() {
    if (widget.assetName != null) {
      rootBundle.loadString(widget.assetName).then((data) {
        setState(() {
          _svg = data;
        });
      });
    } else if (widget.bytes != null) {
      setState(() {
        _svg = widget.bytes;
      });
    } else if (widget.url != null) {
      http.get(widget.url).then((response) {
        setState(() {
          _svg = response.body;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_svg == null) {
      return Container();
    }
    return SvgPictureRenderer(_svg);
  }
}
