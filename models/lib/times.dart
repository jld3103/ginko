/// Times class
/// handles all unit times
class Times {
  /// Return the start and end of a unit
  static List<Duration> getUnitTimes(int unit, bool short) {
    if (short) {
      return [];
    } else {
      Duration start;
      Duration end;
      switch (unit) {
        case 0:
          start = Duration(hours: 08, minutes: 00); // 08:00
          end = Duration(hours: 09, minutes: 00); // 09:00
          break;
        case 1:
          start = Duration(hours: 09, minutes: 10); // 09:10
          end = Duration(hours: 10, minutes: 10); // 10:10
          break;
        case 2:
          start = Duration(hours: 10, minutes: 30); // 10:30
          end = Duration(hours: 11, minutes: 30); // 11:30
          break;
        case 3:
          start = Duration(hours: 11, minutes: 40); // 11:40
          end = Duration(hours: 12, minutes: 40); // 12:40
          break;
        case 4:
          start = Duration(hours: 13, minutes: 00); // 13:00
          end = Duration(hours: 14, minutes: 00); // 14:00
          break;
        case 5:
          start = Duration(hours: 14, minutes: 00); // 14:00
          end = Duration(hours: 15, minutes: 00); // 15:00
          break;
        case 6:
          start = Duration(hours: 15, minutes: 00); // 15:00
          end = Duration(hours: 16, minutes: 00); // 16:00
          break;
        case 7:
          start = Duration(hours: 16, minutes: 05); // 16:05
          end = Duration(hours: 17, minutes: 05); // 17:05
          break;
      }
      return [start, end];
    }
  }
}
