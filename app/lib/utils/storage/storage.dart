library storage;

export 'package:app/utils/storage/storage_io.dart'
    if (dart.library.js) 'package:app/utils/storage/storage_web.dart';
