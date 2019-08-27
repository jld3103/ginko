library flutter_platform;

export 'package:ginko/utils/platform/platform_io.dart'
    if (dart.library.js) 'package:ginko/utils/platform/platform_web.dart';
