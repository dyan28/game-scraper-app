import 'dart:convert';

class Game {
  final int? id;
  final String? appId;
  final String? title;
  final String? description;
  final String? summary;
  final String? installs;
  final String? scoreText;
  final int? ratings;
  final int? reviews;
  final String? androidVersion;
  final String? androidVersionText;
  final String? developer;
  final String? genreId;
  final String? icon;
  final String? headerImage;
  final List<String>? screenshots;
  final String? released;
  final String? updated;
  final String? version;
  final String? url;
  final bool? inTop;

  Game({
    this.id,
    this.appId,
    this.title,
    this.description,
    this.summary,
    this.installs,
    this.scoreText,
    this.ratings,
    this.reviews,
    this.androidVersion,
    this.androidVersionText,
    this.developer,
    this.genreId,
    this.icon,
    this.headerImage,
    this.screenshots,
    this.released,
    this.updated,
    this.version,
    this.url,
    this.inTop,
  });

  factory Game.fromRawJson(String str) => Game.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json["id"],
        appId: json["app_id"],
        title: json["title"],
        description: json["description"],
        summary: json["summary"],
        installs: json["installs"],
        scoreText: json["score_text"],
        ratings: json["ratings"],
        reviews: json["reviews"],
        androidVersion: json["android_version"],
        androidVersionText: json["android_version_text"],
        developer: json["developer"],
        genreId: json["genre_id"],
        icon: json["icon"],
        headerImage: json["header_image"],
        screenshots: json["screenshots"] == null
            ? []
            : List<String>.from(json["screenshots"]!.map((x) => x)),
        released: json["released"],
        updated: json["updated"],
        version: json["version"],
        url: json["url"],
        inTop: json["in_top"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_id": appId,
        "title": title,
        "description": description,
        "summary": summary,
        "installs": installs,
        "score_text": scoreText,
        "ratings": ratings,
        "reviews": reviews,
        "android_version": androidVersion,
        "android_version_text": androidVersionText,
        "developer": developer,
        "genre_id": genreId,
        "icon": icon,
        "header_image": headerImage,
        "screenshots": screenshots == null
            ? []
            : List<dynamic>.from(screenshots!.map((x) => x)),
        "released": released,
        "updated": updated,
        "version": version,
        "url": url,
        "in_top": inTop,
      };
}
