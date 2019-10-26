import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/views/cloud/create_share_dialog.dart';
import 'package:ginko/views/cloud/share.dart';
import 'package:ginko/views/dialog_content_wrapper.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudShareDialog class
/// describes the cloud share dialog
class CloudShareDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudShareDialog({
    @required this.file,
    @required this.client,
    @required this.onReload,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final VoidCallback onReload;

  @override
  _CloudShareDialogState createState() => _CloudShareDialogState();
}

class _CloudShareDialogState extends State<CloudShareDialog>
    with AfterLayoutMixin<CloudShareDialog> {
  List<Share> _shares;

  void _load() {
    setState(() {
      _shares = null;
    });
    widget.client.shares.getShares(path: widget.file.path).then((shares) {
      if (mounted) {
        setState(() {
          _shares = shares;
        });
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _load();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            '${AppTranslations.of(context).cloudShare}: ${widget.file.name}'),
        children: [
          DialogContentWrapper(
            spread: true,
            children: [
              Column(
                children: [
                  if (_shares == null)
                    Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (_shares != null)
                    ..._shares
                        .map((share) => CloudShare(
                              share: share,
                              client: widget.client,
                              file: widget.file,
                              onDialogReload: _load,
                              onReload: widget.onReload,
                            ))
                        .toList()
                        .cast<Widget>(),
                ],
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => CloudCreateShareDialog(
                      file: widget.file,
                      client: widget.client,
                      onReload: widget.onReload,
                    ),
                  );
                },
                child: Text(AppTranslations.of(context).cloudCreateShare),
              ),
            ],
          ),
        ],
      );
}
