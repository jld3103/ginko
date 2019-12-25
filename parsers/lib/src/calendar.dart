import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// CalendarParser class
/// handles all calendar parsing
class CalendarParser {
  static const String _url =
      'https://viktoriaschule-aachen.de/dokumente/upload/61518_Terminplanung2019_20.pdf';
  static final Dio _dio = Dio();
  static DateFormat _format;

  /// Extract calendar
  static Future<Calendar> extract(List<int> raw) async {
    Directory('build').createSync();
    File('build/calendar.pdf').writeAsBytesSync(raw);
    await Process.run('node', [
      '../parsers/js/pdf_table.js',
      'build/calendar.pdf',
      'build/calendar.json',
    ]);
    final data = json.decode(File('build/calendar.json').readAsStringSync());

    await initializeDateFormatting('de_DE', null);
    _format = DateFormat.yMMMMd('de_DE');
    var years = [];
    var events = [];
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
    final lines = data['pageTables'][0]['tables'][2][0]
        .split('\n')
        .where((line) => line.trim() != '')
        .map((line) => line.trim())
        .toList()
        .cast<String>();
    events = [
      ...getVacations(
          data['pageTables'][0]['tables'][1][0].split('\n')..removeAt(0)),
      ...getOpenDoorDay(lines),
      ...getFreeDays(lines),
      ...getConsultationDays(lines),
      ...getGradeReleases(lines),
      ...getConferences(lines)
    ];
    for (final year in years) {
      final data = await downloadExternal(year);
      events = events
        ..addAll(data.keys
            .map((name) => CalendarEvent(
                  name: name,
                  type: EventTypes.free,
                  start: DateTime.parse(data[name]['datum']),
                  end: DateTime.parse(data[name]['datum'])
                      .add(Duration(days: 1))
                      .subtract(Duration(seconds: 1)),
                ))
            .toList());
    }
    return Calendar(
      years: years.cast<int>(),
      events: events.cast<CalendarEvent>(),
    );
  }

  /// Download pdf calendar
  static Future<List<int>> download(String username, String password) async {
    final response = await _dio
        .get(
          _url,
          options: Options(
            headers: {
              'authorization':
                  'Basic ${base64Encode(utf8.encode('$username:$password'))}',
            },
            responseType: ResponseType.bytes,
          ),
        )
        .timeout(Duration(seconds: 10));
    return response.data;
  }

