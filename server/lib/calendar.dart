import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';

// ignore: avoid_classes_with_only_static_members
/// CalendarData class
/// handles all calendar parsing
class CalendarData {
  static const String _url =
      'https://viktoriaschule-aachen.de/dokumente/upload/9e15f_Terminplanung2018_19_SchuKo_Stand_20180906.pdf';

  // ignore: public_member_api_docs
  static Calendar calendar;

  static DateFormat _format;

  /// Load calendar
  static Future load() async {
    await initializeDateFormatting('de_DE', null);
    _format = DateFormat.yMMMMd('de_DE');
    Directory('build').createSync();
    File('build/calendar.pdf').writeAsBytesSync(await download());
    await Process.run('node', [
      'js/pdf_table.js',
      'build/calendar.pdf',
      'build/calendar.json',
    ]);
    var years = [];
    var events = [];
    final data = json.decode(File('build/calendar.json').readAsStringSync());
    data['pageTables'][0]['tables'][0][0].split('\n').forEach((line) {
      if (line.contains('Ferienordnung')) {
        years = line
            .replaceAll('Ferienordnung ', '')
            .split(' ')[0]
            .split('/')
            .map(int.parse)
            .toList();
        years[1] = int.parse(
            years[0].toString().substring(0, 2) + years[1].toString());
      }
    });
    // TODO(jld3103): add missing event parsers
    /*
    List<String> lines = data['pageTables'][0]['tables'][2][0]
        .split('\n')
        .where((line) => line.trim() != '')
        .map((line) => line.trim())
        .toList()
        .cast<String>();
     */
    events = [
      ...getVacations(
          data['pageTables'][0]['tables'][1][0].split('\n')..removeAt(0))
    ];
    for (final year in years) {
      final data = await downloadExternal(year);
      events = events
        ..addAll(data.keys
            .map((name) => CalendarEvent(
                  name: name,
                  type: EventTypes.holiday,
                  start: DateTime.parse(data[name]['datum']),
                  end: DateTime.parse(data[name]['datum'])
                      .add(Duration(days: 1))
                      .subtract(Duration(seconds: 1)),
                ))
            .toList());
    }
    calendar = Calendar(
      years: years.cast<int>(),
      events: events.cast<CalendarEvent>(),
    );
  }

  /// Download pdf calendar
  static Future download() async {
    final response = await http.get(_url, headers: Config.headers);
    return response.bodyBytes;
  }

  /// Download external json calendar
  static Future<Map<String, dynamic>> downloadExternal(int year) async {
    final response =
        await http.get('https://feiertage-api.de/api/?jahr=$year&nur_land=NW');
    return json.decode(utf8.decode(response.bodyBytes));
  }

  /// Extract vacations
  static List<CalendarEvent> getVacations(List<String> lines) {
    final events = [];
    for (final line in lines) {
      final arr = line
          .split('  ')
          .map((i) => i.split(',')[i.split(',').length - 1].trim())
          .where((i) => i.isNotEmpty)
          .toList();
      if (arr[0] != line.split(' ')[0]) {
        arr.insert(0, line.split(' ')[0]);
      }
      final start = _format.parse(arr[1]);
      final end = arr.length > 2
          ? _format.parse(arr[2])
          : start.add(Duration(days: 1)).subtract(Duration(seconds: 1));
      events.add(CalendarEvent(
        name: arr[0],
        type: EventTypes.vacation,
        start: start,
        end: end,
      ));
    }
    return events.cast<CalendarEvent>();
  }
}
