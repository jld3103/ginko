import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('AiXformation', () {
    test('Can create AiXformation', () {
      final posts = AiXformation(
        date: DateTime(2019, 8, 10),
        posts: [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ),
        ],
      );
      expect(posts.date, DateTime(2019, 8, 10));
      expect(
        posts.posts.map((post) => post.toJSON()).toList(),
        [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ).toJSON()
        ],
      );
      expect(
        posts.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create posts from JSON', () {
      final posts = AiXformation.fromJSON({
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'posts': [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ).toJSON(),
        ],
      });
      expect(posts.date, DateTime(2019, 8, 10));
      expect(
        posts.posts.map((post) => post.toJSON()).toList(),
        [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ).toJSON()
        ],
      );
      expect(
        posts.timeStamp,
        DateTime(2019, 8, 10).millisecondsSinceEpoch ~/ 1000,
      );
    });

    test('Can create JSON from posts', () {
      final posts = AiXformation(
        date: DateTime(2019, 8, 10),
        posts: [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ),
        ],
      );
      expect(
        posts.toJSON(),
        {
          'date': DateTime(2019, 8, 10).toIso8601String(),
          'posts': [
            Post(
              id: 1,
              date: DateTime(2019, 8, 10),
              title: 'Test',
              content: 'Test bla bla',
              url: 'https://aixformation.de/1',
              thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
              mediumUrl: 'https://aixformation/1-medium.jpg',
              fullUrl: 'https://aixformation/1-full.jpg',
              author: 'Vitus',
              tags: ['Test', 'bla'],
            ).toJSON(),
          ],
        },
      );
    });

    test('Can create posts from JSON from posts', () {
      final posts = AiXformation(
        date: DateTime(2019, 8, 10),
        posts: [
          Post(
            id: 1,
            date: DateTime(2019, 8, 10),
            title: 'Test',
            content: 'Test bla bla',
            url: 'https://aixformation.de/1',
            thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
            mediumUrl: 'https://aixformation/1-medium.jpg',
            fullUrl: 'https://aixformation/1-full.jpg',
            author: 'Vitus',
            tags: ['Test', 'bla'],
          ),
        ],
      );
      expect(AiXformation.fromJSON(posts.toJSON()).toJSON(), posts.toJSON());
    });
  });

  group('Post', () {
    test('Can create post', () {
      final post = Post(
        id: 1,
        date: DateTime(2019, 8, 10),
        title: 'Test',
        content: 'Test bla bla',
        url: 'https://aixformation.de/1',
        thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
        mediumUrl: 'https://aixformation/1-medium.jpg',
        fullUrl: 'https://aixformation/1-full.jpg',
        author: 'Vitus',
        tags: ['Test', 'bla'],
      );
      expect(post.id, 1);
      expect(post.date, DateTime(2019, 8, 10));
      expect(post.title, 'Test');
      expect(post.content, 'Test bla bla');
      expect(post.url, 'https://aixformation.de/1');
      expect(post.thumbnailUrl, 'https://aixformation/1-thumbnail.jpg');
      expect(post.mediumUrl, 'https://aixformation/1-medium.jpg');
      expect(post.fullUrl, 'https://aixformation/1-full.jpg');
      expect(post.author, 'Vitus');
      expect(post.tags, ['Test', 'bla']);
    });

    test('Can create post from JSON', () {
      final post = Post.fromJSON({
        'id': 1,
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'title': 'Test',
        'content': 'Test bla bla',
        'url': 'https://aixformation.de/1',
        'thumbnailUrl': 'https://aixformation/1-thumbnail.jpg',
        'mediumUrl': 'https://aixformation/1-medium.jpg',
        'fullUrl': 'https://aixformation/1-full.jpg',
        'author': 'Vitus',
        'tags': ['Test', 'bla'],
      });
      expect(post.id, 1);
      expect(post.date, DateTime(2019, 8, 10));
      expect(post.title, 'Test');
      expect(post.content, 'Test bla bla');
      expect(post.url, 'https://aixformation.de/1');
      expect(post.thumbnailUrl, 'https://aixformation/1-thumbnail.jpg');
      expect(post.mediumUrl, 'https://aixformation/1-medium.jpg');
      expect(post.fullUrl, 'https://aixformation/1-full.jpg');
      expect(post.author, 'Vitus');
      expect(post.tags, ['Test', 'bla']);
    });

    test('Can create JSON from post', () {
      final post = Post(
        id: 1,
        date: DateTime(2019, 8, 10),
        title: 'Test',
        content: 'Test bla bla',
        url: 'https://aixformation.de/1',
        thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
        mediumUrl: 'https://aixformation/1-medium.jpg',
        fullUrl: 'https://aixformation/1-full.jpg',
        author: 'Vitus',
        tags: ['Test', 'bla'],
      );
      expect(post.toJSON(), {
        'id': 1,
        'date': DateTime(2019, 8, 10).toIso8601String(),
        'title': 'Test',
        'content': 'Test bla bla',
        'url': 'https://aixformation.de/1',
        'thumbnailUrl': 'https://aixformation/1-thumbnail.jpg',
        'mediumUrl': 'https://aixformation/1-medium.jpg',
        'fullUrl': 'https://aixformation/1-full.jpg',
        'author': 'Vitus',
        'tags': ['Test', 'bla'],
      });
    });

    test('Can create post from JSON from post', () {
      final post = Post(
        id: 1,
        date: DateTime(2019, 8, 10),
        title: 'Test',
        content: 'Test bla bla',
        url: 'https://aixformation.de/1',
        thumbnailUrl: 'https://aixformation/1-thumbnail.jpg',
        mediumUrl: 'https://aixformation/1-medium.jpg',
        fullUrl: 'https://aixformation/1-full.jpg',
        author: 'Vitus',
        tags: ['Test', 'bla'],
      );
      expect(Post.fromJSON(post.toJSON()).toJSON(), post.toJSON());
    });
  });
}
