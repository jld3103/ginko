import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

/// AppLocalization class
/// handles all the translations
class AppLocalization {
  // ignore: public_member_api_docs
  AppLocalization(this._locale);

  final Locale _locale;

  // ignore: public_member_api_docs
  Locale get getLocale => _locale;

  // ignore: public_member_api_docs
  static AppLocalization of(BuildContext context) =>
      Localizations.of<AppLocalization>(context, AppLocalization);

  static final Map<String, Map<String, dynamic>> _localizedValues = {
    'de': {
      'loading': {
        'title': 'Laden',
      },
      'home': {
        'offline': 'Eventuell werden alte Daten angezeigt',
        'week': 'Woche',
        'newReplacementPlan': 'Neuer Vertretungsplan!',
      },
      'login': {
        'username_required': 'Benutzername erforderlich',
        'password_required': 'Password erforderlich',
        'failed': 'Deine Anmeldung konnte nicht überprüft werden',
        'username': 'Nutzername',
        'password': 'Passwort',
        'credentials_wrong': 'Die Anmeldedaten sind falsch',
        'submit': 'Anmelden',
        'errorOccurred': 'Ein Fehler ist aufgetreten',
      },
      'subjects': {
        'BI': 'Bio',
        'CH': 'Chemie',
        'POWI': 'PoWi',
        'DF': 'Deutsch Förder',
        'NW': 'NW',
        'D': 'Deutsch',
        'ER': 'E. Reli',
        'EK': 'Erdkunde',
        'EF': 'Englisch Förder',
        'E': 'Englisch',
        'FS': 'Schreibwerkstatt',
        'FR': 'Freistunde',
        'FÖ': 'Förder',
        'FF': 'Französisch Förder',
        'F': 'Französisch',
        'GE': 'Geschichte',
        'IF': 'Informatik',
        'KU': 'Kunst',
        'KR': 'K. Reli',
        'LF': 'Latein Förder',
        'L': 'Latein',
        'MU': 'Musik',
        'MIT': 'Mittagspause',
        'MINT': 'Mint',
        'MF': 'Mathe Förder',
        'MC': 'M. Chor',
        'M': 'Mathe',
        'ORI': 'Ori',
        'PJD': 'Projektkurs Deutsch',
        'PJ': 'Projektkurs',
        'PL': 'Philosophie',
        'PK': 'Politik',
        'PH': 'Physik',
        'SOWI': 'SoWi',
        'SP': 'Sport',
        'SG': 'Streichergruppe',
        'S': 'Spanisch',
        'UC': 'U. Chor',
        'VM': 'Vertiefung Mathe',
        'VE': 'Vertiefung Englisch',
        'VD': 'Vertiefung Deutsch',
        'none': 'Keine Stunde ausgewählt'
      },
      'weekdays': [
        'Montag',
        'Dienstag',
        'Mittwoch',
        'Donnerstag',
        'Freitag',
        'Samstag',
        'Sonntag',
      ],
      'app_name': 'Ginko',
      'ok': 'OK'
    },
  };

  // ignore: public_member_api_docs
  String get loadingTitle =>
      _localizedValues[_locale.languageCode]['loading']['title'];

  // ignore: public_member_api_docs
  String get homeOffline =>
      _localizedValues[_locale.languageCode]['home']['offline'];

  // ignore: public_member_api_docs
  String get homeWeek => _localizedValues[_locale.languageCode]['home']['week'];

  // ignore: public_member_api_docs
  String get homeNewReplacementPlan =>
      _localizedValues[_locale.languageCode]['home']['newReplacementPlan'];

  // ignore: public_member_api_docs
  String get loginUsernameRequired =>
      _localizedValues[_locale.languageCode]['login']['username_required'];

  // ignore: public_member_api_docs
  String get loginPasswordRequired =>
      _localizedValues[_locale.languageCode]['login']['password_required'];

  // ignore: public_member_api_docs
  String get loginFailed =>
      _localizedValues[_locale.languageCode]['login']['failed'];

  // ignore: public_member_api_docs
  String get loginUsername =>
      _localizedValues[_locale.languageCode]['login']['username'];

  // ignore: public_member_api_docs
  String get loginPassword =>
      _localizedValues[_locale.languageCode]['login']['password'];

  // ignore: public_member_api_docs
  String get loginCredentialsWrong =>
      _localizedValues[_locale.languageCode]['login']['credentials_wrong'];

  // ignore: public_member_api_docs
  String get loginSubmit =>
      _localizedValues[_locale.languageCode]['login']['submit'];

  // ignore: public_member_api_docs
  String get loginErrorOccurred =>
      _localizedValues[_locale.languageCode]['login']['errorOccurred'];

  // ignore: public_member_api_docs
  String subject(String abbr) =>
      _localizedValues[_locale.languageCode]['subjects'][abbr];

  // ignore: public_member_api_docs
  String weekday(int day) =>
      _localizedValues[_locale.languageCode]['weekdays'][day];

  // ignore: public_member_api_docs
  List<String> get weekdays =>
      _localizedValues[_locale.languageCode]['weekdays'];

  // ignore: public_member_api_docs
  String get appName => _localizedValues[_locale.languageCode]['app_name'];

  // ignore: public_member_api_docs
  String get ok => _localizedValues[_locale.languageCode]['ok'];
}

/// _Delegate class
class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) => ['de'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) =>
      SynchronousFuture<AppLocalization>(AppLocalization(locale));

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
