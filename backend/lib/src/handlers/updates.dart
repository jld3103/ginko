import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:tuple/tuple.dart';

/// UpdatesHandler class
class UpdatesHandler extends Handler {
  // ignore: public_member_api_docs
  UpdatesHandler(MySqlConnection mySqlConnection, this._handlers)
      : super(Keys.updates, mySqlConnection);

  final List<Handler> _handlers;

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async {
    final data = {};
    for (final handler in _handlers) {
      data[handler.name] = await handler.fetchLatestResourceID(user);
    }
    return Tuple2(data.cast<String, dynamic>(), data.values.join(''));
  }

  @override
  // ignore: missing_return
  Future update(Config config) {}
}
