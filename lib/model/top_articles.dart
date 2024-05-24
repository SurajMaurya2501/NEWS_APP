import 'package:news_app/model/media.dart';

class TopArticlesModel {
  final String url;
  final String byline;
  final String title;
  final String abstract;
  final List<Media> media;

  TopArticlesModel(
      {required this.url,
      required this.byline,
      required this.title,
      required this.abstract,
      required this.media});

  factory TopArticlesModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> media = json["media"].isNotEmpty
        ? json["media"][0]['media-metadata'] ?? []
        : [];
    return TopArticlesModel(
      url: json['url'],
      byline: json['byline'],
      title: json['title'],
      abstract: json['abstract'],
      media: media
          .map(
            (data) => Media(
              url: data['url'],
            ),
          )
          .toList(),
    );
  }
}
