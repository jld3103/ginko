import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/pwa/pwa.dart';
import 'package:ginko/views/cloud/create_share_dialog.dart';
import 'package:ginko/views/cloud/delete_dialog.dart';
import 'package:ginko/views/cloud/details_dialog.dart';
import 'package:ginko/views/cloud/directory_overhead.dart';
import 'package:ginko/views/cloud/rename_dialog.dart';
import 'package:ginko/views/cloud/share_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:timeago/timeago.dart' as timeago;
import 'package:translations/translations_app.dart';

/// CloudFile class
/// describes the cloud file widget
class CloudFile extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudFile({
    @required this.client,
    @required this.file,
    @required this.device,
    @required this.onReload,
    Key key,
    this.shareEnabled = true,
    this.deleteEnabled = true,
    this.renameEnabled = true,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final Device device;

  // ignore: public_member_api_docs
  final VoidCallback onReload;

  // ignore: public_member_api_docs
  final bool shareEnabled;

  // ignore: public_member_api_docs
  final bool deleteEnabled;

  // ignore: public_member_api_docs
  final bool renameEnabled;

  @override
  _CloudFileState createState() => _CloudFileState();
}

class _CloudFileState extends State<CloudFile>
    with AfterLayoutMixin<CloudFile> {
  bool _downloading = false;
  List<Choice> _choices;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _choices = [
        Choice(
          Icons.share,
          AppTranslations.of(context).cloudShare,
          enabled: widget.shareEnabled,
        ),
        Choice(
          Icons.info_outline,
          AppTranslations.of(context).cloudDetails,
        ),
        Choice(
          Icons.delete,
          AppTranslations.of(context).cloudDelete,
          enabled: widget.deleteEnabled,
        ),
        Choice(
          MdiIcons.pencil,
          AppTranslations.of(context).cloudRename,
          enabled: widget.renameEnabled,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async {
          if (widget.file.isDirectory) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CloudDirectoryOverhead(
                  file: widget.file,
                  client: widget.client,
                  device: widget.device,
                ),
              ),
            );
          } else {
            setState(() {
              _downloading = true;
            });
            final content = await widget.client.webDav.download(
              widget.file.path,
            );
            if (Platform().isWeb) {
              final uri = Uri.dataFromBytes(
                content,
                mimeType: widget.file.mimeType,
              );
              PWA().download(widget.file.name, uri);
            } else {
              final filePath = Uri(
                path: path.join(
                  (await DownloadsPathProvider.downloadsDirectory).path,
                  'ViktoriaCloud',
                  widget.file.path.substring(1, widget.file.path.length),
                ),
              ).toFilePath(windows: Platform().isWindows);
              File(filePath)
                ..createSync(recursive: true)
                ..writeAsBytesSync(content);
              await OpenFile.open(filePath);
            }
            setState(() {
              _downloading = false;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (_downloading)
                    Container(
                      margin: EdgeInsets.all(1),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (!_downloading)
                    Icon(
                      widget.file.isDirectory ? MdiIcons.folder : MdiIcons.file,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  Container(
                    height: 1,
                    width: 10,
                    color: Colors.transparent,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.file.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeago.format(
                          widget.file.lastModified.add(Duration(hours: 2)),
                          locale: widget.device.language,
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (widget.file.shareTypes.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => CloudShareDialog(
                          file: widget.file,
                          client: widget.client,
                          onReload: widget.onReload,
                        ),
                      ),
                    ),
                  if (_choices != null)
                    PopupMenuButton<int>(
                      onSelected: (choice) async {
                        var result = false;
                        switch (choice) {
                          case 0:
                            if (widget.file.shareTypes.isNotEmpty) {
                              await showDialog(
                                context: context,
                                builder: (context) => CloudShareDialog(
                                  file: widget.file,
                                  client: widget.client,
                                  onReload: widget.onReload,
                                ),
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => CloudCreateShareDialog(
                                  file: widget.file,
                                  client: widget.client,
                                  onReload: widget.onReload,
                                ),
                              );
                            }
                            break;
                          case 1:
                            await showDialog(
                              context: context,
                              builder: (context) => CloudDetailsDialog(
                                file: widget.file,
                                device: widget.device,
                                client: widget.client,
                                onReload: widget.onReload,
                              ),
                            );
                            break;
                          case 2:
                            result = (await showDialog(
                                  context: context,
                                  builder: (context) => CloudDeleteDialog(
                                    file: widget.file,
                                    client: widget.client,
                                  ),
                                )) ??
                                false;
                            break;
                          case 3:
                            result = (await showDialog(
                                  context: context,
                                  builder: (context) => CloudRenameDialog(
                                    file: widget.file,
                                    client: widget.client,
                                  ),
                                )) ??
                                false;
                            break;
                        }
                        if (result) {
                          widget.onReload();
                        }
                      },
                      itemBuilder: (context) => _choices
                          .map((choice) => PopupMenuItem<int>(
                                value: _choices.indexOf(choice),
                                enabled: choice.enabled,
                                child: Row(
                                  children: [
                                    Icon(
                                      choice.icon,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      height: 1,
                                      width: 10,
                                      color: Colors.transparent,
                                    ),
                                    Text(choice.label),
                                  ],
                                ),
                              ))
                          .toList()
                          .cast<PopupMenuEntry<int>>()
                          .toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}

// ignore: public_member_api_docs
class Choice {
  // ignore: public_member_api_docs
  Choice(
    this.icon,
    this.label, {
    this.enabled = true,
  });

  // ignore: public_member_api_docs
  final IconData icon;

  // ignore: public_member_api_docs
  final String label;

  // ignore: public_member_api_docs
  final bool enabled;
}
