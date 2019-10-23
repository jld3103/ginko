import 'dart:typed_data';

import 'package:ginko/plugins/pwa/pwa_base.dart';
import 'package:ginko/views/cloud/directory_overhead.dart';

// ignore: public_member_api_docs
class PWA extends PWABase {
  @override
  Future<bool> install() async => false;

  @override
  Future<bool> canInstall() async => false;

  @override
  void download(String fileName, Uri uri) {}

  @override
  Future<DummyFile> selectFile() async => DummyFile('', Uint8List(0));
}
