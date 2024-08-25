class CommentModel {
  String comment;
  String commentId;
  DateTime date;
  List likes;
  String sender;

  CommentModel({
    required this.comment,
    required this.commentId,
    required this.date,
    required this.likes,
    required this.sender,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': this.comment,
      'commentId': this.commentId,
      'date': this.date,
      'likes': this.likes,
      'sender': this.sender,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      comment: map['comment'] as String,
      commentId: map['commentId']??'',
      date: map['date'].toDate(),
      likes: map['likes'] as List,
      sender: map['sender'] as String,
    );
  }
}
