import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String body;
  final DateTime? time;
  final String sentBy;
  final String sentTo;
  final String notId;
  final DateTime? date;
  final String type;

  NotificationModel({
    required this.title,
    required this.body,
    this.time,
    required this.sentBy,
    required this.sentTo,
    required this.notId,
    this.date,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Subtitle',
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] ?? 0),
      sentBy: json['sentBy'] ?? '',
      sentTo: json['sentTo'] ?? '',
      notId: json['notId'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'time': time??DateTime.now().millisecondsSinceEpoch,
      'sentBy': sentBy,
      'sentTo': sentTo,
      'notId': notId??'',
      'date': date??DateTime.now(),
      'type': type,
    };
  }
}
