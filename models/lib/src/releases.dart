/// Release class
class Release {
  // ignore: public_member_api_docs
  Release(
    this.version,
    this.url,
    this.published,
    this.assets,
  );

  // ignore: public_member_api_docs
  factory Release.fromJSON(json) => Release(
        json['version'],
        json['url'],
        DateTime.parse(json['published']),
        json['assets']
            .map((i) => Asset.fromJSON(i))
            .toList()
            .cast<Asset>()
            .toList(),
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'version': version,
        'url': url,
        'published': published.toIso8601String(),
        'assets': assets.map((i) => i.toJSON()).toList(),
      };

  // ignore: public_member_api_docs
  final String version;

  // ignore: public_member_api_docs
  final String url;

  // ignore: public_member_api_docs
  final DateTime published;

  // ignore: public_member_api_docs
  final List<Asset> assets;
}

/// Asset class
class Asset {
  // ignore: public_member_api_docs
  Asset(
    this.name,
    this.url,
  );

  // ignore: public_member_api_docs
  factory Asset.fromJSON(json) => Asset(
        json['name'],
        json['url'],
      );

  // ignore: public_member_api_docs
  Map<String, dynamic> toJSON() => {
        'name': name,
        'url': url,
      };

  // ignore: public_member_api_docs
  final String name;

  // ignore: public_member_api_docs
  final String url;
}
