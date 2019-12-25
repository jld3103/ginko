import 'package:backend/backend.dart';

import 'basic_handler_runner.dart';

Future main() async {
  await runBasic(
    'Calendar',
    (mySqlConnection) => CalendarHandler(mySqlConnection),
  );
}
