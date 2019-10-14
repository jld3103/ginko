// ignore: public_member_api_docs, one_member_abstracts
abstract class PWABase {
  // ignore: public_member_api_docs
  Future<bool> install();

  // ignore: public_member_api_docs
  Future<bool> canInstall();

  // ignore: public_member_api_docs
  void reloadPage();

  // ignore: public_member_api_docs
  Future<bool> navigateLoadingIfNeeded();
}
