import 'package:dio/dio.dart';
import 'package:models/models.dart';

// ignore: avoid_classes_with_only_static_members
/// ReleasesParser class
/// handles all releases parsing
class ReleasesParser {
  static const String _url =
      'https://api.github.com/repos/jld3103/ginko/releases/latest';
  static final Dio _dio = Dio()
    ..options = BaseOptions(
      responseType: ResponseType.plain,
    );

  /// Download releases list
  static Future<String> download(String token) async {
    final response = await _dio
        .get(_url, options: Options(headers: {'Authorization': 'token $token'}))
        .timeout(Duration(seconds: 10));
    return response.toString();
  }

  /// Extract releases
  // ignore: avoid_annotating_with_dynamic
  static Release extract(Map<String, dynamic> data) => Release(
        data['tag_name'].toString().substring(1),
        data['html_url'],
        DateTime.parse(data['published_at'].toString()),
        data['assets']
            .map((asset) => Asset(
                  asset['name'],
                  asset['browser_download_url'],
                ))
            .toList()
            .cast<Asset>(),
      );
}
