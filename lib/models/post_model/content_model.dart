class ContentModel {
  String url;
  String postType;
  String thumbnail;

  Map<String, dynamic> toMap() {
    return {
      'url': this.url,
      'postType': this.postType,
      'thumbnail': this.thumbnail,
    };
  }

  factory ContentModel.fromMap(Map<String, dynamic> map) {
    return ContentModel(
      url: map['url'] as String,
      postType: map['postType'] as String,
      thumbnail: map['thumbnail'] as String,
    );
  }

  ContentModel({
    required this.url,
    required this.postType,
    required this.thumbnail,
  });
}
