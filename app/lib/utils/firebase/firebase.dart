library firebase;

export 'package:app/utils/firebase/firebase_io.dart'
    if (dart.library.js) 'package:app/utils/firebase/firebase_web.dart';
