class FollowRequestModel {
  String? requestId;
  String? fromUserId;
  String? fromUserName;
  String? fromUserProfileImage;
  DateTime? dateRequested;

  FollowRequestModel({
    this.requestId,
    this.fromUserId,
    this.fromUserName,
    this.fromUserProfileImage,
    this.dateRequested,
  });

  factory FollowRequestModel.fromJson(Map<String, dynamic> map) {
    return FollowRequestModel(
      requestId: map['requestId'],
      fromUserId: map['fromUserId'],
      fromUserName: map['fromUserName'],
      fromUserProfileImage: map['fromUserProfileImage'],
      dateRequested: map['dateRequested'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserProfileImage': fromUserProfileImage,
      'dateRequested': dateRequested,
    };
  }
}
