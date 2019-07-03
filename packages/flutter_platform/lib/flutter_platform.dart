library flutter_platform;

export 'package:flutter_platform/flutter_platform_io.dart'
    if (dart.library.js) 'package:flutter_platform/flutter_platform_web.dart';
