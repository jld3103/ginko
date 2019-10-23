import 'package:flutter/cupertino.dart';
import 'package:ginko/views/cloud/directory.dart';
import 'package:models/models.dart';
import 'package:nextcloud/nextcloud.dart';

/// CloudPage class
/// describes the cloud widget
class CloudPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudPage({
    @required this.user,
    Key key,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final User user;

  @override
  _CloudPageState createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  NextCloudClient _client;

  @override
  void initState() {
    _client = NextCloudClient(
      'cloud.viktoria.schule',
      widget.user.username,
      widget.user.password,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CloudDirectory(
        client: _client,
        path: '/',
        user: widget.user,
      );
}
