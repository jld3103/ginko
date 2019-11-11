library locale;

export 'package:ginko/plugins/system_locale/system_locale_io.dart'
// ignore: lines_longer_than_80_chars
    if (dart.library.js) 'package:ginko/plugins/system_locale/system_locale_web.dart';
