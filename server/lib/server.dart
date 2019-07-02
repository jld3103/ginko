import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';
import 'package:server/cafetoria.dart';
import 'package:server/calendar.dart';
import 'package:server/config.dart';
import 'package:server/unitplan.dart';
import 'package:server/users.dart';

Future main() async {
  await setup();
  final port = int.parse((Platform.environment['PORT'] == ''
          ? null
          : Platform.environment['PORT']) ??
      '8000');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Listening on *:$port');

  await for (final request in server) {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', '*');
    if (request.uri.path == '/' && request.method == 'GET') {
      final queryParams = request.uri.queryParameters;
      if (queryParams[Keys.username] == null ||
          queryParams[Keys.password] == null ||
          queryParams[Keys.grade] == null) {
        request.response.statusCode = 401;
        request.response.write('401 Unauthorized');
      } else {
        if (Users.users.containsKey(queryParams[Keys.username]) &&
            Users.users[queryParams[Keys.username]] ==
                queryParams[Keys.password] &&
            grades.contains(queryParams[Keys.grade])) {
          // ignore: omit_local_variable_types
          final Map<String, dynamic> data = {'status': 'ok'};
          for (final key in queryParams.keys.where((key) =>
          key != Keys.username &&
              key != Keys.password &&
              key != Keys.grade)) {
            try {
              final value = int.parse(queryParams[key]);
              if (key == Keys.unitPlan) {
                if (value <
                    UnitPlanData.unitPlans.unitPlans
                        .where((unitPlan) =>
                    unitPlan.grade == queryParams[Keys.grade])
                        .toList()[0]
                        .timeStamp) {
                  data[key] = UnitPlanData.unitPlans.unitPlans
                      .where((unitPlan) =>
                  unitPlan.grade == queryParams[Keys.grade])
                      .toList()[0]
                      .toJSON();
                }
              } else if (key == Keys.calendar) {
                if (value < CalendarData.calendar.timeStamp) {
                  data[key] = CalendarData.calendar.toJSON();
                }
              } else if (key == Keys.cafetoria) {
                if (value < CafetoriaData.cafetoria.timeStamp) {
                  data[key] = CafetoriaData.cafetoria.toJSON();
                }
              } else {
                print('$key: $value');
              }
              // ignore: unused_catch_clause, empty_catches
            } on Exception catch (e) {
              print(e);
            }
          }
          request.response.headers.contentType =
              ContentType('application', 'json', charset: 'utf-8');
          request.response.write(json.encode(data));
        } else {
          request.response.statusCode = 401;
          request.response.write('401 Unauthorized');
        }
      }
    } else {
      request.response.statusCode = 404;
      request.response.write('404 Not Found');
    }
    await request.response.close();
  }
}

/// Setup all data
Future setup() async {
  Config.load();
  print('Config loaded');
  Users.load();
  print('Users loaded');
  await UnitPlanData.load();
  print('Unit plan loaded');
  await CalendarData.load();
  print('Calendar loaded');
  await CafetoriaData.load();
  print('Cafetoria loaded');
  Timer.periodic(Duration(minutes: 1), (a) {});
}
