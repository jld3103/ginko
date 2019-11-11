// ignore: avoid_classes_with_only_static_members
/// Rooms class
/// describes all rooms
class Rooms {
  static final Map<String, String> _rooms = {
    'KLH': 'klH',
    'KL SPH': 'klH',
    'GRH': 'grH',
    'GR SPH': 'grH',
    'SB': 'schH',
    'SCHH': 'schH',
    'KU1': 'KU 1',
    'KU 1': 'KU 1',
    'KU2': 'KU 2',
    'KU 2': 'KU 2',
    'AULA': 'Aul',
    'AUL': 'Aul',
    'SLZ': 'SLZ',
    'WR': 'WerkR',
    'WERKR': 'WerkR',
    'TOI': 'Toi',
    '112': '112',
    '113': '113',
    '114': '114',
    '122': '122',
    '124': '124',
    '127': '127',
    '123': '123',
    '132': '132',
    '133': '133',
    '134': '134',
    '137': '137',
    '142': '142',
    '143': '143',
    '144': '144',
    '147': '147',
    '221': '221',
    '222': '222',
    '223': 'PC 1',
    'PC 1': 'PC 1',
    'PC1': 'PC 1',
    '322': 'PH 1',
    'PH 1': 'PH 1',
    '323': 'PH 2',
    'PH 2': 'PH 2',
    '501': 'MU 1',
    'MU 1': 'MU 1',
    '506': 'MU 2',
    'MU 2': 'MU 2',
    '511': '511',
    '513': '513',
    '514': '514',
    '515': '515',
    '516': '516',
    '517': '517',
    '521': '521',
    '522': '522',
    '523': '523',
    '524': '524',
    '525': '525',
    '526': '526',
    '527': '527',
    '528': 'PC 2',
    'PC 2': 'PC 2',
    'PC2': 'PC 2',
    '532': '532',
    '533': '533',
    '537': '537',
    '538': '538',
    'TOIL': 'WC',
    'TOILK': 'WC',
    'WC': 'WC',
  };

  // ignore: public_member_api_docs
  static Map<String, String> get rooms => _rooms;

  /// Gets a room by some variant of it's name
  static String getRoom(String name) {
    if (name == '????' || name == '' || name == null) {
      return '';
    }
    name = name.trim().toUpperCase();
    if (RegExp('^([ABCDEF])\$').hasMatch(name)) {
      return name;
    }
    if (_rooms[name] == null) {
      throw Exception('Unknown room $name');
    }
    return _rooms[name];
  }

  /// Get the regex to match all rooms
  static String get regex =>
      '(${_rooms.keys.toList().map((room) => room.toLowerCase()).join('|')})';
}
