import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/view/screens/chat/chat_page.dart';

import '../core/global/instance_variables.dart';
import '../models/chat_models/chat_thread_model.dart';
import '../models/chat_models/message_model.dart';
import '../models/user_model/user_model.dart';

class ChattingService {
  ChattingService._privateConstructor();

  static ChattingService? _instance;

  static ChattingService get instance {
    _instance ??= ChattingService._privateConstructor();
    return _instance!;
  }

  createGroupChatThread(
      {required String groupName, required List<String> participants}) async {
    try {
      DocumentReference reference = FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc();

      print("******* Chat Thread Created ******** ${reference.id}");

      ChatThreadModel chatThreadModel = ChatThreadModel(
        isGroupChat: true,
        chatImage: dummyProfile,
        chatTitle: groupName,
        chatHeadId: reference.id,
        // senderName: groupName,
        // receiverName: groupName,
        receiverProfileImage: dummyProfile,
        senderProfileImage: dummyProfile,
        lastMessageTime: DateTime.now(),
        participants: participants,
        receiverId: userModelGlobal.value.uid,
        senderID: userModelGlobal.value.uid,
        receiverUnreadCount: 0,
        senderUnreadCount: 0,
      );
      await reference.set(chatThreadModel.toMap());

      Get.to(
          () => ChatPage(
                chatThreadModel: chatThreadModel,
              ),
          binding: ChatBinding(chatThreadModel));
    } catch (e) {}
  }

  createChatThread({required UserModel userModel
      // required EventModel eventModel,
      }) async {
    try {
      print("participants = ${userModelGlobal.value.uid} , ${userModel.uid}");
      // Query for existing chat thread
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.chatRoomsCollection)
          .where(Filter.or(
              Filter('participants',
                  isEqualTo: [userModel.uid,userModelGlobal.value.uid]),
              Filter('participants',isEqualTo:  [userModelGlobal.value.uid, userModel.uid])))

          .get();

      // If chat thread exists, navigate to chat screen
      if (snapshot.docs.isNotEmpty) {
        print("Chatroom already Exists");
        ChatThreadModel chatThreadModel =
            ChatThreadModel.fromMap(snapshot.docs.first);
        Get.to(
            () => ChatPage(
                  chatThreadModel: chatThreadModel,
                ),
            binding: ChatBinding(chatThreadModel));
        // Get.to(() => ChatScreen(chatThreadModel: chatThreadModel),
        //     binding: ChatScreenBinding(), arguments: chatThreadModel);
      }
      // If chat thread doesn't exist, create a new one
      else {
        DocumentReference reference = FirebaseConstants.fireStore
            .collection(FirebaseConstants.chatRoomsCollection)
            .doc();

        print("******* Chat Thread Created ******** ${reference.id}");

        ChatThreadModel chatThreadModel = ChatThreadModel(
          chatHeadId: reference.id,
          senderName: userModelGlobal.value.name,
          receiverName: userModel.name,
          receiverProfileImage: userModel.profilePicture,
          senderProfileImage: userModelGlobal.value.profilePicture,
          lastMessageTime: DateTime.now(),
          participants: [userModelGlobal.value.uid, userModel.uid],
          receiverId: userModel.uid,
          senderID: userModelGlobal.value.uid,
          receiverUnreadCount: 0,
          senderUnreadCount: 0,
        );
        await reference.set(chatThreadModel.toMap());

        Get.to(
            () => ChatPage(
                  chatThreadModel: chatThreadModel,
                ),
            binding: ChatBinding(chatThreadModel));

        // Get.to(() => ChatScreen(chatThreadModel: chatThreadModel),
        //     binding: ChatScreenBinding(), arguments: [chatThreadModel]);
      }
    } catch (e) {
      print('Error creating or accessing chat thread: $e');
      throw Exception(e);
      // Handle the error as needed
    }
  }

  Future sendMessage(
      {required ChatThreadModel chatThreadModel,
      String? message,
      String? lastMessage,fileName,
      required String messageType}) async {
    try {
      DocumentReference reference = FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection(FirebaseConstants.messagesCollection)
          .doc();



      MessageModel messageModel = MessageModel(
        fileName: fileName??'',
          messageType: messageType,
          message: message ?? '',
          messageId: reference.id,
          sentAt: DateTime.now(),
          sentBy: userModelGlobal.value.uid);

      await reference.set(messageModel.toMap());
      print(
          "Message Send = ${chatThreadModel.senderID} ------------ ${userModelGlobal.value.uid}");
      if (chatThreadModel.senderID == userModelGlobal.value.uid) {
        DocumentReference reference = await FirebaseConstants.fireStore
            .collection(FirebaseConstants.chatRoomsCollection)
            .doc(chatThreadModel.chatHeadId);
        if (lastMessage != null) {
          reference.update({
            'lastMessage': lastMessage,
            'lastMessageTime': DateTime.now(),
            'receiverUnreadCount': FieldValue.increment(1)
          });
        } else {
          reference.update({
            'lastMessage': message,
            'lastMessageTime': DateTime.now(),
            'receiverUnreadCount': FieldValue.increment(1)
          });
        }
      } else {
        await FirebaseConstants.fireStore
            .collection(FirebaseConstants.chatRoomsCollection)
            .doc(chatThreadModel.chatHeadId)
            .update({
          'lastMessage': message,
          'lastMessageTime': DateTime.now(),
          'senderUnreadCount': FieldValue.increment(1)
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<ChatThreadModel>> streamChatHeads() {
    print("--------------------Stream Chat Heads Call-----------------------");
    // print(FirebaseConstants.auth.currentUser?.uid);
    try {
      return FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .where('participants', arrayContains: userModelGlobal.value.uid)
          // .where(Filter.or(
          //     Filter('senderID', isEqualTo: userModelGlobal.value.uid),
          //     Filter('receiverId', isEqualTo: userModelGlobal.value.uid)))
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((documents) {
        // print(documents.docs.asMap());
        return documents.docs
            .map((doc) => ChatThreadModel.fromMap(doc))
            .toList();
      });
    } catch (e) {
      print(e);
      print("Catch e Called");

      // return <ChatThreadModel>[];
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> fetchMessages(
      {required ChatThreadModel chatThreadModel}) {
    try {
      print("Called fetchMessages");
      return FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection('messages')
          .orderBy('sentAt', descending: false)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => MessageModel.fromJson1(e.data())).toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<MessageModel>> fetchGroupMessages(
      {required ChatThreadModel chatThreadModel}) {
    try {
      print("Called fetchMessages");
      return FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .collection('messages').where('isGroupChat',isEqualTo: true)
          .orderBy('sentAt', descending: false)
          .snapshots()
          .map((event) =>
          event.docs.map((e) => MessageModel.fromJson1(e.data())).toList());
    } catch (e) {
      throw Exception(e);
    }
  }
}
