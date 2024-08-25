import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';

class SwitchStoryGroup {
  final List<SwitchStory> stories;
  final UserModel owner;
  final String? ownerId;

  SwitchStoryGroup(this.stories, this.owner, this.ownerId);
}

class SwitchStory {
  final String id;
  final String image;
  final String type;
  final bool canReact;
  final Timestamp createdAt;
  final Timestamp showTill;
  final List<String> viewers;
  final int views;

  SwitchStory(
    this.id,
    this.image,
    this.type,
    this.canReact,
    this.createdAt,
    this.showTill,
    this.viewers,
    this.views,
  );

  factory SwitchStory.fromJson(Map<String, dynamic> data) {
    return SwitchStory(
      data["id"],
      data["imageURL"],
      data["type"],
      data["canReact"],
      data["postDate"],
      data["showTill"],
      data["viewBy"].cast<String>(),
      data["views"],
    );
  }
}
