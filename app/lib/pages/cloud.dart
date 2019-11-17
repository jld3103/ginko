import 'package:flutter/cupertino.dart';
import 'package:ginko/utils/static.dart';
import 'package:ginko/views/cloud/directory.dart';
import 'package:nextcloud/nextcloud.dart';

/// CloudPage class
/// describes the cloud widget
class CloudPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const CloudPage({
    Key key,
  }) : super(key: key);

  @override
  _CloudPageState createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  NextCloudClient _client;

  @override
  void initState() {
    _client = NextCloudClient(
      'cloud.viktoria.schule',
      Static.user.data.username,
      Static.user.data.password,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CloudDirectory(
        client: _client,
        path: '/',
        device: Static.device.data,
      );
}