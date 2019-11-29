import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Release', () {
    test('Can create release', () {
      final release = Release(
        '1.1.1',
        'https://example.com',
        DateTime(2019, 11, 29, 12, 52),
        [
          Asset(
            'test.deb',
            'https://example.com/test.deb',
          ),
        ],
      );
      expect(release.version, '1.1.1');
      expect(release.url, 'https://example.com');
      expect(release.published, DateTime(2019, 11, 29, 12, 52));
      expect(
        release.assets.map((asset) => asset.toJSON()).toList(),
        [Asset('test.deb', 'https://example.com/test.deb').toJSON()],
      );
    });

    test('Can create release from JSON', () {
      final release = Release.fromJSON({
        'version': '1.1.1',
        'url': 'https://example.com',
        'published': DateTime(2019, 11, 29, 12, 52).toIso8601String(),
        'assets': [
          Asset(
            'test.deb',
            'https://example.com/test.deb',
          ).toJSON(),
        ],
      });
      expect(release.version, '1.1.1');
      expect(release.url, 'https://example.com');
      expect(release.published, DateTime(2019, 11, 29, 12, 52));
      expect(
        release.assets.map((asset) => asset.toJSON()).toList(),
        [Asset('test.deb', 'https://example.com/test.deb').toJSON()],
      );
    });

    test('Can create JSON from release', () {
      final release = Release(
        '1.1.1',
        'https://example.com',
        DateTime(2019, 11, 29, 12, 52),
        [
          Asset(
            'test.deb',
            'https://example.com/test.deb',
          ),
        ],
      );
      expect(
        release.toJSON(),
        {
          'version': '1.1.1',
          'url': 'https://example.com',
          'published': DateTime(2019, 11, 29, 12, 52).toIso8601String(),
          'assets': [
            Asset(
              'test.deb',
              'https://example.com/test.deb',
            ).toJSON(),
          ],
        },
      );
    });

    test('Can create release from JSON from release', () {
      final release = Release(
        '1.1.1',
        'https://example.com',
        DateTime(2019, 11, 29, 12, 52),
        [
          Asset(
            'test.deb',
            'https://example.com/test.deb',
          ),
        ],
      );
      expect(Release.fromJSON(release.toJSON()).toJSON(), release.toJSON());
    });
  });

  group('Asset', () {
    test('Can create asset', () {
      final asset = Asset(
        'test.deb',
        'https://example.com/test.deb',
      );
      expect(asset.name, 'test.deb');
      expect(asset.url, 'https://example.com/test.deb');
    });

    test('Can create asset from JSON', () {
      final asset = Asset.fromJSON({
        'name': 'test.deb',
        'url': 'https://example.com/test.deb',
      });
      expect(asset.name, 'test.deb');
      expect(asset.url, 'https://example.com/test.deb');
    });

    test('Can create JSON from asset', () {
      final asset = Asset(
        'test.deb',
        'https://example.com/test.deb',
      );
      expect(
        asset.toJSON(),
        {
          'name': 'test.deb',
          'url': 'https://example.com/test.deb',
        },
      );
    });

    test('Can create asset from JSON from asset', () {
      final asset = Asset(
        'test.deb',
        'https://example.com/test.deb',
      );
      expect(Asset.fromJSON(asset.toJSON()).toJSON(), asset.toJSON());
    });
  });
}
