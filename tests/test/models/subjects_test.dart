import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Subjects', () {
    test('Get subject successfully', () {
      expect(Subjects.getSubject('bi'), 'BI');
    });

    test('Get subject with wrong formatting successfully', () {
      expect(Subjects.getSubject('BI'), 'BI');
      expect(Subjects.getSubject('E5'), 'E');
      expect(Subjects.getSubject(' BI '), 'BI');
    });

    test('Cannot get unknown subject without error', () {
      expect(() => Subjects.getSubject(null),
          throwsA(TypeMatcher<NoSuchMethodError>()));
      expect(
          () => Subjects.getSubject('test'), throwsA(TypeMatcher<Exception>()));
    });

    test('Get subjects successfully', () {
      expect(Subjects.subjects.isNotEmpty, true);
    });
  });
}
