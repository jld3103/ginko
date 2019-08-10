import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('times', () {
    test('Normal lesson times are correct', () {
      final times = List.generate(8, Times.getUnitTimes);
      for (var i = 0; i < times.length; i++) {
        expect(
          times[i][1],
          Duration(
            hours: times[i][0].inHours + 1,
            minutes: times[i][0].inMinutes % 60,
          ),
        );
        // Last lesson doesn't have a break afterwards
        if (i < 7) {
          expect(
            times[i + 1][0],
            Duration(
              hours: times[i][1].inHours,
              minutes: times[i][1].inMinutes % 60 +
                  (i < 4 ? (i.isEven ? 10 : 20) : (i == 4 || i == 5 ? 0 : 5)),
            ),
          );
        }
      }
      expect(Times.getUnitTimes(-1)[0].inMicroseconds, 0);
      expect(Times.getUnitTimes(-1)[1].inMicroseconds, 0);
    });

    test('Short lesson times are correct', () {
      final times = List.generate(8, (i) => Times.getUnitTimes(i, true));
      for (var i = 0; i < times.length; i++) {
        expect(
          times[i][1],
          Duration(
            hours: times[i][0].inHours,
            minutes: times[i][0].inMinutes % 60 + (i == 5 ? 60 : 45),
          ),
        );
        // Last lesson doesn't have a break afterwards
        if (i < 7) {
          expect(
            times[i + 1][0],
            Duration(
              hours: times[i][1].inHours,
              minutes: times[i][1].inMinutes % 60 +
                  (i < 4 ? (i.isEven ? 10 : 20) : (i == 4 || i == 5 ? 0 : 5)),
            ),
          );
        }
      }
      expect(Times.getUnitTimes(-1, true)[0].inMicroseconds, 0);
      expect(Times.getUnitTimes(-1, true)[1].inMicroseconds, 0);
    });
  });
}
