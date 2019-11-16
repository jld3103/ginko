import 'package:backend/backend.dart';
import 'package:logging/logging.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';

typedef HandlerCallback = Handler Function(MySqlConnection mySqlConnection);

Future runBasic(String name, HandlerCallback callback) async {
  Logging.setup();
  final log = Logger(name);
  Config.load();
  log.info('Loaded config');
  await setupDateFormats();
  final mySqlConnection = await MySqlConnection.connect(ConnectionSettings(
    host: Config.dbHost,
    port: Config.dbPort,
    user: Config.dbUsername,
    password: Config.dbPassword,
    db: Config.dbName,
  ));
  log.info('Connected to database');
  await Database.createDefaultTables(mySqlConnection);
  final handler = callback(mySqlConnection);
  log.info('Fetching ${handler.name}');
  await handler.update();
  log.info('Fetched ${handler.name}');
  await mySqlConnection.close();
}
