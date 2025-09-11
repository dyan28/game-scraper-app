// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class OnlineGameRes {
  final String? originalUrl;
  final String? title;
  final String? thumb;
  final String? descriptionShort;
  final String? descriptionLong;
  final String? releaseDate;
  final String? html5Url;
  final String? gameId;
  final String? embedUrl;
  final String? iframe;
  OnlineGameRes({
    this.originalUrl,
    this.title,
    this.thumb,
    this.descriptionShort,
    this.descriptionLong,
    this.releaseDate,
    this.html5Url,
    this.gameId,
    this.embedUrl,
    this.iframe,
  });


  OnlineGameRes copyWith({
    String? originalUrl,
    String? title,
    String? thumb,
    String? descriptionShort,
    String? descriptionLong,
    String? releaseDate,
    String? html5Url,
    String? gameId,
    String? embedUrl,
    String? iframe,
  }) {
    return OnlineGameRes(
      originalUrl: originalUrl ?? this.originalUrl,
      title: title ?? this.title,
      thumb: thumb ?? this.thumb,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      descriptionLong: descriptionLong ?? this.descriptionLong,
      releaseDate: releaseDate ?? this.releaseDate,
      html5Url: html5Url ?? this.html5Url,
      gameId: gameId ?? this.gameId,
      embedUrl: embedUrl ?? this.embedUrl,
      iframe: iframe ?? this.iframe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'originalUrl': originalUrl,
      'title': title,
      'thumb': thumb,
      'descriptionShort': descriptionShort,
      'descriptionLong': descriptionLong,
      'releaseDate': releaseDate,
      'html5Url': html5Url,
      'gameId': gameId,
      'embedUrl': embedUrl,
      'iframe': iframe,
    };
  }

  factory OnlineGameRes.fromMap(Map<String, dynamic> map) {
    return OnlineGameRes(
      originalUrl: map['originalUrl'] != null ? map['originalUrl'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      thumb: map['thumb'] != null ? map['thumb'] as String : null,
      descriptionShort: map['descriptionShort'] != null ? map['descriptionShort'] as String : null,
      descriptionLong: map['descriptionLong'] != null ? map['descriptionLong'] as String : null,
      releaseDate: map['releaseDate'] != null ? map['releaseDate'] as String : null,
      html5Url: map['html5Url'] != null ? map['html5Url'] as String : null,
      gameId: map['gameId'] != null ? map['gameId'] as String : null,
      embedUrl: map['embedUrl'] != null ? map['embedUrl'] as String : null,
      iframe: map['iframe'] != null ? map['iframe'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnlineGameRes.fromJson(String source) => OnlineGameRes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OnlineGameRes(originalUrl: $originalUrl, title: $title, thumb: $thumb, descriptionShort: $descriptionShort, descriptionLong: $descriptionLong, releaseDate: $releaseDate, html5Url: $html5Url, gameId: $gameId, embedUrl: $embedUrl, iframe: $iframe)';
  }

  @override
  bool operator ==(covariant OnlineGameRes other) {
    if (identical(this, other)) return true;
  
    return 
      other.originalUrl == originalUrl &&
      other.title == title &&
      other.thumb == thumb &&
      other.descriptionShort == descriptionShort &&
      other.descriptionLong == descriptionLong &&
      other.releaseDate == releaseDate &&
      other.html5Url == html5Url &&
      other.gameId == gameId &&
      other.embedUrl == embedUrl &&
      other.iframe == iframe;
  }

  @override
  int get hashCode {
    return originalUrl.hashCode ^
      title.hashCode ^
      thumb.hashCode ^
      descriptionShort.hashCode ^
      descriptionLong.hashCode ^
      releaseDate.hashCode ^
      html5Url.hashCode ^
      gameId.hashCode ^
      embedUrl.hashCode ^
      iframe.hashCode;
  }
}
