import 'package:get/get.dart';
import 'package:soical_media_app/controllers/authControllers/edit_profile_controller.dart';
import 'package:soical_media_app/controllers/authControllers/login_controller.dart';
import 'package:soical_media_app/controllers/authControllers/signup_controller.dart';
import 'package:soical_media_app/controllers/home_controllers/search_controller.dart';
import 'package:soical_media_app/controllers/messages_controllers/chat_controller.dart';
import 'package:soical_media_app/controllers/notification_controller/notification_controller.dart';
import 'package:soical_media_app/controllers/post_controllers/post_controller.dart';
import 'package:soical_media_app/controllers/profile_controller/profiel_controller.dart';
import 'package:soical_media_app/controllers/story_controller/story_controller.dart';

import '../../models/chat_models/chat_thread_model.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
    Get.put(LoginController());
  }
}

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
    Get.put(LoginController());
  }
}

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(PostController());
    Get.put(StoryUploadController());
    Get.put(ProfileController());
    Get.put(SearchScreenController());
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileController());
  }
}

class ChatBinding extends Bindings {
  final ChatThreadModel chatThreadModel;
  ChatBinding(this.chatThreadModel);
  @override
  void dependencies() {
    Get.put(ChatController(chatThreadModel: chatThreadModel));
  }
}

class NotificationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController());
  }
}
