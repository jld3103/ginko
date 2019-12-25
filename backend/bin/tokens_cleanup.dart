import 'package:backend/backend.dart';
import 'package:backend/src/notifications.dart';
import 'package:logging/logging.dart';
import 'package:mysql1/mysql1.dart';

Future main() async {
  Logging.setup();
  final log = Logger('Token cleanup');
  Config.load();
  log.info('Loaded config');
  final mySqlConnection = await MySqlConnection.connect(ConnectionSettings(
    host: Config.dbHost,
    port: Config.dbPort,
    user: Config.dbUsername,
    password: Config.dbPassword,
    db: Config.dbName,
  ));
  log.info('Connected to database');
  final results = await mySqlConnection
      .query('SELECT token, last_active FROM users_devices;');
  for (final row in results.toList()) {
    final token = row[0].toString();
    final lastActive = DateTime.parse(row[1].toString());
    final registered = (await Notifications.isTokenStillRegistered(token)) ||
        !(DateTime.now().difference(lastActive).inDays > 90);
    print('$token: $registered');
    if (!registered) {
      await mySqlConnection
          .query('DELETE FROM users_devices WHERE token = \'$token\';');
    }
  }
  await mySqlConnection.close();
}
