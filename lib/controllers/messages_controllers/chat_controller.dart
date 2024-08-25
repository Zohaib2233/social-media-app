import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/models/chat_models/chat_thread_model.dart';
import 'package:soical_media_app/models/chat_models/message_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/chatting_service.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_storage_service.dart';
import 'package:soical_media_app/services/local_notification_service.dart';

import '../../core/global/instance_variables.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  final record = AudioRecorder();

  RxString message = ''.obs;
  RxList<MessageModel> messageModels = <MessageModel>[].obs;
  final ChatThreadModel chatThreadModel;

  RxBool sending = false.obs;
  RxBool downloading = false.obs;
  RxString downloadingValue = ''.obs;

  String imagePath = '';
  String filePath = '';
  String fileUrl = '';
  String imageUrl = '';

  RxBool newMessage = false.obs;
  RxBool voiceNote = false.obs;
  RxBool isBlockedByMe = false.obs;
  RxString blockedByUid = ''.obs;

  ChatController({required this.chatThreadModel});

  @override
  onInit() {
    super.onInit();
    ChattingService.instance
        .fetchMessages(chatThreadModel: chatThreadModel)
        .listen((event) {
      messageModels.value = event;
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  dispose() {
    super.dispose();
    record.dispose();
    messageController.dispose();
  }

  startVoiceRecording() async {
    if (await record.hasPermission()) {
      var tempDir = await getTemporaryDirectory();
      voiceNote(true);
      await record.start(const RecordConfig(),
          path: '${tempDir.path}/myFile.m4a');
    }
  }

  stopVoiceRecording() async {
    voiceNote(false);
    final String? path = await record.stop();
    if (path!.isNotEmpty) {
      sending(true);
      String downloadUrl = await FirebaseStorageService.instance
          .uploadFileToStorage(filePath: path, storageRef: 'voiceNote');
      if (downloadUrl.isNotEmpty) {
        ChattingService.instance.sendMessage(
            chatThreadModel: chatThreadModel,
            messageType: AppStrings.audioMessage,
            lastMessage: 'voice message',
            message: downloadUrl);
      }
    }
    sending(false);
  }

  initializedMethod(ChatThreadModel chatThreadModel) async {
    if (chatThreadModel.senderID == userModelGlobal.value.uid) {
      // seenMessage(chatThreadModel: chatThreadModel, isSender: false);
      DocumentReference documentReference = await FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId);
      DocumentSnapshot snapshot = await documentReference.get();
      if (snapshot['senderUnreadCount'] > 0) {
        newMessage.value = true;
      }

      documentReference.update({'senderUnreadCount': 0});

      // DocumentSnapshot<Map<String, dynamic>> document = await FirebaseConstants
      //     .fireStore
      //     .collection(FirebaseConstants.userCollection)
      //     .doc(chatThreadModel.receiverId)
      //     .get();
      //
      // userStatus.value = document['status'];
    } else {
      // seenMessage(chatThreadModel: chatThreadModel, isSender: true);
      FirebaseConstants.fireStore
          .collection(FirebaseConstants.chatRoomsCollection)
          .doc(chatThreadModel.chatHeadId)
          .update({'receiverUnreadCount': 0});
    }
  }

  sendImageMessage({bool galleryImage = true}) async {
    sending(false);
    if (galleryImage) {
      imagePath = await FirebaseStorageService.instance.pickImageFromGallery();
    } else {
      Get.back();
      imagePath = await FirebaseStorageService.instance.pickImageFromCamera();
    }

    if (imagePath != '') {
      sending(true);
      log(imagePath);
      imageUrl = await FirebaseStorageService.instance.uploadSingleImage(
          imgFilePath: imagePath, storageRef: 'imageMessages');
      if (imageUrl != '') {
        await ChattingService.instance.sendMessage(
            lastMessage: 'image',
            message: imageUrl,
            chatThreadModel: chatThreadModel,
            messageType: AppStrings.imageMessage);
      }
      sending(false);
    }
  }

  Future<File?> downloadFile(
      {required String url, required String name}) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(minutes: 0),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future openFile({required String url, required String fileName}) async {
    final file = await downloadFile(url: url, name: fileName);

    if (file == null) return;

    OpenFile.open(file.path);
  }

  sendFileMessage() async {
    sending(false);
    FilePickerResult? result =
        await FirebaseStorageService.instance.pickCustomFile();
    if (result != null) {
      String fileName = result.paths.first?.split('/').last ?? '';
      print("result.paths.first = ${result.paths.first?.split('/').last}");
      sending(true);
      String downloadUrl = await FirebaseStorageService.instance
          .uploadFileToStorage(
              filePath: result.paths.first!, storageRef: 'files');
      // print("downloadUrl = ${downloadUrl}");

      if (downloadUrl != '') {
        await ChattingService.instance.sendMessage(
            lastMessage: 'file',
            fileName: "$fileName",
            message: downloadUrl,
            chatThreadModel: chatThreadModel,
            messageType: AppStrings.fileMessage);
      }
      sending(false);
    }
  }

  sendMusicMessage() async {
    Get.back();
    FilePickerResult? result = await FirebaseStorageService.instance
        .pickFile(fileType: FileType.audio);
    if (result != null) {
      sending(true);
      var file =
          await FirebaseStorageService.instance.uploadFile(result: result);
      print(
          "------------------------ audio Uploadeded ---------------- $filePath");

      sending(file.$2);
      if (file.$1 != '') {
        await ChattingService.instance.sendMessage(
            lastMessage: 'audio',
            message: fileUrl,
            chatThreadModel: chatThreadModel,
            messageType: AppStrings.audioMessage);
      }
    }

    sending(false);
  }

  sendMessage(
      {required ChatThreadModel chatThreadModel,
      required UserModel userModel}) async {
    print("Sending Message = ${chatThreadModel.isGroupChat}");

    String textMessage = messageController.value.text;
    messageController.clear();
    message.value = '';
    await ChattingService.instance.sendMessage(
        message: textMessage,
        chatThreadModel: chatThreadModel,
        messageType: AppStrings.textMessage);
    if (chatThreadModel.isGroupChat == false) {
      LocalNotificationService.instance.sendFCMNotification(
          deviceToken: userModel.deviceTokenID,
          title: userModelGlobal.value.name,
          body: "Send You a Message",
          type: AppStrings.notificationMessage,
          sentBy: userModelGlobal.value.uid,
          sentTo: userModel.uid,
          savedToFirestore: false);
    } else {
      // LocalNotificationService.instance.sendFCMNotification(
      //     deviceToken: userModel.deviceTokenID,
      //     title: chatThreadModel.chatTitle??'Group',
      //     body: "${userModel.name} send a Message",
      //     type: AppStrings.notificationMessage,
      //     sentBy: userModelGlobal.value.uid,
      //     sentTo: userModel.uid,
      //     savedToFirestore: false);
    }
  }

  Future<void> blockUser(String thisUserId, String otherUserId) async {
    await usersCollection
        .doc(thisUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .set(
      {'blockedBy': thisUserId},
    );
    await usersCollection
        .doc(otherUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .set(
      {'blockedBy': thisUserId},
    );
    FirebaseCRUDServices.instance.blockUser(otherUserId: otherUserId);
  }

  Future<void> unBlockUser(String thisUserId, String otherUserId) async {
    await usersCollection
        .doc(thisUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .delete();
    await usersCollection
        .doc(otherUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .delete();
    FirebaseCRUDServices.instance.unBlockUser(otherUserId: otherUserId);
  }

  Future<void> checkIfBlockedBy(String thisUserId, String otherUserId) async {
    final snapshot1 = await usersCollection
        .doc(thisUserId)
        .collection('blockedUsers')
        .doc(otherUserId)
        .get();
    if (snapshot1.exists) {
      isBlockedByMe.value = true;
    }
    final snapshot2 = await usersCollection
        .doc(otherUserId)
        .collection('blockedUsers')
        .doc(thisUserId)
        .get();
    if (snapshot2.exists) {
      isBlockedByMe.value = false;
    }
    log(isBlockedByMe.value.toString());
  }
}
