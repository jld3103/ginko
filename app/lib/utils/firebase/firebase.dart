library firebase;

export 'package:ginko/utils/firebase/firebase_io.dart'
    if (dart.library.js) 'package:ginko/utils/firebase/firebase_web.dart';
