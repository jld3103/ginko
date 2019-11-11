import 'package:ginko/plugins/system_locale/system_locale_base.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

// ignore: public_member_api_docs
class SystemLocale extends SystemLocaleBase {
  @override
  Future setSystemLocale() async {
    Intl.defaultLocale = (await findSystemLocale()).split('_')[0];
  }
}
