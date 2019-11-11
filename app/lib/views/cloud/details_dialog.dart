import 'package:after_layout/after_layout.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/views/cloud/share.dart';
import 'package:ginko/views/dialog_content_wrapper.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudDetailsDialog class
/// describes the cloud details dialog
class CloudDetailsDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudDetailsDialog({
    @required this.file,
    @required this.device,
    @required this.client,
    @required this.onReload,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final Device device;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  // ignore: public_member_api_docs
  final VoidCallback onReload;

  @override
  _CloudDetailsDialogState createState() => _CloudDetailsDialogState();
}

class _CloudDetailsDialogState extends State<CloudDetailsDialog>
    with AfterLayoutMixin<CloudDetailsDialog> {
  List<Share> _shares;

  void _load() {
    if (widget.file.shareTypes.isNotEmpty) {
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
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _load();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            '${AppTranslations.of(context).cloudDetails}: ${widget.file.name}'),
        children: [
          DialogContentWrapper(
            children: [
              if (widget.file.size != 0)
                Row(
                  children: [
                    Text('${AppTranslations.of(context).cloudSize}: '),
                    Text(
                      filesize(widget.file.size, 1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              if (widget.file.lastModified != null)
                Row(
                  children: [
                    Text('${AppTranslations.of(context).cloudLastModified}: '),
                    Text(
                      outputDateTimeFormat(widget.device.language).format(
                          widget.file.lastModified.add(Duration(hours: 2))),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              if (widget.file.shareTypes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppTranslations.of(context).cloudShares}:'),
                    Container(
                      margin: EdgeInsets.only(top: 2.5),
                      child: Column(
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
                                      showButtons: false,
                                    ))
                                .toList()
                                .cast<Widget>(),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      );
}
