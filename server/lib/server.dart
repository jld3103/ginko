import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:server/config.dart';
import 'package:server/data/aixformation.dart';
import 'package:server/data/cafetoria.dart';
import 'package:server/data/calendar.dart';
import 'package:server/data/replacementplan.dart';
import 'package:server/data/teachers.dart';
import 'package:server/data/unitplan.dart';
import 'package:server/notification.dart';
import 'package:server/users.dart';

Future main() async {
  await _setup();
  print('Running in ${Config.dev ? 'development' : 'production'} mode');
  final port = int.parse((Platform.environment['PORT'] == ''
          ? null
          : Platform.environment['PORT']) ??
      '8000');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Listening on *:$port');

  final dio = Dio();

  await for (final request in server) {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', '*');
    if (request.uri.path == '/' && request.method == 'POST') {
      final content = await utf8.decoder.bind(request).join();
      Map<String, dynamic> queryParams;
      try {
        queryParams = json.decode(content);
        queryParams['user'] = json.encode(queryParams['user']);
      } on FormatException {
        queryParams = Uri(query: content).queryParameters;
      }
      if (queryParams[Keys.user] == 'null' || queryParams[Keys.user] == null) {
        request.response.statusCode = 401;
        request.response.write('401 Unauthorized');
      } else {
        var user = User.fromJSON(json.decode(queryParams[Keys.user]));
        var correctPassword = false;
        if (Users.usernames.contains(user.username) &&
            user.toSafeJSON()['password'] ==
                Users.getUser(user.username).password) {
          correctPassword = true;
        } else {
          try {
            await dio
                .get(
                  'https://nextcloud.aachen-vsa.logoip.de/index.php/apps/files/',
                  options: Options(
                    headers: {
                      'OCS-APIRequest': 'true',
                      'Authorization':
                          // ignore: lines_longer_than_80_chars
                          'Basic ${base64Encode(utf8.encode('${user.username}:${user.password}'))}',
                    },
                  ),
                )
                .timeout(Duration(seconds: 3));
            correctPassword = true;
            if (Users.usernames.contains(user.username)) {
              Users.getUser(user.username).password =
                  user.toSafeJSON()['password'];
            }
            // ignore: avoid_catches_without_on_clauses, empty_catches
          } catch (e) {}
        }
        if (correctPassword) {
          // ignore: omit_local_variable_types
          final Map<String, dynamic> data = {
            'status': 'ok',
          };
          if (!Users.usernames.contains(user.username)) {
            user = await Users.addUser(user);
            data[Keys.user] =
                (User.fromJSON(json.decode(json.encode(user.toJSON())))
                      ..tokens = [])
                    .toJSON();
          }
          Users.updateGrade(user.username, user.grade);
          Users.updateLanguage(user.username, user.language);
          Users.updateSelection(user.username, user.selection);
          Users.updateTokens(user.username, user.tokens);

          if (json.encode((User.fromJSON(json.decode(
                      json.encode(Users.getUser(user.username).toJSON())))
                    ..tokens = []
                    ..password = '')
                  .toSafeJSON()) !=
              json.encode(
                  (User.fromJSON(json.decode(json.encode(user.toJSON())))
                        ..tokens = []
                        ..password = '')
                      .toSafeJSON())) {
            data[Keys.user] =
                User.fromJSON(json.decode(json.encode(user.toJSON())))
                  ..tokens = [];
          }
          for (final key in queryParams.keys.where((key) => key != Keys.user)) {
            try {
              final value = int.parse(queryParams[key]);
              if (key == Keys.unitPlan) {
                if (UnitPlanData.unitPlan != null) {
                  if (value <
                      UnitPlanData.unitPlan.unitPlans
                          .where(
                              (unitPlan) => unitPlan.grade == user.grade.value)
                          .toList()[0]
                          .timeStamp) {
                    data[key] = UnitPlanData.unitPlan.unitPlans
                        .where((unitPlan) => unitPlan.grade == user.grade.value)
                        .toList()[0]
                        .toJSON();
                  }
                }
              } else if (key == Keys.calendar) {
                if (CalendarData.calendar != null) {
                  if (value < CalendarData.calendar.timeStamp) {
                    data[key] = CalendarData.calendar.toJSON();
                  }
                }
              } else if (key == Keys.cafetoria) {
                if (CafetoriaData.cafetoria != null) {
                  if (value < CafetoriaData.cafetoria.timeStamp) {
                    data[key] = CafetoriaData.cafetoria.toJSON();
                  }
                }
              } else if (key == Keys.replacementPlan) {
                if (ReplacementPlanData.replacementPlan != null) {
                  if (value <
                      ReplacementPlanData.replacementPlan.replacementPlans
                          .where((replacementPlan) =>
                              replacementPlan.grade == user.grade.value)
                          .toList()[0]
                          .timeStamp) {
                    data[key] = ReplacementPlanData
                        .replacementPlan.replacementPlans
                        .where((replacementPlan) =>
                            replacementPlan.grade == user.grade.value)
                        .toList()[0]
                        .toJSON();
                  }
                }
              } else if (key == Keys.teachers) {
                if (TeachersData.teachers != null) {
                  if (value < TeachersData.teachers.timeStamp) {
                    data[key] = TeachersData.teachers.toJSON();
                  }
                }
              } else if (key == Keys.aiXformation) {
                if (AiXformationData.posts != null) {
                  if (value < AiXformationData.posts.timeStamp) {
                    data[key] = AiXformationData.posts.toJSON();
                  }
                }
              } else {
                print('$key: $value');
              }
              // ignore: avoid_catches_without_on_clauses
            } catch (e, stacktrace) {
              print(e);
              print(stacktrace.toString());
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

Future _setup() async {
  await setupDateFormats();
  Config.loadFromDefault();
  print('Config loaded');
  Users.load();
  print('Users loaded');
  _invalidatePasswordCaches();
  await _deleteOldTokens();
  try {
    await TeachersData.load();
    print('Teachers loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('Teachers could not be loaded');
  }
  try {
    await UnitPlanData.load();
    print('Unit plan loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('Unit plan could not be loaded');
  }
  try {
    await CalendarData.load();
    print('Calendar loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('Calendar could not be loaded');
  }
  try {
    await CafetoriaData.load();
    print('Cafetoria loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('Cafetoria could not be loaded');
  }
  try {
    await ReplacementPlanData.load();
    print('Replacement plan loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('Replacement plan could not be loaded');
  }
  try {
    await AiXformationData.load();
    print('AiXformation loaded');
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    print('AiXformation could not be loaded');
  }
  Timer.periodic(Duration(minutes: 1), (a) async {
    try {
      await ReplacementPlanData.load();
      print('Replacement plan loaded');
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      print('Replacement plan could not be loaded');
    }
  });
  Timer.periodic(Duration(hours: 1), (a) async {
    try {
      await AiXformationData.load();
      print('AiXformation loaded');
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      print('AiXformation could not be loaded');
    }
  });
}

Future _deleteOldTokens() async {
  for (final username in Users.usernames) {
    final user = Users.getUser(username);

    final unregisteredTokens = [];
    for (final token in user.tokens) {
      final tokenRegistered = await Notifications.checkToken(token);
      if (!tokenRegistered) {
        unregisteredTokens.add(token);
      }
    }
    for (final unregisteredToken in unregisteredTokens) {
      Users.removeToken(username, unregisteredToken);
    }
  }
}

void _invalidatePasswordCaches() {
  for (final username in Users.usernames) {
    Users.getUser(username).password = 'InvalidPasswordCache';
    Users.save();
  }
}
