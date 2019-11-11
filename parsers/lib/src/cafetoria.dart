import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:html/dom.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// CafetoriaParser class
/// handles all cafetoria parsing
class CafetoriaParser {
  /// Download cafetoria
  static Future<Document> download([String username, String password]) async {
    final cookieJar = CookieJar();
    final dio = Dio()
      ..options = BaseOptions(
        contentType: 'application/x-www-form-urlencoded',
      )
      ..interceptors.add(CookieManager(cookieJar));
    // Get the php session id
    await dio
        .get('https://www.opc-asp.de/vs-aachen/')
        .timeout(Duration(seconds: 10));

    try {
      // This will fail in a redirect 302 error. That's correct
      await dio.post(
        'https://www.opc-asp.de/vs-aachen/?LogIn=true',
        data: {
          'sessiontest': cookieJar
              .loadForRequest(Uri.parse('https://www.opc-asp.de/vs-aachen/'))
              .where((cookie) => cookie.name == 'PHPSESSID')
              .toList()[0]
              .value,
          'f_kartennr': username,
          'f_pw': password,
        },
      ).timeout(Duration(seconds: 10));
      // ignore: empty_catches, unused_catch_clause
    } on DioError catch (e) {}
    final response = await dio
        .get('https://www.opc-asp.de/vs-aachen/menuplan.php?KID=$username')
        .timeout(Duration(seconds: 10));
    return Document.html(response.toString());
  }

  /// Extract cafetoria from html
  static Cafetoria extract(Document document, bool realUser) => Cafetoria(
        saldo: realUser
            ? double.parse(
                document.querySelector('#saldoOld').text.replaceAll(',', '.'))
            : null,
        days: document
            .querySelectorAll('.MPDatum')
            .map((day) => CafetoriaDay(
                  date: parseDate(day.querySelector('b').text),
                  menus: List.generate(4, (i) {
                    final index =
                        document.querySelectorAll('.MPDatum').indexOf(day) * 4 +
                            i;
                    final price = document
                        .querySelectorAll('.angebot_preis')[index]
                        .text
                        .replaceAll(',', '.')
                        .split(' ')[0];
                    final items = document
                        .querySelectorAll('.angebot_text')[index]
                        .innerHtml
                        .split('<br>');
                    final name = (items.length > 1 &&
                                items[0].toLowerCase().contains('uhr')
                            ? items.sublist(1).join('\n')
                            : items.join('\n'))
                        .trim();
                    final times = [];
                    if (items.length > 1 &&
                        items[0].toLowerCase().contains('uhr')) {
                      final subItems = items[0]
                          .toLowerCase()
                          .replaceAll('uhr', '')
                          .split('-')
                          .map((i) => i.trim())
                          .toList();
                      for (final subItem in subItems) {
                        final parts = subItem.split('.');
                        times.add(Duration(
                          hours: int.parse(parts[0]),
                          minutes: parts.length > 1 ? int.parse(parts[1]) : 0,
                        ));
                      }
                    }
                    return CafetoriaMenu(
                      name: name,
                      times: times.cast<Duration>(),
                      price: price == '' ? 0 : double.parse(price),
                    );
                  }).where((menu) => menu.name != '').toList(),
                ))
            .where((day) => day.menus.isNotEmpty)
            .toList(),
      );
}
