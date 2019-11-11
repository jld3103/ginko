import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/views/dialog_content_wrapper.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudDeleteDialog class
/// describes the cloud delete dialog
class CloudDeleteDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudDeleteDialog({
    @required this.file,
    @required this.client,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  @override
  _CloudDeleteDialogState createState() => _CloudDeleteDialogState();
}

class _CloudDeleteDialogState extends State<CloudDeleteDialog> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            '${AppTranslations.of(context).cloudDelete}: ${widget.file.name}'),
        children: [
          DialogContentWrapper(
            spread: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      // ignore: lines_longer_than_80_chars
                      '${AppTranslations.of(context).cloudSureYouWantToDelete}:'),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.file.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  setState(() {
                    _deleting = true;
                  });
                  try {
                    await widget.client.webDav.delete(widget.file.path);
                    // ignore: unused_catch_clause, empty_catches
                  } on RequestException catch (e) {}
                  Navigator.pop(context, true);
                },
                child: !_deleting
                    ? Text(AppTranslations.of(context).cloudDelete)
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      ),
              ),
            ],
          ),
        ],
      );
}
