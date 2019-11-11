import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:backend/backend.dart';
import 'package:colorize/colorize.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

Future main(List<String> args) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    if ((rec.loggerName == 'BufferedSocket' ||
            rec.loggerName == 'AuthHandler' ||
            rec.loggerName == 'MySqlConnection' ||
            rec.loggerName == 'QueryStreamHandler' ||
            rec.loggerName == 'StandardDataPacket') &&
        rec.level.name == 'FINE') {
      return;
    }
    final text = Colorize(
        // ignore: lines_longer_than_80_chars
        '[${rec.loggerName}] ${rec.time.toIso8601String()} ${rec.level.name}: ${rec.message}');
    switch (rec.level.name) {
      case 'WARNING':
        text.yellow();
        break;
      case 'INFO':
        text.green();
        break;
    }
    print(text);
  });

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

  final config = Config()
    ..load()
    ..fetchOnStart = results['fetch']
    ..verbose = results['verbose'];
  log.info('Loaded config.');

  final mysqlConnection = await MySqlConnection.connect(ConnectionSettings(
    host: config.dbHost,
    port: config.dbPort,
    user: config.dbUsername,
    password: config.dbPassword,
    db: config.dbName,
  ));
  log.info('Connected to database.');
  await Database.createDefaultTables(mysqlConnection);

  final server = await HttpServer.bind(InternetAddress.anyIPv4, config.port);

  final login = LoginHandler(mysqlConnection);
  final user = UserHandler(mysqlConnection);
  final devices = DevicesHandler(mysqlConnection);
  final selection = SelectionHandler(mysqlConnection);

  final substitutionPlan = SubstitutionPlanHandler(mysqlConnection);
  final timetable = TimetableHandler(mysqlConnection);
  final calendar = CalendarHandler(mysqlConnection);
  final teachers = TeachersHandler(mysqlConnection);
  final aiXformation = AiXformationHandler(mysqlConnection);
  final cafetoria = CafetoriaHandler(mysqlConnection);
  final updates = UpdatesHandler(mysqlConnection, [
    substitutionPlan,
    timetable,
    calendar,
    teachers,
    aiXformation,
    cafetoria,
  ]);
  await setupDateFormats();

  await setupAutoFetchers(
    log,
    config,
    mysqlConnection,
    minutely: [substitutionPlan],
    hourly: [aiXformation],
    daily: [timetable, calendar, teachers, cafetoria],
  );

  log.info('Serving on *:${config.port}');

  await for (final request in server) {
    if (config.verbose) {
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
      if (!await login.checkLogin(request)) {
        response
          ..statusCode = request.method == 'OPTIONS'
              ? HttpStatus.ok
              : HttpStatus.unauthorized
          ..write(json.encode({
            'status': false,
          }));
      } else {
        if (request.method == 'POST' && request.uri.path == '/${Keys.device}') {
          final device = Device.fromJSON(json.decode(body));
          if (device.token == null ||
              device.language == null ||
              device.os == null) {
            response
              ..statusCode = request.method == 'OPTIONS'
                  ? HttpStatus.ok
                  : HttpStatus.badRequest
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
              ..statusCode = request.method == 'OPTIONS'
                  ? HttpStatus.ok
                  : HttpStatus.badRequest
              ..write(json.encode({
                'status': false,
              }));
          } else {
            response
              ..statusCode = HttpStatus.ok
              ..write(json.encode({
                'status': await selection.updateSelection(login, request, body),
                'data': await selection.getSelection(login, request),
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
            request.uri.path == '/${Keys.teachers}') {
          await buildResponse(request, login, teachers);
        } else if (request.method == 'GET' &&
            request.uri.path == '/${Keys.aiXformation}') {
          await buildResponse(request, login, aiXformation);
        } else if (request.method == 'GET' &&
            request.uri.path == '/${Keys.cafetoria}') {
          await buildResponse(request, login, cafetoria);
        } else {
          response
            ..statusCode = request.method == 'OPTIONS'
                ? HttpStatus.ok
                : HttpStatus.notFound
            ..write('${request.method} ${request.uri} not found');
        }
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      response
        ..statusCode =
            request.method == 'OPTIONS' ? HttpStatus.ok : HttpStatus.badRequest
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
  Config config,
  MySqlConnection mysqlConnection, {
  @required List<Handler> minutely,
  @required List<Handler> hourly,
  @required List<Handler> daily,
}) async {
  Timer.periodic(
    Duration(minutes: 1),
    (a) => mysqlConnection.query('SELECT 1;'),
  );

  Timer.periodic(
    Duration(minutes: 1),
    (a) => callHandlers(log, minutely, config),
  );
  Timer.periodic(
    Duration(hours: 1),
    (a) => callHandlers(log, hourly, config),
  );
  Timer.periodic(
    Duration(days: 1),
    (a) => callHandlers(log, daily, config),
  );
  if (config.fetchOnStart) {
    await callHandlers(log, minutely, config);
    await callHandlers(log, hourly, config);
    await callHandlers(log, daily, config);
  }
}

Future callHandlers(Logger log, List<Handler> handlers, Config config) async {
  for (final handler in handlers) {
    try {
      log.info('Fetching ${handler.name}');
      await handler.update(config);
      log.info('Fetched ${handler.name}');
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }
}
