import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';

// ignore: avoid_classes_with_only_static_members
/// CafetoriaParser class
/// handles all cafetoria parsing
class CafetoriaParser {
  /// Download cafetoria
  static Future<Document> download([String username, String password]) async {
    if (username == null || password == null) {
      username = Config.cafetoriaUsername;
      password = Config.cafetoriaPassword;
    }
    final cookieJar = CookieJar();
    final dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    // Get the php session id
    await dio.get('https://www.opc-asp.de/vs-aachen/');

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
        options: Options(
          contentType: ContentType.parse('application/x-www-form-urlencoded'),
        ),
      );
      // ignore: empty_catches, unused_catch_clause
    } on DioError catch (e) {}
    final response = await dio
        .get('https://www.opc-asp.de/vs-aachen/menuplan.php?KID=$username');
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
                    return CafetoriaMenu(
                      name: document
                          .querySelectorAll('.angebot_text')[index]
                          .innerHtml
                          .replaceAll('<br>', ' ')
                          .trim(),
                      times: <Duration>[], // TODO(jld3103): Add times
                      price: price == '' ? 0 : double.parse(price),
                    );
                  }).where((menu) => menu.name != '').toList(),
                ))
            .where((day) => day.menus.isNotEmpty)
            .toList(),
      );
}
