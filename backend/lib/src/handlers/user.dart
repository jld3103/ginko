import 'package:backend/backend.dart';
import 'package:models/models.dart';
import 'package:mysql1/mysql1.dart';
import 'package:tuple/tuple.dart';

/// UserHandler class
class UserHandler extends Handler {
  // ignore: public_member_api_docs
  UserHandler(MySqlConnection mySqlConnection)
      : super(Keys.user, mySqlConnection);

  @override
  Future<Tuple2<Map<String, dynamic>, String>> fetchLatest(User user) async =>
      Tuple2(user.toJSON(), '');
}
