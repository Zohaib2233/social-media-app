import 'package:get/get.dart';
import 'package:soical_media_app/models/chat_models/chat_thread_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';

import '../../services/chatting_service.dart';

class InboxController extends GetxController{

  RxList<ChatThreadModel> chatThreadModels = <ChatThreadModel>[].obs;

  List<String> selectedUsers = <String>[];
  List<UserModel> selectedUserModels = <UserModel>[];
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("--------------- InboxController Init--------------------");
    ChattingService.instance.streamChatHeads().listen((event) {
      chatThreadModels.value = event;
    });
  }
}