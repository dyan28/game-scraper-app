import 'dart:convert';

import 'package:tap_two_play/utils/utils.dart';

class Game {
  final String? appId;
  final String? title;
  final String? developer;
  final String? genreId;
  final String? version;
  final String? installs;
  final String? scoreText;
  final String? ratings;
  final String? reviews;
  final String? androidVersion;
  final String? androidMaxVersion;
  final String? androidVersionText;
  final String? contentRating;
  final String? contentRatingDescription;
  final String? released;
  final String? updated;
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
        appId: json["appId"].toString(),
        title: json["title"].toString(),
        developer: json["developer"].toString(),
        genreId: json["genreId"].toString(),
        version: json["version"].toString(),
        installs: json["installs"].toString(),
        scoreText: json["scoreText"].toString(),
        ratings: json["ratings"].toString(),
        reviews: json["reviews"].toString(),
        androidVersion: json["androidVersion"].toString(),
        androidMaxVersion: json["androidMaxVersion"].toString(),
        androidVersionText: json["androidVersionText"].toString(),
        contentRating: json["contentRating"].toString(),
        contentRatingDescription: json["contentRatingDescription"].toString(),
        released: json["released"].toString(),
        updated: json["updated"].toString(),
        summary: json["summary"].toString(),
        description: json["description"].toString(),
        icon: json["icon"].toString(),
        headerImage: json["headerImage"].toString(),
        screenshots: json["screenshots"] == null
            ? []
            : Util.toUrlList(json["screenshots"]),
        video: json["video"].toString(),
        videoImage: json["videoImage"].toString(),
        previewVideo: json["previewVideo"].toString(),
        url: json["url"].toString(),
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
