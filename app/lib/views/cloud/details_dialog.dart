import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:translations/translations_app.dart';

/// CloudDetailsDialog class
/// describes the cloud details dialog
class CloudDetailsDialog extends StatelessWidget {
  // ignore: public_member_api_docs
  const CloudDetailsDialog({
    @required this.file,
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final WebDavFile file;

  // ignore: public_member_api_docs
  final User user;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title:
            Text('${AppTranslations.of(context).cloudDetails}: ${file.name}'),
        contentPadding: EdgeInsets.all(10),
        children: [
          if (file.size != 0)
            Row(
              children: [
                Text('${AppTranslations.of(context).cloudSize}: '),
                Text(
                  filesize(file.size, 1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (file.lastModified != null)
            Row(
              children: [
                Text('${AppTranslations.of(context).cloudLastModified}: '),
                Text(
                  outputDateTimeFormat(user.language.value)
                      .format(file.lastModified.add(Duration(hours: 2))),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      );
}
