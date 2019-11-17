import 'package:flutter/services.dart';
import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// ReleasesLoader class
class ReleasesLoader extends Loader {
  // ignore: public_member_api_docs
  ReleasesLoader() : super(Keys.releases);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Release.fromJSON(json);

  @override
  Release get data => object;

  // ignore: public_member_api_docs
  Future<String> getCurrentAppVersion() async =>
      (await rootBundle.loadString('pubspec.yaml'))
          .split('\n')
          .where((line) => line.startsWith('version'))
          .single
          .split(':')[1]
          .trim()
          .split('+')[0];
}
