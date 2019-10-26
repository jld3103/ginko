import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:ginko/views/cloud/file.dart';
import 'package:ginko/views/cloud/share_dialog.dart';
import 'package:ginko/views/dialog_content_wrapper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudCreateShareDialog class
/// describes the cloud create share dialog
class CloudCreateShareDialog extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudCreateShareDialog({
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
  _CloudCreateShareDialogState createState() => _CloudCreateShareDialogState();
}

class _CloudCreateShareDialogState extends State<CloudCreateShareDialog>
    with AfterLayoutMixin<CloudCreateShareDialog> {
  List<Choice> _choices;
  int _selectedChoice = 0;
  final TextEditingController _shareeController = TextEditingController();
  List<Sharee> _sharees = [];
  Sharee _selectedSharee;
  bool _shareesLoading = false;
  bool _canEdit = true;
  bool _creating = false;

  void _updateSearchResults(String query) {
    if (query == '') {
      setState(() {
        _shareesLoading = false;
        _sharees = [];
      });
    } else {
      void callback(List<Sharee> sharees) {
        if (query == _shareeController.text) {
          if (mounted) {
            setState(() {
              _shareesLoading = false;
              _sharees = sharees;
              if (_sharees.length > 5) {
                _sharees = _sharees.sublist(0, 5);
              }
            });
          }
        }
      }

      setState(() {
        _shareesLoading = true;
      });

      if (_selectedChoice == 1) {
        widget.client.sharees
            .getUserSharees(
                query, 5, widget.file.isDirectory ? 'folder' : 'file')
            .then(callback);
      } else {
        widget.client.sharees
            .getGroupSharees(
                query, 5, widget.file.isDirectory ? 'folder' : 'file')
            .then(callback);
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _choices = [
        Choice(
          Icons.link,
          AppTranslations.of(context).cloudPublicLink,
        ),
        Choice(
          MdiIcons.account,
          AppTranslations.of(context).cloudUser,
        ),
        Choice(
          MdiIcons.accountGroup,
          AppTranslations.of(context).cloudGroup,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text(
            // ignore: lines_longer_than_80_chars
            '${AppTranslations.of(context).cloudCreateShare}: ${widget.file.name}'),
        contentPadding: EdgeInsets.all(0),
        children: [
          DialogContentWrapper(
            spread: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_choices != null)
                    Container(
                      padding: EdgeInsets.only(left: 12.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              onChanged: (value) {
                                setState(() {
                                  _selectedChoice = value;
                                });
                                if (value > 0) {
                                  _updateSearchResults(_shareeController.text);
                                }
                              },
                              isExpanded: false,
                              value: _selectedChoice,
                              items: _choices
                                  .map((choice) => DropdownMenuItem<int>(
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
                                  .cast<DropdownMenuItem<int>>(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_selectedChoice > 0)
                    Container(
                      padding: EdgeInsets.only(left: 12.5, right: 12.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: AppTranslations.of(context).cloudSearch,
                            ),
                            controller: _shareeController,
                            onChanged: _updateSearchResults,
                          ),
                          Container(
                            width: 1,
                            height: 5,
                            color: Colors.transparent,
                          ),
                          if (_sharees.isEmpty &&
                              _shareeController.text != '' &&
                              !_shareesLoading)
                            Text(AppTranslations.of(context)
                                .cloudNoSearchResults),
                          SizedBox(
                            height: 30.0 * 5,
                            child: _shareesLoading
                                ? Center(
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : ListView(
                                    shrinkWrap: true,
                                    children: _sharees
                                        .map((sharee) => InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _selectedSharee = sharee;
                                                });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        _selectedSharee?.uuid ==
                                                                sharee.uuid
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Colors.white,
                                                  ),
                                                ),
                                                child: Text(sharee.name),
                                              ),
                                            ))
                                        .toList()
                                        .cast<Widget>(),
                                  ),
                          ),
                          if (_selectedSharee == null)
                            Text(
                              AppTranslations.of(context)
                                  .cloudNeedToSelectSharee,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _canEdit = !_canEdit;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _canEdit,
                          onChanged: (value) {
                            setState(() {
                              _canEdit = value;
                            });
                          },
                        ),
                        Text(AppTranslations.of(context).cloudCanEdit),
                      ],
                    ),
                  ),
                ],
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: _selectedChoice > 0 && _selectedSharee == null
                    ? null
                    : () async {
                        setState(() {
                          _creating = true;
                        });
                        switch (_selectedChoice) {
                          case 0:
                            await widget.client.shares
                                .shareWithPublicLink(widget.file.path,
                                    permissions: Permissions(
                                      [
                                        1,
                                        if (_canEdit) 2,
                                        16,
                                      ],
                                    ));
                            break;
                          case 1:
                            await widget.client.shares.shareWithUser(
                                widget.file.path, _selectedSharee.uuid,
                                permissions: Permissions(
                                  [
                                    1,
                                    if (_canEdit) 2,
                                    16,
                                  ],
                                ));
                            break;
                          case 2:
                            await widget.client.shares.shareWithGroup(
                                widget.file.path, _selectedSharee.uuid,
                                permissions: Permissions(
                                  [
                                    1,
                                    if (_canEdit) 2,
                                    16,
                                  ],
                                ));
                            break;
                        }
                        setState(() {
                          _creating = false;
                        });
                        Navigator.of(context).pop();
                        await showDialog(
                          context: context,
                          builder: (context) => CloudShareDialog(
                            file: widget.file,
                            client: widget.client,
                            onReload: widget.onReload,
                          ),
                        );
                        widget.onReload();
                      },
                child: !_creating
                    ? Text(AppTranslations.of(context).cloudCreateShare)
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
