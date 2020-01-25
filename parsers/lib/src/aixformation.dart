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
    final response = await _dio
        .get('$_url/posts?per_page=100')
        .timeout(Duration(seconds: 10));
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
        } on DioError catch (e) {
          print(url);
          print(e.response);
          print(e);
        }
      }
      var mediaID = '';
      if (post['featured_media'].toString() == '0') {
        if (post['jetpack_featured_media_url'] == '') {
          mediaID = post['id'].toString();
        } else {
          mediaID = post['featured_media'].toString();
        }
      } else {
        mediaID = post['featured_media'].toString();
      }
      if (mediaID == '') {
        throw Exception('Media ID not set');
      }
      if (media[mediaID] == null) {
        if (post['featured_media'].toString() == '0') {
          if (post['jetpack_featured_media_url'] == '') {
            final content = parse(
                (await _dio.get(post['link']).timeout(Duration(seconds: 10)))
                    .toString());
            final imgs = content
                .querySelectorAll('img')
                .where((e) => e.attributes['data-src'] != null)
                .map((e) => e.attributes['data-src'])
                .where((l) => l.startsWith('//'))
                .map((l) => 'https:$l')
                .toList();
            media[mediaID] = {
              'thumbnail': imgs[0],
              'medium': imgs[0],
              'full': imgs[0],
            };
          } else {
            media[mediaID] = {
              'thumbnail': post['jetpack_featured_media_url'],
              'medium': post['jetpack_featured_media_url'],
              'full': post['jetpack_featured_media_url'],
            };
          }
        } else {
          final url = '$_url/media/${post['featured_media']}';
          try {
            final sizes = json.decode(
                (await _dio.get(url).timeout(Duration(seconds: 10)))
                    .toString())['media_details']['sizes'];
            media[mediaID] = {
              'thumbnail': sizes['thumbnail']['source_url'],
              'medium': sizes['medium']['source_url'],
              'full': sizes['full']['source_url'],
            };
          } on DioError catch (e) {
            print(url);
            print(e.response);
            print(e);
            media[mediaID] = {
              'thumbnail': post['jetpack_featured_media_url'],
              'medium': post['jetpack_featured_media_url'],
              'full': post['jetpack_featured_media_url'],
            };
          }
        }
      }
      for (final tag in post['tags']) {
        if (tags[tag.toString()] == null) {
          final url = '$_url/tags/$tag';
          try {
            tags[tag.toString()] = json.decode(
                (await _dio.get(url).timeout(Duration(seconds: 10)))
                    .toString())['name'];
          } on DioError catch (e) {
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
          content: document.outerHtml
              .replaceAll(RegExp('<script.*script>'), '')
              .replaceAll('″', '\"'),
          url: post['link'],
          thumbnailUrl: media[mediaID]['thumbnail'],
          mediumUrl: media[mediaID]['medium'],
          fullUrl: media[mediaID]['full'],
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
