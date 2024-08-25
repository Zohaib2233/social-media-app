import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? message;
  DateTime? sentAt;
  String? sentBy;
  String? messageId;
  bool? seenBySender;
  bool? seenByReceiver;
  String? messageType; // New field
  String? fileName; // New field

  MessageModel({
    this.sentBy,
    this.sentAt,
    this.message,
    this.messageId,
    this.seenBySender,
    this.seenByReceiver,
    this.messageType, // Initialize with null by default
    this.fileName, // Initialize with null by default
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message ?? '',
      'sentAt': sentAt ?? DateTime.now(),
      'sentBy': sentBy ?? '',
      'messageId': messageId ?? '',
      'seenBySender': seenBySender ?? false,
      'seenByReceiver': seenByReceiver ?? false,
      'messageType': messageType ?? '', // Include messageType field
      'fileName': fileName ?? '', // Include messageType field
    };
  }

  factory MessageModel.fromJson1(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      sentBy: map['sentBy'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      seenBySender: map['seenBySender'] ?? false,
      seenByReceiver: map['seenByReceiver'] ?? false,
      messageType: map['messageType'] ?? '', // Parse messageType field
      fileName: map['fileName'] ?? '', // Parse messageType field
    );
  }

  factory MessageModel.fromJson2(DocumentSnapshot map) {
    return MessageModel(
      message: map['message'],
      sentBy: map['sentBy'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      seenBySender: map['seenBySender'] ?? false,
      seenByReceiver: map['seenByReceiver'] ?? false,
      messageType: map['messageType'] ?? '', // Parse messageType field
      fileName: map['fileName'] ?? '', // Parse messageType field
    );
  }
}
