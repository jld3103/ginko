library flutter_platform;

export 'package:app/utils/platform/platform_io.dart'
    if (dart.library.js) 'package:app/utils/platform/platform_web.dart';
