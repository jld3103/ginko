import 'package:parsers/parsers.dart';
import 'package:test/test.dart';

void main() {
  test('Subjects parser has a name for every subject', () async {
    final unstfFile = await loadUNSTFFile();
    final subjects = SubjectsParser.extract(unstfFile);
    final timetable = TimetableParser.extract(unstfFile);
    for (final t in timetable.timetables) {
      for (final d in t.days) {
        for (final l in d.lessons) {
          for (final s in l.subjects) {
            expect(subjects.subjects[s.subject] != null, true);
          }
        }
      }
    }
  });
}