  /// Download external json calendar
  static Future<Map<String, dynamic>> downloadExternal(int year) async {
    final response = await _dio
        .get('https://feiertage-api.de/api/?jahr=$year&nur_land=NW')
        .timeout(Duration(seconds: 10));
    return json.decode(response.toString());
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
      final end = (arr.length > 2 ? _format.parse(arr[2]) : start)
          .add(Duration(days: 1))
          .subtract(Duration(seconds: 1));
      events.add(CalendarEvent(
        name: arr[0] == 'Herbst'
            ? 'Herbstferien'
            : arr[0] == 'Weihnachten'
                ? 'Weihnachtsferien'
                : arr[0] == 'Ostern'
                    ? 'Osterferien'
                    : arr[0] == 'Pfingsten'
                        ? 'Pfingstferien'
                        : arr[0] == 'Sommer'
                            ? 'Sommerferien'
                            : '${arr[0]}ferien', // fallback
        type: EventTypes.vacation,
        start: start,
        end: end,
      ));
    }
    return events.cast<CalendarEvent>();
  }

  /// Extract open door day and its replacement
  static List<CalendarEvent> getOpenDoorDay(List<String> lines) {
    final events = [];
    final openDoorDay = lines
        .firstWhere((line) => line.contains(
            // ignore: lines_longer_than_80_chars
            'Unterricht am Tag der Offenen Tür für künftige Fünftklässler und deren Eltern.'))
        .replaceAll(
            // ignore: lines_longer_than_80_chars
            ': Unterricht am Tag der Offenen Tür für künftige Fünftklässler und deren Eltern.',
            '');
    events.add(CalendarEvent(
      name: 'Tag der Offenen Tür',
      type: EventTypes.openDoorDay,
      start: parseDate(openDoorDay),
      end: parseDate(openDoorDay)
          .add(Duration(days: 1))
          .subtract(Duration(seconds: 1)),
    ));
    var openDoorDayReplacement = (lines
            .firstWhere((line) => line.contains('Dafür ist unterrichtsfrei am'))
            .replaceAll('Dafür ist unterrichtsfrei am ', '')
            .replaceAll(', dem', '')
            .split(' ')
              ..removeAt(0))
        .join(' ');
    openDoorDayReplacement =
        openDoorDayReplacement.substring(0, openDoorDayReplacement.length - 1);
    events.add(CalendarEvent(
      name: 'Ersatz für Tag der Offenen Tür',
      type: EventTypes.free,
      start: _format.parse(openDoorDayReplacement),
      end: _format
          .parse(openDoorDayReplacement)
          .add(Duration(days: 1))
          .subtract(Duration(seconds: 1)),
    ));
    return events.cast<CalendarEvent>();
  }

  /// Extract free days
  static List<CalendarEvent> getFreeDays(List<String> lines) {
    final events = [];
    final lines1 = lines.join('\n').split('Sprechtage')[0].split('\n');
    for (final line in lines1) {
      if (RegExp('^[0-9]\. ').hasMatch(line)) {
        final arr1 = (line.split(' ')..removeAt(0)).join(' ').split(', ');
        final arr2 = arr1[1]
            .split('(')
            .map((a) => a.replaceAll(')', '').trim())
            .toList();
        final name = arr1[0];
        final date = _format.parse(arr2[0]);
        final info = arr2.length > 1 ? arr2[1] : null;
        events.add(CalendarEvent(
          name: name.length > 10 ? name : info,
          info: name.length > 10 ? info : null,
          type: EventTypes.free,
          start: date,
          end: date.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
        ));
      }
    }
    final lines2 = lines
        .join('\n')
        .split('Pädagogischer Tag und Kollegiumstagung:')[1]
        .split('\n')
        .sublist(1);
    for (var line in lines2) {
      if (line.contains('Tag des 4. Abiturfachs')) {
        var lines3 = lines2.sublist(lines2.indexOf(line));
        lines3 = lines3.sublist(
            0,
            lines3.indexOf(lines3
                .where((line) => line.startsWith('Einen vollständigen'))
                .toList()[0]));
        line = lines3.join('');
        final date = _format.parse(line.split(': ')[1].split(', ')[1].trim());
        events.add(CalendarEvent(
          start: date,
          end: date.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
          name: 'Tag des 4. Abiturfachs (vorraussichtlich)',
          type: EventTypes.free,
        ));
      } else if (line.startsWith(' ')) {
        line = line.substring(2);
        while (line.contains('  ')) {
          line = line.replaceAll('  ', ' ');
        }
        var name = line.split(': ')[0];
        if (RegExp('[0-9]\$').hasMatch(name)) {
          name = name.substring(0, name.length - 2);
        }
        final date = _format.parse(line.split(': ')[1].split(', ')[1].trim());
        events.add(CalendarEvent(
          start: date,
          end: date.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
          name: name,
          type: EventTypes.free,
        ));
      }
    }
    return events.cast<CalendarEvent>();
  }

  /// Extract consultation days
  static List<CalendarEvent> getConsultationDays(List<String> lines) {
    final events = [];
    lines = lines.join('\n').split('Sprechtage').sublist(1)[0].split('\n');
    for (var line in lines) {
      if (RegExp('^[0-9]\. ').hasMatch(line)) {
        line = line.replaceAll(RegExp('^[0-9]\. '), '').trim();
        final name = line.contains('Monitasprechtag')
            ? 'Monitasprechtag'
            : 'Elternsprechtag';
        line = line.replaceAll(': Monitasprechtag', '');
        if (line.contains('und')) {
          var parts = line.split('und');
          parts.add(parts[1].split('(')[1].replaceAll(')', ''));
          parts[1] = parts[1].split('(')[0];
          parts = parts
              .map((part) =>
                  (part.split(',').length > 1 ? part.split(',')[1] : part)
                      .trim())
              .toList();
          var start1 = _format.parse(parts[0]);
          var start2 = _format.parse(parts[1]);

          final startTimeStr = parts[2].split('–')[0].trim();
          final endTimeStr = parts[2].split('–')[1].trim().split(' ')[0].trim();
          final startOffset = Duration(
            hours: int.parse(startTimeStr.replaceAll(':', '.').split('.')[0]),
            minutes: int.parse(startTimeStr.replaceAll(':', '.').split('.')[1]),
          );
          final endOffset = Duration(
            hours: int.parse(endTimeStr.replaceAll(':', '.').split('.')[0]),
            minutes: int.parse(endTimeStr.replaceAll(':', '.').split('.')[1]),
          );
          final end1 = start1.add(endOffset);
          final end2 = start2.add(endOffset);
          start1 = start1.add(startOffset);
          start2 = start2.add(startOffset);
          events
            ..add(CalendarEvent(
              type: EventTypes.parentConsulting,
              start: start1,
              name: name,
              end: end1,
            ))
            ..add(CalendarEvent(
              type: EventTypes.parentConsulting,
              start: start2,
              name: name,
              end: end2,
            ));
        } else {
          var parts = line.split(',')[1].split('(');
          parts[1] = parts[1].replaceAll(')', '');
          parts = parts.map((part) => part.trim()).toList();
          final date = _format.parse(parts[0]);
          var description = '';
          if (parts[1].toLowerCase().contains('uhr')) {
            final startTimeStr = parts[1].split('–')[0].trim();
            final endTimeStr =
                parts[1].split('–')[1].trim().split(' ')[0].trim();
            final startOffset = Duration(
              hours: int.parse(startTimeStr.replaceAll(':', '.').split('.')[0]),
              minutes:
                  int.parse(startTimeStr.replaceAll(':', '.').split('.')[1]),
            );
            final endOffset = Duration(
              hours: int.parse(endTimeStr.replaceAll(':', '.').split('.')[0]),
              minutes: int.parse(endTimeStr.replaceAll(':', '.').split('.')[1]),
            );
            events.add(CalendarEvent(
              start: date.add(startOffset),
              type: EventTypes.parentConsulting,
              end: date.add(endOffset),
              name: name,
              info: description,
            ));
          } else {
            description = parts[1];
            events.add(CalendarEvent(
              start: date,
              type: EventTypes.parentConsulting,
              end: date.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
              name: name,
              info: description,
            ));
          }
        }
      }
    }
    return events.cast<CalendarEvent>();
  }

  /// Extract grade releases
  static List<CalendarEvent> getGradeReleases(List<String> lines) {
    final events = [];
    lines = lines.where((line) => line.contains('Zeugnisausgabe')).toList();
    for (var line in lines) {
      line = line.split('Zeugnisausgabe:')[1].split(',')[1].trim();
      final date = _format.parse(line.split('(')[0].trim());
      events.add(CalendarEvent(
        name: 'Zeugnisausgabe',
        end: date.add(Duration(
          hours:
              int.parse(line.split('Unterrichtsende')[1].trim().split(' ')[0]),
        )),
        type: EventTypes.gradeRelease,
        start: date,
      ));
    }
    return events.cast<CalendarEvent>();
  }

  /// Extract conferences
  static List<CalendarEvent> getConferences(List<String> lines) {
    final events = [];
    lines = lines
        .join('\n')
        .split('Zeugniskonferenzen:')[1]
        .split('Pädagogischer Tag und Kollegiumstagung:')[0]
        .split('\n');
    lines = lines
      ..removeLast()
      ..removeAt(0);
    lines = lines.map((line) => line.replaceAll(' ', '')).toList();
    lines = lines.where((line) {
      line = line.trim();
      return !line.startsWith('Beratungskonferenzen') &&
          !line.startsWith('Zeugnisausgabe');
    }).toList();
    for (var line in lines) {
      while (line.contains('  ')) {
        line = line.replaceAll('  ', ' ');
      }
      if (RegExp('^[0-9]').hasMatch(line)) {
        final timeStr = RegExp('[0-9][0-9]\.[0-9][0-9] uhr')
            .firstMatch(line.toLowerCase())
            .group(0)
            .split(' ')[0];
        final offset = Duration(
          hours: int.parse(timeStr.replaceAll(':', '.').split('.')[0]),
          minutes: int.parse(timeStr.replaceAll(':', '.').split('.')[1]),
        );
        line = line.split('. ')[0];
        // ignore: omit_local_variable_types
        final List<String> dates = [];
        final matches = RegExp(
                '[0-9]{1,2}\.([0-9]{1,2}\.)?\/[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{4}')
            .allMatches(line)
            .map((m) => m.group(0))
            .toList();
        for (final match in matches) {
          dates.add(match.split('/')[1]);
          final prefix = match.split('/')[0];
          if (prefix.split('.').length == 2) {
            dates.add(
                // ignore: lines_longer_than_80_chars
                '$prefix${match.split('/')[1].split('.')[1]}.${match.split('/')[1].split('.')[2]}');
          } else if (prefix.split('.').length == 3) {
            dates.add('$prefix${match.split('/')[1].split('.')[2]}');
          }
        }

        for (final date in dates.map(parseDate).toList()) {
          events.add(CalendarEvent(
            name: 'Beratungskonferenz',
            end: date.add(offset),
            type: EventTypes.teacherConsulting,
            start: date,
            shortUnits: true,
          ));
        }
      } else {
        line = line.split(',').sublist(1).join(',').trim();
        final date = _format.parse(line.split('(')[0].trim());
        final grades =
            line.split('(')[1].split(')')[0].toUpperCase().split(', ');
        if (grades.contains('SI')) {
          grades
            ..add('5 - 9')
            ..removeAt(grades.indexOf('SI'));
        }
        if (grades.contains('SII')) {
          grades
            ..add('EF - Q2')
            ..removeAt(grades.indexOf('SII'));
        }
        final description = line.split(',').last.trim();
        if (line.toLowerCase().contains('ausgabe der leistungsnachweise')) {
          final date2 = _format.parse(
              description.split('Ausgabe der Leistungsnachweise am')[1].trim());
          events
            ..add(CalendarEvent(
              type: EventTypes.teacherConsulting,
              name: 'Zeugniskonferenzen (${grades.join(', ')})',
              start: date,
              end: date.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
            ))
            ..add(CalendarEvent(
              type: EventTypes.teacherConsulting,
              name:
                  '${description.split('am')[0].trim()} (${grades.join(', ')})',
              start: date2,
              end: date2.add(Duration(days: 1)).subtract(Duration(seconds: 1)),
            ));
        } else {
          events.add(CalendarEvent(
              type: description.contains('unterrichtsfrei')
                  ? EventTypes.free
                  : EventTypes.teacherConsulting,
              name: 'Zeugniskonferenzen (${grades.join(', ')})',
              info: description,
              start: date,
              end: description == 'kein Nachmittagsunterricht'
                  ? date.add(Times.getUnitTimes(4, false)[1])
                  : date
                      .add(Duration(days: 1))
                      .subtract(Duration(seconds: 1))));
        }
      }
    }
    return events.cast<CalendarEvent>();
  }
}
