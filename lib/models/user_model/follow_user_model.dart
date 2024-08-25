import 'package:soical_media_app/models/user_model/user_model.dart';

class FollowedUserModel {
  final UserModel user;
  final bool isFollowed;

  FollowedUserModel({
    required this.user,
    required this.isFollowed,
  });

  factory FollowedUserModel.fromJson(Map<String, dynamic> json) {
    return FollowedUserModel(
      user: UserModel.fromJson(json['user']),
      isFollowed: json['isFollowed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'isFollowed': isFollowed,
    };
  }
}
