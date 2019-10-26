import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ginko/views/dialog_content_wrapper.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudCreateDirectoryDialog class
/// describes the cloud create directory dialog
class CloudCreateDirectoryDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudCreateDirectoryDialog({
    @required this.file,
    @required this.client,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final NextCloudClient client;

  @override
  _CloudCreateDirectoryDialogState createState() =>
      _CloudCreateDirectoryDialogState();
}

class _CloudCreateDirectoryDialogState
    extends State<CloudCreateDirectoryDialog> {
  bool _creating = false;
  final TextEditingController _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(AppTranslations.of(context).cloudCreateDirectory),
        children: [
          DialogContentWrapper(
            spread: true,
            children: [
              TextFormField(
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppTranslations.of(context).cloudName,
                ),
                onChanged: (text) {
                  setState(() {});
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_focus);
                },
              ),
              RaisedButton(
                focusNode: _focus,
                color: Theme.of(context).accentColor,
                onPressed: _controller.text == ''
                    ? null
                    : () async {
                        setState(() {
                          _creating = true;
                        });
                        final path = widget.file.path + _controller.text;
                        await widget.client.webDav.mkdir(path);
                        Navigator.pop(context, true);
                      },
                child: !_creating
                    ? Text(AppTranslations.of(context).cloudCreateDirectory)
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
