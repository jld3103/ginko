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
    'SP': 'SP',
    'SN': 'SOWI',
    'SG': 'SG',
    'S': 'S',
    'UC': 'UC',
    'VM': 'VM',
    'VE': 'VE',
    'VD': 'VD'
  };

  /// Gets a subject by some variant of it's name
  static String getSubject(String name) {
    if (name == null) {
      return null;
    }
    // ignore: parameter_assignments
    name = name.trim().toUpperCase().replaceAll(RegExp('[0-9]'), '');
    if (_subjects[name] == null) {
      if (name != '') {
        print('Unknown subject $name');
      }
      return name;
    }
    return _subjects[name];
  }
}
