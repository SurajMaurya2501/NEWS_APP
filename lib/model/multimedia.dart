class MultiMedia {
  final String url;
  final String format;
  final int height;
  final int width;
  final String type;
  final String subtype;
  final String caption;
  final String copyright;

  MultiMedia(
      {required this.url,
      required this.format,
      required this.height,
      required this.width,
      required this.type,
      required this.subtype,
      required this.caption,
      required this.copyright});

  factory MultiMedia.fromJson(Map<String, dynamic> json) {
    return MultiMedia(
        url: json['url'],
        format: json['format'],
        height: json['height'],
        width: json['width'],
        type: json['type'],
        subtype: json['subtype'],
        caption: json['caption'],
        copyright: json['copyright']);
  }
}
