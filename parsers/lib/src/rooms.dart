import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// RoomsParser class
/// handles all rooms parsing
class RoomsParser {
  /// Extract rooms
  static Rooms extract(List<List<String>> table) {
    final rooms = {};
    table
        .where((line) =>
            line[0].startsWith('R1') &&
            !line[2].toLowerCase().startsWith('pseu'))
        .forEach((line) => rooms[fix(line[2]
            .toLowerCase()
            .replaceAll('"', '')
            .replaceAll(' ', ''))] = line[3].replaceAll('"', ''));
    return Rooms(
      date: DateTime(2019, 12, 21),
      rooms: rooms.cast<String, String>(),
    );
  }

  /// Fix the formatting of a room
  static String fix(String originalRoom) {
    if (originalRoom.length > 3) {
      switch (originalRoom) {
        case 'aula':
          return 'aul';
        case 'klsph':
          return 'klh';
        case 'grsph':
          return 'grh';
        case 'oase':
          return 'oas';
        default:
          print('Unknown room $originalRoom');
          break;
      }
    }
    return originalRoom;
  }
}
