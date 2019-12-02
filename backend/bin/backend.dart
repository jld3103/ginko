import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:backend/backend.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

Future main(List<String> args) async {
  Logging.setup();

  final log = Logger('Backend');

  final argParser = ArgParser()
    ..addFlag(
      'fetch',
      defaultsTo: true,
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      negatable: false,
    );
  final results = argParser.parse(args);

  Config.load();
  Config.fetchOnStart = results['fetch'];
  Config.verbose = results['verbose'];
  log.info('Loaded config');

  final mySqlConnection = await MySqlConnection.connect(ConnectionSettings(
    host: Config.dbHost,
    port: Config.dbPort,
    user: Config.dbUsername,
    password: Config.dbPassword,
    db: Config.dbName,
  ));
  log.info('Connected to database');
  await Database.createDefaultTables(mySqlConnection);

  final server = await HttpServer.bind(InternetAddress.anyIPv4, Config.port);

  final login = LoginHandler(mySqlConnection);
  final user = UserHandler(mySqlConnection);
  final devices = DevicesHandler(mySqlConnection);
  final selection = SelectionHandler(mySqlConnection);
  final settings = SettingsHandler(mySqlConnection);

  final timetable = TimetableHandler(mySqlConnection);
  final substitutionPlan = SubstitutionPlanHandler(
    mySqlConnection,
    timetable,
    selection,
  );
  final calendar = CalendarHandler(mySqlConnection);
  final teachers = TeachersHandler(
    mySqlConnection,
    timetable,
  );
  final subjects = SubjectsHandler(
    mySqlConnection,
    timetable,
  );
  final rooms = RoomsHandler(
    mySqlConnection,
    timetable,
  );
  final aiXformation = AiXformationHandler(mySqlConnection);
  final cafetoria = CafetoriaHandler(mySqlConnection);
  final releases = ReleasesHandler(mySqlConnection);
  final updates = UpdatesHandler(mySqlConnection, [
    substitutionPlan,
    timetable,
    calendar,
    aiXformation,
    cafetoria,
    releases,
  ]);
  await setupDateFormats();

  await setupAutoFetchers(
    log,
    mySqlConnection,
    minutely: [substitutionPlan],
    hourly: [aiXformation, releases],
    daily: [timetable, calendar, teachers, subjects, rooms, cafetoria],
  );

  log.info('Serving on *:${Config.port}');

  await for (final request in server) {
    if (Config.verbose) {
      log.fine('${request.method}: ${request.uri}');
    }
    final response = request.response;
    response.headers.add(
      'Access-Control-Allow-Origin',
      '*',
    );
    response.headers.add(
      'Access-Control-Allow-Methods',
      'GET, POST, PATCH, PUT, DELETE, OPTIONS',
    );
    response.headers.add(
      'Access-Control-Allow-Headers',
      // ignore: lines_longer_than_80_chars
      'Authorization,DNT,User-Agent,Keep-Alive,Content-Type,accept,origin,X-Requested-With',
    );
    response.headers.add(
      'Access-Control-Allow-Credentials',
      'true',
    );
    try {
      final body = await utf8.decoder.bind(request).join();
      if (request.method == 'GET' && request.uri.path == '/${Keys.releases}') {
        request.response
          ..statusCode = HttpStatus.ok
          ..write(json.encode({
            'status': true,
            'data': (await releases.fetchLatest(null)).item1,
          }));
      } else {
        if (!await login.checkLogin(request)) {
          response
            ..statusCode = HttpStatus.ok
            ..write(json.encode({
              'status': false,
            }));
        } else {
          if (request.method == 'POST' &&
              request.uri.path == '/${Keys.device}') {
            final device = Device.fromJSON(json.decode(body));
            if (device.token == null ||
                device.language == null ||
                device.os == null) {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': false,
                }));
            } else {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': await devices.updateDevice(login, request, body),
                }));
            }
          } else if (request.method == 'POST' &&
              request.uri.path == '/${Keys.selection}') {
            final s = Selection.fromJSON(json.decode(body));
            if (s.selection == null) {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': false,
                }));
            } else {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': await selection.updateSelection(
                    (await login.getUser(request)).username,
                    body,
                  ),
                  'data': (await selection.getSelection(
                    (await login.getUser(request)).username,
                  ))
                      .toJSON(),
                }));
            }
          } else if (request.method == 'POST' &&
              request.uri.path == '/${Keys.settings}') {
            final s = Settings.fromJSON(json.decode(body));
            if (s.settings == null) {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': false,
                }));
            } else {
              response
                ..statusCode = HttpStatus.ok
                ..write(json.encode({
                  'status': await settings.updateSettings(login, request, body),
                  'data': await settings.getSettings(login, request),
                }));
            }
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.updates}') {
            await buildResponse(request, login, updates);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.user}') {
            await buildResponse(request, login, user);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.substitutionPlan}') {
            await buildResponse(request, login, substitutionPlan);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.timetable}') {
            await buildResponse(request, login, timetable);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.calendar}') {
            await buildResponse(request, login, calendar);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.aiXformation}') {
            await buildResponse(request, login, aiXformation);
          } else if (request.method == 'GET' &&
              request.uri.path == '/${Keys.cafetoria}') {
            await buildResponse(request, login, cafetoria);
          } else {
            response
              ..statusCode = HttpStatus.ok
              ..write('${request.method} ${request.uri} not found');
          }
        }
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      response
        ..statusCode = HttpStatus.ok
        ..write(json.encode({
          'status': false,
        }));
    }
    await response.close();
  }
}

Future buildResponse(
  HttpRequest request,
  LoginHandler login,
  Handler handler,
) async {
  final user = await login.getUser(request);
  request.response
    ..statusCode = HttpStatus.ok
    ..write(json.encode({
      'status': true,
      'data': (await handler.fetchLatest(user)).item1,
    }));
}

Future setupAutoFetchers(
  Logger log,
  MySqlConnection mySqlConnection, {
  @required List<Handler> minutely,
  @required List<Handler> hourly,
  @required List<Handler> daily,
}) async {
  Timer.periodic(
    Duration(minutes: 1),
    (a) => mySqlConnection.query('SELECT 1;'),
  );

  if (Config.fetchOnStart) {
    Timer.periodic(
      Duration(minutes: 1),
      (a) => callHandlers(log, minutely),
    );
    Timer.periodic(
      Duration(hours: 1),
      (a) => callHandlers(log, hourly),
    );
    Timer.periodic(
      Duration(days: 1),
      (a) => callHandlers(log, daily),
    );
    await callHandlers(log, minutely);
    await callHandlers(log, hourly);
    await callHandlers(log, daily);
  }
}

Future callHandlers(Logger log, List<Handler> handlers) async {
  for (final handler in handlers) {
    try {
      log.info('Fetching ${handler.name}');
      await handler.update();
      log.info('Fetched ${handler.name}');
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }
}
