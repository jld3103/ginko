import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';
import 'package:models/models.dart';
import 'package:tuple/tuple.dart';

// ignore: avoid_classes_with_only_static_members
/// AiXformationParser class
/// handles all AiXformation parsing
class AiXformationParser {
  static const String _url = 'https://aixformation.de/wp-json/wp/v2';
  static final Dio _dio = Dio()
    ..options = BaseOptions(
      responseType: ResponseType.plain,
    );

  /// Download posts list
  static Future<String> download() async {
    final response =
        await _dio.get('$_url/posts').timeout(Duration(seconds: 10));
    return response.toString();
  }

  /// Extract posts
  static Future<Tuple2<AiXformation, Map<String, dynamic>>> extract(
    // ignore: avoid_annotating_with_dynamic
    dynamic data, {
    Map<String, dynamic> cache,
  }) async {
    final unescape = HtmlUnescape();
    cache = cache ??
        {
          'users': {},
          'media': {},
          'tags': {},
        };
    final users = cache['users'];
    final media = cache['media'];
    final tags = cache['tags'];
    final posts = AiXformation(
      date: DateTime.parse(data[0]['date']),
      posts: [],
    );
    for (final post in data) {
      if (users[post['author'].toString()] == null) {
        final url = '$_url/users/${post['author']}';
        try {
          users[post['author'].toString()] = json.decode(
              (await _dio.get(url).timeout(Duration(seconds: 10)))
                  .toString())['name'];
        } on DioError catch (e, stacktrace) {
          print(url);
          print(e.response);
          print(e);
        }
      }
      if (media[post['featured_media'].toString()] == null) {
        final url = '$_url/media/${post['featured_media']}';
        try {
          final sizes = json.decode(
              (await _dio.get(url).timeout(Duration(seconds: 10)))
                  .toString())['media_details']['sizes'];
          media[post['featured_media'].toString()] = {
            'thumbnail': sizes['thumbnail']['source_url'],
            'medium': sizes['medium']['source_url'],
            'full': sizes['full']['source_url'],
          };
        } on DioError catch (e, stacktrace) {
          print(url);
          print(e.response);
          print(e);
          media[post['featured_media'].toString()] = {
            'thumbnail': post['jetpack_featured_media_url'],
            'medium': post['jetpack_featured_media_url'],
            'full': post['jetpack_featured_media_url'],
          };
        }
      }
      for (final tag in post['tags']) {
        if (tags[tag.toString()] == null) {
          final url = '$_url/tags/$tag';
          try {
            tags[tag.toString()] = json.decode(
                (await _dio.get(url).timeout(Duration(seconds: 10)))
                    .toString())['name'];
          } on DioError catch (e, stacktrace) {
            print(url);
            print(e.response);
            print(e);
          }
        }
      }
      try {
        final document = parse(unescape.convert(post['content']['rendered']));
        posts.posts.add(Post(
          id: post['id'],
          date: DateTime.parse(post['date']),
          title: unescape.convert(post['title']['rendered']),
          content: document.outerHtml,
          url: post['link'],
          thumbnailUrl: media[post['featured_media'].toString()]['thumbnail'],
          mediumUrl: media[post['featured_media'].toString()]['medium'],
          fullUrl: media[post['featured_media'].toString()]['full'],
          author: users[post['author'].toString()],
          tags: post['tags']
              .map((tagId) => tags[tagId.toString()])
              .toList()
              .cast<String>(),
        ));
        // ignore: avoid_catches_without_on_clauses
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
      }
    }
    cache = {
      'users': users,
      'media': media,
      'tags': tags,
    };
    return Tuple2<AiXformation, Map<String, dynamic>>(posts, cache);
  }
}
