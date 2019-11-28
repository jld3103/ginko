library pwa;

// ignore: public_member_api_docs
import 'package:ginko/views/cloud/directory_overhead.dart';

// ignore: public_member_api_docs
abstract class PWABase {
  // ignore: public_member_api_docs
  Future<bool> install();

  // ignore: public_member_api_docs
  bool canInstall();

  // ignore: public_member_api_docs
  void download(String fileName, Uri uri);

  // ignore: public_member_api_docs
  Future<DummyFile> selectFile();
}
