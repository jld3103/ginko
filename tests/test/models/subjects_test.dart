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

    test('Get unknown subject successfully', () {
      expect(Subjects.getSubject(null), null);
      expect(Subjects.getSubject('test'), 'TEST');
    });
  });
}
