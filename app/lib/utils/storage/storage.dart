library storage;

export 'package:ginko/utils/storage/storage_io.dart'
    if (dart.library.js) 'package:ginko/utils/storage/storage_web.dart';
