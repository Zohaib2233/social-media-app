import 'package:soical_media_app/models/post_model/content_model.dart';

class PostModel {
  final String postID;
  final String uid;
  final String caption;
  final ContentModel content;
  final List<dynamic> tags;
  final List<dynamic> likesList;
  final int likes;
  final int comments;
  final DateTime postDate;
  final bool active;
  final String location;

  const PostModel({
    required this.postID,
    required this.likesList,
    required this.uid,
    required this.caption,
    required this.content,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.postDate,
    required this.active,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'postID': this.postID,
      'uid': this.uid,
      'caption': this.caption,
      'likesList': this.likesList,
      'content': this.content.toMap(),
      'tags': this.tags,
      'likes': this.likes,
      'comments': this.comments,
      'postDate': this.postDate,
      'active': this.active,
      'location': this.location,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postID: map['postID'] as String,
      uid: map['uid'] as String,
      caption: map['caption'] as String,
      content: ContentModel.fromMap(map['content']) as ContentModel,
      tags: map['tags'] as List<dynamic>,
      likesList: map['likesList'] as List<dynamic>,
      likes: map['likes'] as int,
      comments: map['comments'] as int,
      postDate: map['postDate'].toDate(),
      active: map['active'] as bool,
      location: map['location'] as String,
    );
  }
}
