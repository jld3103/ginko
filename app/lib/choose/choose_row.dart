import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ginko/choose/choose_utils.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: public_member_api_docs
class ChooseRow extends StatelessWidget {
  // ignore: public_member_api_docs
  const ChooseRow({
    @required this.asset,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Asset asset;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: () {
            launch(asset.url);
          },
          child: ListTile(
            leading: Icon(getOSIcon(asset)),
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    // ignore: lines_longer_than_80_chars
                    '${getOSName(asset)} (64-bit)',
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    getFileExtension(asset),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
