import 'package:news_app/model/multimedia.dart';

class CategoryArticles {
  final String section;
  final String subsection;
  final String title;
  final String abstract;
  final String url;
  final String uri;
  final String byline;
  final String item_type;
  final String updated_date;
  final String created_date;
  final String published_date;
  final String kicker;
  final List<MultiMedia> multimedia;
  final short_url;

  CategoryArticles(
      {required this.section,
      required this.subsection,
      required this.title,
      required this.abstract,
      required this.url,
      required this.uri,
      required this.byline,
      required this.item_type,
      required this.updated_date,
      required this.created_date,
      required this.published_date,
      required this.kicker,
      required this.multimedia,
      required this.short_url});

  factory CategoryArticles.fromJson(Map<String, dynamic> json) {
    List<dynamic> multimedia = json["multimedia"] ?? [];
    return CategoryArticles(
        section: json["section"],
        subsection: json["subsection"],
        title: json["title"],
        abstract: json["abstract"],
        url: json["url"],
        uri: json["uri"],
        byline: json["byline"],
        item_type: json["item_type"],
        updated_date: json["updated_date"],
        created_date: json["created_date"],
        published_date: json["published_date"],
        kicker: json["kicker"],
        multimedia: multimedia
            .map((media) => MultiMedia(
                url: media['url'],
                format: media['format'],
                height: media['height'],
                width: media['width'],
                type: media['type'],
                subtype: media['subtype'],
                caption: media['caption'],
                copyright: media['copyright']))
            .toList(),
        short_url: json["short_url"]);
  }
}
