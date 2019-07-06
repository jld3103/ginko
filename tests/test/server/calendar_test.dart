import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';
import 'package:server/parsers/calendar.dart';
import 'package:server/path.dart';
import 'package:test/test.dart';

void main() {
  group('Calendar parser', () {
    test('Can parse PDF data correctly', () async {
      expect(
        (await CalendarParser.extract(json.decode(File(
                    '${Path.getBasePath}tests/files/server/parsers/calendar_raw.json')
                .readAsStringSync())))
            .toJSON(),
        Calendar.fromJSON(json.decode(File(
                    '${Path.getBasePath}tests/files/server/parsers/calendar.json')
                .readAsStringSync()))
            .toJSON(),
      );
    });

    test('Can download without error', () async {
      expect(await CalendarParser.download() is List<int>, true);
    });
  });
}
