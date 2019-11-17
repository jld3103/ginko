import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ginko/utils/static.dart';
import 'package:models/models.dart';

// ignore: public_member_api_docs
abstract class Loader {
  // ignore: public_member_api_docs
  Loader(this.key);

  // ignore: public_member_api_docs
  final String key;

  // ignore: public_member_api_docs
  dynamic object;

  // ignore: public_member_api_docs, type_annotate_public_apis
  dynamic get body => null;

  // ignore: public_member_api_docs, type_annotate_public_apis, always_declare_return_types
  fromJSON(json);

  // ignore: public_member_api_docs
  dynamic toJSON() => data.toJSON();

  // ignore: public_member_api_docs
  dynamic get data => null;

  /// Whether the data should be posted to the server
  bool post = false;

  bool _loadedFromOnline = false;

  // ignore: public_member_api_docs
  void loadOffline() {
    if (Static.storage.has(key) && Static.storage.getString(key) != null) {
      object = fromJSON(Static.storage.getJSON(key));
    }
  }

  // ignore: public_member_api_docs
  Future<bool> forceLoadOnline([String username, String password]) =>
      loadOnline(username, password, true);

  // ignore: public_member_api_docs
  Future<bool> loadOnline(
      [String username, String password, bool force = false]) async {
    if (Static.user.object == null &&
        (username == null || password == null) &&
        !force) {
      return false;
    }
    if (_loadedFromOnline && !force) {
      return true;
    }
    username ??= Static.user.data?.username;
    password ??= Static.user.data?.password;
    const baseUrl = 'https://api.app.viktoria.schule';
    try {
      final dio = Dio()
        ..options = BaseOptions(
          headers: {
            'authorization':
                // ignore: lines_longer_than_80_chars
                'Basic ${base64.encode(utf8.encode('$username:$password'))}',
          },
          responseType: ResponseType.plain,
        );
      Response response;
      if (post) {
        response = await dio
            .post(
              '$baseUrl/$key',
              data: body,
            )
            .timeout(Duration(seconds: 10));
      } else {
        response = await dio
            .get(
              '$baseUrl/$key',
            )
            .timeout(Duration(seconds: 10));
      }
      Static.online = true;
      final data = json.decode(response.toString());
      final credentialsCorrect = data['status'];
      if (credentialsCorrect) {
        if (key == Keys.user && password == null) {
          password = object.password;
        }
        if (data['data'] != null) {
          object = fromJSON(data['data']);
        }
        if (key == Keys.user && password != null) {
          object.password = password;
        }
        save();
        _loadedFromOnline = true;
      } else {
        print('$key failed to load');
      }
      return credentialsCorrect;
    } on DioError catch (e) {
      Static.online = false;
      print(e);
      print(e.response);
      rethrow;
    }
  }

  // ignore: public_member_api_docs
  void save() {
    if (data == null) {
      Static.storage.setString(key, null);
    } else {
      Static.storage.setJSON(key, toJSON());
    }
  }
}
