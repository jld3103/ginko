import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudRenameDialog class
/// describes the cloud rename dialog
class CloudRenameDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudRenameDialog({
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
  _CloudRenameDialogState createState() => _CloudRenameDialogState();
}

class _CloudRenameDialogState extends State<CloudRenameDialog> {
  bool _renaming = false;
  final TextEditingController _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            '${AppTranslations.of(context).cloudRename}: ${widget.file.name}'),
        contentPadding: EdgeInsets.all(10),
        children: [
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.file.name,
            ),
            controller: _controller,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_focus);
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                focusNode: _focus,
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  setState(() {
                    _renaming = true;
                  });
                  String newPath;
                  if (widget.file.isDirectory) {
                    newPath = (widget.file.path.split('/')
                              ..removeLast()
                              ..removeLast())
                            .join('/') +
                        _controller.text;
                  } else {
                    newPath = widget.file.path.substring(0,
                            widget.file.path.length - widget.file.name.length) +
                        _controller.text;
                  }
                  try {
                    await widget.client.webDav.move(widget.file.path, newPath);
                    // ignore: unused_catch_clause, empty_catches
                  } on RequestException catch (e) {}
                  Navigator.pop(context, true);
                },
                child: !_renaming
                    ? Text(AppTranslations.of(context).cloudRename)
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
            ),
          ),
        ],
      );
}
