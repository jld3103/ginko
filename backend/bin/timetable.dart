import 'package:backend/backend.dart';

import 'basic_handler_runner.dart';

Future main() async {
  await runBasic(
      'Timetable', (mySqlConnection) => TimetableHandler(mySqlConnection));
}
