import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/parsers/cafetoria.dart';
import 'package:server/path.dart';
import 'package:test/test.dart';

void main() {
  group('Cafetoria parser', () {
    test('Can parse HTML data correctly', () {
      expect(
        CafetoriaParser.extract(
                Document.html(File(
                        '${Path.getBasePath}tests/files/server/parsers/cafetoria.html')
                    .readAsStringSync()),
                false)
            .toJSON(),
        Cafetoria.fromJSON(json.decode(File(
                    '${Path.getBasePath}tests/files/server/parsers/cafetoria.json')
                .readAsStringSync()))
            .toJSON(),
      );
    });

    test('Can parse saldo', () {
      expect(
        CafetoriaParser.extract(
                Document.html(File(
                        '${Path.getBasePath}tests/files/server/parsers/cafetoria.html')
                    .readAsStringSync()),
                true)
            .saldo,
        0.0,
      );
    });

    test('Can download without error', () async {
      Config.load(true);
      expect(await CafetoriaParser.download() is Document, true);
    });
  });
}
