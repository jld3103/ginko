import 'package:flutter/material.dart';
import 'package:ginko/plugins/platform/platform.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:share/share.dart' as share_plugin;
import 'package:url_launcher/url_launcher.dart';

/// CloudShare class
/// describes the cloud share widget
class CloudShare extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudShare({
    @required this.share,
    @required this.client,
    @required this.file,
    @required this.onDialogReload,
    @required this.onReload,
    this.showButtons = true,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Share share;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final VoidCallback onDialogReload;

  // ignore: public_member_api_docs
  final VoidCallback onReload;

  // ignore: public_member_api_docs
  final bool showButtons;

  @override
  _CloudShareState createState() => _CloudShareState();
}

class _CloudShareState extends State<CloudShare> {
  bool _canEditUpdating = false;
  bool _removing = false;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(widget.share.shareType == ShareTypes.user
              ? MdiIcons.account
              : (widget.share.shareType == ShareTypes.group
                  ? MdiIcons.accountGroup
                  : Icons.link)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (widget.share.shareType == ShareTypes.user ||
                      widget.share.shareType == ShareTypes.group)
                    Text(
                      widget.share.shareWithDisplayName,
                    ),
                  if (widget.share.shareType == ShareTypes.publicLink)
                    GestureDetector(
                      onTap: () {
                        if (Platform().isMobile) {
                          share_plugin.Share.share(widget.share.url);
                        } else {
                          launch(widget.share.url);
                        }
                      },
                      child: Text(
                        widget.share.url,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_canEditUpdating && widget.showButtons)
                    Container(
                      margin: EdgeInsets.all(11.5),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (!_canEditUpdating && widget.showButtons)
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          _canEditUpdating = true;
                        });
                        final newPermissions = Permissions.fromInt(
                            widget.share.permissions.toInt());
                        if (!widget.share.permissions.permissions
                            .contains(Permission.update)) {
                          newPermissions.addPermission(Permission.update);
                        } else {
                          newPermissions.removePermission(Permission.update);
                        }
                        try {
                          await widget.client.shares.updateSharePermissions(
                            widget.share.id,
                            newPermissions,
                          );
                          // ignore: empty_catches, unused_catch_clause
                        } on RequestException catch (e) {}
                        setState(() {
                          _canEditUpdating = false;
                        });
                        widget.onDialogReload();
                      },
                      icon: Icon(
                        widget.share.permissions.permissions
                                .contains(Permission.update)
                            ? MdiIcons.pencil
                            : MdiIcons.pencilOff,
                      ),
                    ),
                  if (_removing && widget.showButtons)
                    Container(
                      margin: EdgeInsets.all(11.5),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (!_removing && widget.showButtons)
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          _removing = true;
                        });
                        try {
                          await widget.client.shares.deleteShare(
                            widget.share.id,
                          );
                          // ignore: empty_catches, unused_catch_clause
                        } on RequestException catch (e) {}
                        setState(() {
                          _removing = false;
                        });
                        widget.onDialogReload();
                        if (widget.file.shareTypes.length == 1) {
                          widget.onReload();
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
}
