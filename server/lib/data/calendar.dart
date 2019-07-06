import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';
import 'package:server/parsers/calendar.dart';

// ignore: avoid_classes_with_only_static_members
/// CalendarData class
/// handles all calendar storing
class CalendarData {
  // ignore: public_member_api_docs
  static Calendar calendar;

  /// Load calendar
  static Future load() async {
    Directory('build').createSync();
    File('build/calendar.pdf')
        .writeAsBytesSync(await CalendarParser.download());
    await Process.run('node', [
      'js/pdf_table.js',
      'build/calendar.pdf',
      'build/calendar.json',
    ]);

    calendar = await CalendarParser.extract(
        json.decode(File('build/calendar.json').readAsStringSync()));
  }
}
