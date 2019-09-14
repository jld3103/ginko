library models;

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

export 'package:models/aixformation.dart';
export 'package:models/cafetoria.dart';
export 'package:models/calendar.dart';
export 'package:models/keys.dart';
export 'package:models/replacementplan.dart';
export 'package:models/rooms.dart';
export 'package:models/subjects.dart';
export 'package:models/teachers.dart';
export 'package:models/times.dart';
export 'package:models/unitplan.dart';
export 'package:models/user.dart';

/// List of all grades
List<String> grades = [
  '5a',
  '5b',
  '5c',
  '6a',
  '6b',
  '6c',
  '7a',
  '7b',
  '7c',
  '8a',
  '8b',
  '8c',
  '9a',
  '9b',
  '9c',
  'EF',
  'Q1',
  'Q2',
];

/// Check if a grade is a senior grade
bool isSeniorGrade(String grade) =>
    grade == 'EF' || grade == 'Q1' || grade == 'Q2';

/// List of all weekdays
List<int> weekdays = [
  0,
  1,
  2,
  3,
  4,
];

/// The date format to display all dates in
DateFormat outputDateFormat = DateFormat('d.M.y');

var _dateFormats = [];

/// Setup all date formats used by the web server
Future setupDateFormats() async {
  await initializeDateFormatting('de', null);
  _dateFormats = [
    DateFormat.yMMMMd('de'),
    outputDateFormat,
  ];
}

/// Parse a date using any format used by the server
DateTime parseDate(String date) {
  for (final format in _dateFormats.cast<DateFormat>()) {
    try {
      try {
        if (format.parse(date).year < 2000) {
          date =
              // ignore: lines_longer_than_80_chars
              '${date.split('.')[0]}.${date.split('.')[1]}.${(int.parse(date.split('.')[2]) + 2000).toString()}';
        }
        // ignore: empty_catches
      } on Exception {}

      return format.parse(date);
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }
  throw FormatException('$date was not matching any date formats');
}

/// Get the week number of a year by date
int weekNumber(DateTime date) {
  final dayOfYear = int.parse(DateFormat('D').format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

/// Check if date is in week a
bool isWeekA(DateTime date) => (weekNumber(date) + 1) % 2 == 0;

/// Get the Monday of the week
/// Skips a week of weekend
DateTime monday(DateTime date) => date
    .subtract(Duration(
      days: date.weekday - 1,
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond,
      microseconds: date.microsecond,
    ))
    .add(Duration(days: date.weekday > 5 ? 7 : 0));
