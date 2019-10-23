import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudShareDialog class
/// describes the cloud share dialog
class CloudShareDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudShareDialog({
    @required this.file,
    @required this.user,
    @required this.client,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final User user;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  @override
  _CloudShareDialogState createState() => _CloudShareDialogState();
}

class _CloudShareDialogState extends State<CloudShareDialog> {
  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            '${AppTranslations.of(context).cloudShare}: ${widget.file.name}'),
        contentPadding: EdgeInsets.all(10),
        children: const [],
      );
}
