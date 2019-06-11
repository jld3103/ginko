library models;

import 'package:intl/intl.dart';

export 'package:models/calendar.dart';
export 'package:models/keys.dart';
export 'package:models/replacementplan.dart';
export 'package:models/rooms.dart';
export 'package:models/subjects.dart';
export 'package:models/times.dart';
export 'package:models/unitplan.dart';

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

/// List of all weekdays
List<int> weekdays = [
  0,
  1,
  2,
  3,
  4,
];

/// German date format
DateFormat dateFormat = DateFormat('d.M.y');

/// Get the week number of a year by date
int weekNumber(DateTime date) {
  final dayOfYear = int.parse(DateFormat('D').format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}
