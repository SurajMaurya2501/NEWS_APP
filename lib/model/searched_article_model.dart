import 'package:news_app/model/search_multimedia_model.dart';

class SearchArticleModel {
  final String abstract;
  final String web_url;
  final String snippet;
  final String lead_paragraph;
  final String source;
  final List<SearchMultiMedia> multimedia;
  final String headline;

  SearchArticleModel(
      {required this.abstract,
      required this.web_url,
      required this.snippet,
      required this.lead_paragraph,
      required this.source,
      required this.multimedia,
      required this.headline});

  factory SearchArticleModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> multimedia = json["multimedia"];

    return SearchArticleModel(
        abstract: json['abstract'],
        web_url: json['web_url'],
        snippet: json['snippet'],
        lead_paragraph: json['lead_paragraph'],
        source: json['source'],
        multimedia: multimedia
            .map((media) => SearchMultiMedia.fromJson(media))
            .toList(),
        headline: json['headline']);
  }
  
}
