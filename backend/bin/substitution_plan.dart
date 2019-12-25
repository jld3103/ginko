import 'package:backend/backend.dart';

import 'basic_handler_runner.dart';

Future main() async {
  await runBasic(
    'Substitution plan',
    (mySqlConnection) => SubstitutionPlanHandler(
      mySqlConnection,
      TimetableHandler(mySqlConnection),
      SelectionHandler(mySqlConnection),
      SubjectsHandler(mySqlConnection),
    ),
  );
}
