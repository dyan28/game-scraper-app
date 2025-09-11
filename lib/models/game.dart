import 'dart:convert';

class Game {
  final String? appId;
  final String? title;
  final String? developer;
  final String? genreId;
  final String? version;
  final String? installs;
  final String? scoreText;
  final int? ratings;
  final int? reviews;
  final String? androidVersion;
  final String? androidMaxVersion;
  final String? androidVersionText;
  final String? contentRating;
  final String? contentRatingDescription;
  final String? released;
  final int? updated;
  final String? summary;
  final String? description;
  final String? icon;
  final String? headerImage;
  final List<String>? screenshots;
  final String? video;
  final String? videoImage;
  final String? previewVideo;
  final String? url;

  Game({
    this.appId,
    this.title,
    this.developer,
    this.genreId,
    this.version,
    this.installs,
    this.scoreText,
    this.ratings,
    this.reviews,
    this.androidVersion,
    this.androidMaxVersion,
    this.androidVersionText,
    this.contentRating,
    this.contentRatingDescription,
    this.released,
    this.updated,
    this.summary,
    this.description,
    this.icon,
    this.headerImage,
    this.screenshots,
    this.video,
    this.videoImage,
    this.previewVideo,
    this.url,
  });

  factory Game.fromRawJson(String str) => Game.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        appId: json["appId"],
        title: json["title"],
        developer: json["developer"],
        genreId: json["genreId"],
        version: json["version"],
        installs: json["installs"],
        scoreText: json["scoreText"],
        ratings: json["ratings"],
        reviews: json["reviews"],
        androidVersion: json["androidVersion"],
        androidMaxVersion: json["androidMaxVersion"],
        androidVersionText: json["androidVersionText"],
        contentRating: json["contentRating"],
        contentRatingDescription: json["contentRatingDescription"],
        released: json["released"],
        updated: json["updated"],
        summary: json["summary"],
        description: json["description"],
        icon: json["icon"],
        headerImage: json["headerImage"],
        screenshots: json["screenshots"] == null
            ? []
            : List<String>.from(json["screenshots"]!.map((x) => x)),
        video: json["video"],
        videoImage: json["videoImage"],
        previewVideo: json["previewVideo"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "title": title,
        "developer": developer,
        "genreId": genreId,
        "version": version,
        "installs": installs,
        "scoreText": scoreText,
        "ratings": ratings,
        "reviews": reviews,
        "androidVersion": androidVersion,
        "androidMaxVersion": androidMaxVersion,
        "androidVersionText": androidVersionText,
        "contentRating": contentRating,
        "contentRatingDescription": contentRatingDescription,
        "released": released,
        "updated": updated,
        "summary": summary,
        "description": description,
        "icon": icon,
        "headerImage": headerImage,
        "screenshots": screenshots == null
            ? []
            : List<dynamic>.from(screenshots!.map((x) => x)),
        "video": video,
        "videoImage": videoImage,
        "previewVideo": previewVideo,
        "url": url,
      };
}
