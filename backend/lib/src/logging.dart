import 'package:colorize/colorize.dart';
import 'package:logging/logging.dart';

// ignore: public_member_api_docs
class Logging {
  // ignore: public_member_api_docs
  static void setup() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((rec) {
      if ((rec.loggerName == 'BufferedSocket' ||
              rec.loggerName == 'AuthHandler' ||
              rec.loggerName == 'MySqlConnection' ||
              rec.loggerName == 'QueryStreamHandler' ||
              rec.loggerName == 'StandardDataPacket') &&
          rec.level.name == 'FINE') {
        return;
      }
      final text = Colorize(
          // ignore: lines_longer_than_80_chars
          '[${rec.loggerName}] ${rec.time.toIso8601String()} ${rec.level.name}: ${rec.message}');
      switch (rec.level.name) {
        case 'WARNING':
          text.yellow();
          break;
        case 'INFO':
          text.green();
          break;
      }
      print(text);
    });
  }
}
