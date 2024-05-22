class SearchMultiMedia {
  final String url;
  final String subtype;

  SearchMultiMedia({required this.subtype, required this.url});

  factory SearchMultiMedia.fromJson(Map<String, dynamic> json) {
    return SearchMultiMedia(subtype: json['subtype'], url: json['url']);
  }
}
