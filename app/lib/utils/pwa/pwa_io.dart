import 'package:ginko/utils/pwa/pwa_base.dart';

// ignore: public_member_api_docs
class PWA extends PWABase {
  @override
  Future<bool> install() async => false;

  @override
  Future<bool> canInstall() async => false;

  @override
  void reloadPage() {}

  @override
  Future<bool> navigateLoadingIfNeeded() async => false;
}
