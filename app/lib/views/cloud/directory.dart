import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/views/cloud/file.dart';
import 'package:ginko/views/size_limit.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';

/// CloudDirectory class
/// describes the cloud directory widget
class CloudDirectory extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudDirectory({
    @required this.client,
    @required this.path,
    @required this.device,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final String path;

  // ignore: public_member_api_docs
  final Device device;

  @override
  _CloudDirectoryState createState() => _CloudDirectoryState();
}

class _CloudDirectoryState extends State<CloudDirectory>
    with AfterLayoutMixin<CloudDirectory> {
  List<WebDavFile> _files;
  bool _failed = false;

  void _loadFiles() {
    setState(() {
      _files = null;
    });
    widget.client.webDav.ls(widget.path).then((files) {
      if (mounted) {
        setState(() {
          _files = files;
          if (widget.path == '/') {
            _files = _files.where((file) => file.name != 'Programme').toList();
          }
          _files.sort((a, b) {
            var r = 0;
            if (a.isDirectory && !b.isDirectory) {
              r = -1;
            }
            if (!a.isDirectory && b.isDirectory) {
              r = 1;
            }
            if (r != 0) {
              return r;
            }
            return a.name.compareTo(b.name);
          });
        });
      }
    }).catchError((e, stacktrace) {
      print(e);
      print(stacktrace);
      if (mounted) {
        setState(() {
          _failed = true;
        });
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _loadFiles();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: _failed
            ? Icon(Icons.error)
            : (_files == null
                ? SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : SizeLimit(
                    child: ListView(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      children: _files
                          .map((file) {
                            final forbiddenFile = widget.path == '/' ||
                                file.path ==
                                    '/Eigene%20Dateien/Geteilte%20Dateien/';
                            return CloudFile(
                              client: widget.client,
                              file: file,
                              device: widget.device,
                              onReload: _loadFiles,
                              shareEnabled: !forbiddenFile,
                              deleteEnabled: !forbiddenFile,
                              renameEnabled: !forbiddenFile,
                            );
                          })
                          .toList()
                          .cast<Widget>(),
                    ),
                  )),
      );
}
