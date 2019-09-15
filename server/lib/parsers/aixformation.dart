import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';

/// AiXformationParser class
/// handles all AiXformation parsing
class AiXformationParser {
  static const String _url = 'https://aixformation.de/wp-json/wp/v2';

  /// Download posts list
  static Future<String> download() async {
    final response =
        await http.get('$_url/posts').timeout(Duration(seconds: 10));
    return response.body;
  }

  /// Extract teachers
  // ignore: avoid_annotating_with_dynamic
  static Future<Posts> extract(dynamic data) async {
    final unescape = HtmlUnescape();
    final users = {};
    final media = {};
    final tags = {};
    final posts = Posts(
      date: DateTime.parse(data[0]['date']),
      posts: [],
    );
    for (final post in data) {
      if (users[post['author']] == null) {
        users[post['author']] = json.decode((await http
                .get('$_url/users/${post['author']}')
                .timeout(Duration(seconds: 10)))
            .body)['name'];
      }
      if (media[post['featured_media']] == null) {
        final sizes = json.decode((await http
                .get('$_url/media/${post['featured_media']}')
                .timeout(Duration(seconds: 10)))
            .body)['media_details']['sizes'];
        media[post['featured_media']] = {
          'thumbnail': sizes['thumbnail']['source_url'],
          'medium': sizes['medium']['source_url'],
          'full': sizes['full']['source_url'],
        };
      }
      for (final tag in post['tags']) {
        if (tags[tag] == null) {
          tags[tag] = json.decode(
              (await http.get('$_url/tags/$tag').timeout(Duration(seconds: 10)))
                  .body)['name'];
        }
      }
      posts.posts.add(Post(
        id: post['id'],
        date: DateTime.parse(post['date']),
        title: unescape.convert(post['title']['rendered']),
        content: unescape.convert(post['content']['rendered']),
        url: post['link'],
        thumbnailUrl: media[post['featured_media']]['thumbnail'],
        mediumUrl: media[post['featured_media']]['medium'],
        fullUrl: media[post['featured_media']]['full'],
        author: users[post['author']],
        tags: post['tags'].map((tagId) => tags[tagId]).toList().cast<String>(),
      ));
    }
    return posts;
  }
}
