// ignore: avoid_classes_with_only_static_members
/// Subjects class
/// describes all subjects
class Subjects {
  static final Map<String, String> _subjects = {
    'BI': 'BI',
    'CH': 'CH',
    'DP': 'POWI',
    'DFÖ': 'DF',
    'DF': 'DF',
    'DB': 'NW',
    'D': 'D',
    'ER': 'ER',
    'EK': 'EK',
    'EF': 'EF',
    'E': 'E',
    'FS': 'FS',
    'FR': 'FR',
    'FÖ': 'FÖ',
    'FF': 'FF',
    'F': 'F',
    'GE': 'GE',
    'IV': 'MU',
    'IF': 'IF',
    'KW': 'KU',
    'KU': 'KU',
    'KR': 'KR',
    'LF': 'LF',
    'L': 'L',
    'MU': 'MU',
    'MIT': 'MIT',
    'MINT': 'MINT',
    'MI': 'MINT',
    'MF': 'MF',
    'MC': 'MC',
    'M': 'M',
    'NWP': 'NW',
    'NWB': 'NW',
    'NW': 'NW',
    'ORI': 'ORI',
    'OR': 'ORI',
    'POW': 'POWI',
    'POWI': 'POWI',
    'PO': 'POWI',
    'PJD': 'PJD',
    'PJ': 'PJ',
    'PL': 'PL',
    'PK': 'PK',
    'PH': 'PH',
    'SW': 'SOWI',
    'SOWI': 'SOWI',
    'SP': 'SP',
    'SN': 'SOWI',
    'SG': 'SG',
    'S': 'S',
    'UC': 'UC',
    'VM': 'VM',
    'VE': 'VE',
    'VD': 'VD'
  };

  // ignore: public_member_api_docs
  static Map<String, String> get subjects => _subjects;

  /// Gets a subject by some variant of it's name
  static String getSubject(String name) {
    name = name.trim().toUpperCase().replaceAll(RegExp('[ÖÄÜ0-9]'), '');
    if (_subjects[name] == null) {
      throw Exception('Unknown subject $name');
    }
    return _subjects[name];
  }

  /// Get the regex to match all subjects
  static String get regex =>
      // ignore: lines_longer_than_80_chars
      '(${_subjects.keys.toList().map((subject) => subject.toLowerCase()).join('|')})';
}
