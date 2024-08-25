import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThreadModel {
  String? lastMessage;
  DateTime? lastMessageTime;
  String? chatHeadId;
  String? receiverId;
  String? senderID;
  List<String>? participants;
  String? chatTitle;
  String? chatImage;
  int? receiverUnreadCount;
  int? senderUnreadCount;
  String? receiverName;
  String? senderName;
  String? receiverProfileImage;
  String? senderProfileImage;
  bool? seenMessagesBySender; // New field
  bool? seenMessagesByReceiver; // New field
  bool? hide; // New field
  bool? isGroupChat; // New field

  ChatThreadModel({
    this.lastMessage,
    this.lastMessageTime,
    this.chatHeadId,
    this.receiverId,
    this.senderID,
    this.participants,
    this.chatTitle,
    this.chatImage,
    this.receiverUnreadCount,
    this.senderUnreadCount,
    this.receiverName,
    this.senderName,
    this.receiverProfileImage,
    this.senderProfileImage,
    this.seenMessagesBySender = false, // Initialize seenMessagesBySender to false
    this.seenMessagesByReceiver = false, // Initialize seenMessagesByReceiver to false
    this.hide = false, // Initialize seenMessagesByReceiver to false
    this.isGroupChat = false, // Initialize seenMessagesByReceiver to false
  });

  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage ?? '',
      'lastMessageTime': lastMessageTime ?? DateTime.now(),
      'chatHeadId': chatHeadId ?? '',
      'receiverId': receiverId ?? '',
      'senderID': senderID ?? '',
      'participants': participants ?? [],
      'chatTitle': chatTitle ?? '',
      'chatImage': chatImage ?? '',
      'receiverUnreadCount': receiverUnreadCount ?? 0,
      'senderUnreadCount': senderUnreadCount ?? 0,
      'receiverName': receiverName ?? '',
      'senderName': senderName ?? '',
      'receiverProfileImage': receiverProfileImage ?? '',
      'senderProfileImage': senderProfileImage ?? '',
      'seenMessagesBySender': seenMessagesBySender ?? false, // Include seenMessagesBySender in the map
      'seenMessagesByReceiver': seenMessagesByReceiver ?? false, // Include seenMessagesByReceiver in the map
      'hide': hide ?? false, // Include seenMessagesByReceiver in the map
      'isGroupChat': isGroupChat ?? false, // Include seenMessagesByReceiver in the map
    };
  }

  factory ChatThreadModel.fromMap(DocumentSnapshot map) {
    return ChatThreadModel(
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
      chatHeadId: map['chatHeadId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      senderID: map['senderID'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      chatTitle: map['chatTitle'] ?? '',
      chatImage: map['chatImage'] ?? '',
      receiverUnreadCount: map['receiverUnreadCount'] ?? 0,
      senderUnreadCount: map['senderUnreadCount'] ?? 0,
      receiverName: map['receiverName'] ?? '',
      senderName: map['senderName'] ?? '',
      receiverProfileImage: map['receiverProfileImage'] ?? '',
      senderProfileImage: map['senderProfileImage'] ?? '',
      seenMessagesBySender: map['seenMessagesBySender'] ?? false, // Retrieve seenMessagesBySender from Firestore
      seenMessagesByReceiver: map['seenMessagesByReceiver'] ?? false, // Retrieve seenMessagesByReceiver from Firestore
      hide: map['hide'] ?? false, // Retrieve seenMessagesByReceiver from Firestore
      isGroupChat: map['isGroupChat'] ?? false, // Retrieve seenMessagesByReceiver from Firestore
    );
  }
}
