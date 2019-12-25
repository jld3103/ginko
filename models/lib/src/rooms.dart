import 'package:meta/meta.dart';

/// Rooms class
/// describes all rooms
class Rooms {
  // ignore: public_member_api_docs
  Rooms({
    @required this.rooms,
    @required this.date,
  });

  /// Creates a Rooms object from json
  factory Rooms.fromJSON(json) => Rooms(
        rooms: json['rooms'],
        date: DateTime.parse(json['date']),
      );

  /// Creates json from a Rooms object
  Map<String, dynamic> toJSON() => {
        'rooms': rooms,
        'date': date.toIso8601String(),
      };

  /// Get the time stamp of this object
  int get timeStamp => date.millisecondsSinceEpoch ~/ 1000;

  // ignore: public_member_api_docs
  final Map<String, String> rooms;

  // ignore: public_member_api_docs
  final DateTime date;
}
