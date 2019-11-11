import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// CalendarLoader class
class CalendarLoader extends Loader {
  // ignore: public_member_api_docs
  CalendarLoader() : super(Keys.calendar);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => Calendar.fromJSON(json);

  @override
  Calendar get data => object;
}
