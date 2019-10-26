import 'dart:io';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:ginko/plugins/pwa/pwa.dart';
import 'package:ginko/views/cloud/create_directory_dialog.dart';
import 'package:ginko/views/cloud/directory.dart';
import 'package:ginko/views/cloud/file.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:path/path.dart' as path;
import 'package:translations/translations_app.dart';

/// CloudDirectoryOverhead class
/// describes the cloud directory overhead widget
class CloudDirectoryOverhead extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudDirectoryOverhead({
    @required this.file,
    @required this.client,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final User user;

  @override
  _CloudDirectoryOverheadState createState() => _CloudDirectoryOverheadState();
}

class _CloudDirectoryOverheadState extends State<CloudDirectoryOverhead>
    with AfterLayoutMixin<CloudDirectoryOverhead> {
  bool _uploading = false;
  Key _key = Key('0');
  List<Choice> _choices;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _choices = [
        Choice(
          MdiIcons.folderPlus,
          AppTranslations.of(context).cloudCreateDirectory,
        ),
        Choice(
          Icons.file_upload,
          AppTranslations.of(context).cloudUploadFile,
        ),
      ];
    });
  }

  void reload() {
    setState(() {
      _key = Key((int.parse(_key.toString().split('\'')[1]) + 1).toString());
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.file.name),
          actions: [
            IconButton(
              icon: Icon(
                MdiIcons.reload,
              ),
              onPressed: reload,
            ),
            if (_uploading)
              InkWell(
                onTap: () {},
                child: Container(
                  width: 48,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_choices != null && !_uploading)
              PopupMenuButton<int>(
                icon: Icon(Icons.add),
                onSelected: (choice) async {
                  var result = false;
                  switch (choice) {
                    case 0:
                      result = await showDialog(
                            context: context,
                            builder: (context) => CloudCreateDirectoryDialog(
                              file: widget.file,
                              client: widget.client,
                            ),
                          ) ??
                          false;
                      break;
                    case 1:
                      Uint8List content;
                      String fileName;
                      if (Platform().isWeb) {
                        final file = await PWA().selectFile();
                        content = file.content;
                        fileName = file.name;
                        if (fileName == '') {
                          return;
                        }
                      } else {
                        final filePath =
                            await FilePicker.getFilePath(type: FileType.ANY);
                        if (filePath == '') {
                          return;
                        }
                        fileName = path.basename(filePath);
                        content = File(filePath).readAsBytesSync();
                      }
                      setState(() {
                        _uploading = true;
                      });
                      await widget.client.webDav.upload(
                        content,
                        path.join(
                          widget.file.path,
                          fileName,
                        ),
                      );
                      setState(() {
                        _uploading = false;
                      });
                      result = true;
                      break;
                  }
                  if (result) {
                    reload();
                  }
                },
                itemBuilder: (context) => _choices
                    .map((choice) => PopupMenuItem<int>(
                          value: _choices.indexOf(choice),
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
        body: CloudDirectory(
          key: _key,
          client: widget.client,
          path: widget.file.path,
          user: widget.user,
        ),
      );
}

// ignore: public_member_api_docs
class DummyFile {
  // ignore: public_member_api_docs
  const DummyFile(this.name, this.content);

  // ignore: public_member_api_docs
  final String name;

  // ignore: public_member_api_docs
  final Uint8List content;
}
