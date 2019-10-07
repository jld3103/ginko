import 'dart:convert';
import 'dart:io';

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
    final file = File('aixformation.json');
    var d = file.existsSync()
        ? json.decode(file.readAsStringSync())
        : {
            'users': {},
            'media': {},
            'tags': {},
          };
    final users = d['users'];
    final media = d['media'];
    final tags = d['tags'];
    final posts = Posts(
      date: DateTime.parse(data[0]['date']),
      posts: [],
    );
    var usersFailed = false;
    var mediaFailed = false;
    var tagsFailed = false;
    for (final post in data) {
      if (users[post['author'].toString()] == null && !usersFailed) {
        try {
          users[post['author'].toString()] = json.decode((await http
                  .get('$_url/users/${post['author']}')
                  .timeout(Duration(seconds: 10)))
              .body)['name'];
        } on FormatException catch (e, stacktrace) {
          print(e);
          print(stacktrace);
          usersFailed = true;
        }
      }
      if (media[post['featured_media'].toString()] == null && !mediaFailed) {
        try {
          final sizes = json.decode((await http
                  .get('$_url/media/${post['featured_media']}')
                  .timeout(Duration(seconds: 10)))
              .body)['media_details']['sizes'];
          media[post['featured_media'].toString()] = {
            'thumbnail': sizes['thumbnail']['source_url'],
            'medium': sizes['medium']['source_url'],
            'full': sizes['full']['source_url'],
          };
        } on FormatException catch (e, stacktrace) {
          print(e);
          print(stacktrace);
          mediaFailed = true;
        }
      }
      for (final tag in post['tags']) {
        if (tags[tag.toString()] == null && !tagsFailed) {
          try {
            tags[tag.toString()] = json.decode((await http
                    .get('$_url/tags/$tag')
                    .timeout(Duration(seconds: 10)))
                .body)['name'];
          } on FormatException catch (e, stacktrace) {
            print(e);
            print(stacktrace);
            tagsFailed = true;
          }
        }
      }
      posts.posts.add(Post(
        id: post['id'],
        date: DateTime.parse(post['date']),
        title: unescape.convert(post['title']['rendered']),
        content: unescape.convert(post['content']['rendered']),
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
    }
    d = {
      'users': users,
      'media': media,
      'tags': tags,
    };
    file.writeAsStringSync(json.encode(d));
    return posts;
  }
}
