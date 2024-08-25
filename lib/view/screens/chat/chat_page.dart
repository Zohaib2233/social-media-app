import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/controllers/messages_controllers/chat_controller.dart';
import 'package:soical_media_app/core/enums/message_type.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/core/utils/utils.dart';
import 'package:soical_media_app/models/chat_models/chat_thread_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/download_file_service.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/local_notification_service.dart';
import 'package:soical_media_app/view/screens/chat/zego_widgets.dart';
import 'package:soical_media_app/view/screens/zegoCall/zego_call_page.dart';
import 'package:soical_media_app/view/widget/Horizantall_divider.dart';
import 'package:soical_media_app/view/widget/chat_page_appbar.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/icon_button.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../models/user_model/user_model.dart';

class ChatPage extends StatefulWidget {
  final ChatThreadModel chatThreadModel;

  const ChatPage({super.key, required this.chatThreadModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  var controller = Get.find<ChatController>();

  bool openFiles = false;
  bool tapOnGif = false;
  bool haveVoiceNote = false;
  bool sendIconVisibility = false;

  Rx<UserModel> userModel = UserModel(
    isDarkTheme: false,
    name: '',
    username: '',
    email: '',
    dob: '',
    uid: '',
    profilePicture: '',
    deviceTokenID: '',
    bio: '',
    followerCount: 0,
    followingCount: 0,
    joinAt: DateTime.now(),
    activeNow: false,
    coverPhoto: '',
    blockAccounts: [],
    notificationOn: false,
    mentionTags: '',
    // isPublic: false,
    // isOfficialVerified: false,
    location: '',
    lastSeen: DateTime.now(),
    loginWith: '',
    phoneNo: '',
    isOfficialVerified: false,
    bookmarked: [],
    userActiveAddress: {},
    isPrivate: false,
  ).obs;

  initState() {
    super.initState();

    ///

    // Scroll to the bottom after the ListView is built
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });

    if (widget.chatThreadModel.senderID == userModelGlobal.value.uid) {
      usersCollection
          .doc(widget.chatThreadModel.receiverId)
          .snapshots()
          .listen((event) {
        userModel.value = UserModel.fromJson(event);
      });
    } else {
      usersCollection
          .doc(widget.chatThreadModel.senderID)
          .snapshots()
          .listen((event) {
        userModel.value = UserModel.fromJson(event);
      });
    }
    Future.delayed(Duration.zero).then(
      (_) async {
        await controller.checkIfBlockedBy(
            userModelGlobal.value.uid,
            widget.chatThreadModel.participants
                    ?.where((element) => element != userModelGlobal.value.uid)
                    .first ??
                '2323');
      },
    );
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print('Hello -- ------------ ${userModelGlobal.value.uid}');
    String otherUserId = widget.chatThreadModel.participants
            ?.where((element) => element != userModelGlobal.value.uid)
            .first ??
        '2323';
    bool isGroupChat = widget.chatThreadModel.isGroupChat ?? false;
    // var controller = Get.put(ChatController(chatThreadModel: widget.chatThreadModel));
    return Scaffold(
      key: _scaffoldKey,
      appBar: chat_Page_appbar(
          personName: widget.chatThreadModel.isGroupChat ?? false
              ? widget.chatThreadModel.chatTitle ?? ''
              : widget.chatThreadModel.senderID == userModelGlobal.value.uid
                  ? widget.chatThreadModel.receiverName ?? ''
                  : widget.chatThreadModel.senderName ?? '',
          menuOnTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
          zegoButton: sendCallButton(
              buttonIcon: Assets.imagesPhoneIcon,
              onCallFinished: onSendCallInvitationFinished,
              isVideoCall: false,
              otherUsername: widget.chatThreadModel.senderID ==
                          widget.chatThreadModel.isGroupChat ??
                      false
                  ? widget.chatThreadModel.chatTitle ?? ''
                  : widget.chatThreadModel.senderID == userModelGlobal.value.uid
                      ? widget.chatThreadModel.receiverName ?? ''
                      : widget.chatThreadModel.senderName ?? '',
              id: otherUserId),
          zegoVideoButton: sendCallButton(
              buttonIcon: Assets.imagesVideoCallIcon,
              onCallFinished: onSendCallInvitationFinished,
              isVideoCall: true,
              otherUsername: "user_$otherUserId",
              id: otherUserId),
          voiceCallOnTap: () {},
          videoCallOnTap: () {
            // Get.to(() => CallPage(
            //     callID: widget.chatThreadModel.senderID!,
            //     targetUserID: widget.chatThreadModel.senderID!,
            //     targetUsername: widget.chatThreadModel.receiverName!,
            //     imageUrl: widget.chatThreadModel.senderProfileImage!));
          }),

      // End Drawer
      //-------------------------

      endDrawer: Obx(
        () => !userModelGlobal.value.blockAccounts.contains(userModel.value.uid)
            ? EndDrawerWidget(
                isGroupChat: widget.chatThreadModel.isGroupChat ?? false,
                // Report
                //----------------------------------------
                onReportTap: () {
                  getDefaultDialogFunction(
                    title: 'Report Jeneva?',
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyText(
                          textAlign: TextAlign.center,
                          text:
                              "The last 5 messages  from this contact will be forwarded to the company. If you block and delete the chat, messages will be removed from this device only.",
                          size: 13,
                          weight: FontWeight.w400,
                          color: kGreyColor1,
                        ),
                        _defaultDailogCheckItems(
                          mTop: 20,
                          ischecked: true,
                          onChange: (v) {},
                          title: "Block and delete chat",
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                    onOkTap: () {},
                  );
                },

                // Block
                //---------------------------
                onBlockTap: () {
                  getDefaultDialogFunction(
                    title: '${userModel.value.name}?',
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyText(
                          text:
                              "Blocked contacts cannot call or send you messages/ The contact will not be notified.",
                          size: 13,
                          weight: FontWeight.w400,
                          color: kGreyColor1,
                        ),
                        _defaultDailogCheckItems(
                          mTop: 20,
                          ischecked: true,
                          onChange: (v) {},
                          title: "Report",
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                    onOkTap: () async {
                      Get.close(2);
                      // FirebaseCRUDServices.instance
                      //     .blockUser(otherUserId: userModel.value.uid);
                      await controller.blockUser(
                          userModelGlobal.value.uid, otherUserId);
                    },
                  );
                },

                // Clear Chat
                //-------------------------
                onClearChatTap: () {
                  getDefaultDialogFunction(
                    title: 'Clear Chat',
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _defaultDailogCheckItems(
                          mTop: 0,
                          ischecked: false,
                          onChange: (v) {},
                          title: "Also delete media received from this contact",
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                    onOkTap: () {},
                  );
                },

                // Mute Chat
                //--------------------------------------------
                onMuteChatTap: () {
                  getDefaultDialogFunction(
                    title: 'Mute Notifications',
                    widget: Column(
                      children: [
                        MyText(
                          textAlign: TextAlign.center,
                          text:
                              "Other members will not see that you muted this chat. You will still be notified if you are mentioned.",
                          size: 12,
                          weight: FontWeight.w400,
                          color: kGreyColor1,
                        ),
                        _defaultDailogCheckItems(
                          ischecked: true,
                          onChange: (v) {},
                          title: "8 hours",
                        ),
                        _defaultDailogCheckItems(
                          ischecked: false,
                          onChange: (v) {},
                          title: "1 week",
                        ),
                        _defaultDailogCheckItems(
                          ischecked: false,
                          onChange: (v) {},
                          title: "Always",
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                    onOkTap: () {},
                  );
                },
              )
            : controller.isBlockedByMe.value
                ? EndDrawerWidget(
                    isGroupChat: widget.chatThreadModel.isGroupChat ?? false,
                    // Report
                    //----------------------------------------
                    onReportTap: () {
                      getDefaultDialogFunction(
                        title: '${userModel.value.name}?',
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyText(
                              textAlign: TextAlign.center,
                              text:
                                  "The last 5 messages  from this contact will be forwarded to the company. If you block and delete the chat, messages will be removed from this device only.",
                              size: 13,
                              weight: FontWeight.w400,
                              color: kGreyColor1,
                            ),
                            _defaultDailogCheckItems(
                              mTop: 20,
                              ischecked: true,
                              onChange: (v) {},
                              title: "Block and delete chat",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },

                    // Block
                    //---------------------------
                    blockTitle: 'UnBlock',
                    onBlockTap: () async {
                      Get.back();
                      // FirebaseCRUDServices.instance
                      //     .unBlockUser(otherUserId: userModel.value.uid);
                      await controller.unBlockUser(
                          userModelGlobal.value.uid, otherUserId);
                      CustomSnackBars.instance.showSuccessSnackbar(
                          title: "UnBlock", message: "The User is unblocked");
                    },

                    // Clear Chat
                    //-------------------------
                    onClearChatTap: () {
                      getDefaultDialogFunction(
                        title: 'Clear Chat',
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _defaultDailogCheckItems(
                              mTop: 0,
                              ischecked: false,
                              onChange: (v) {},
                              title:
                                  "Also delete media received from this contact",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },

                    // Mute Chat
                    //--------------------------------------------
                    onMuteChatTap: () {
                      getDefaultDialogFunction(
                        title: 'Mute Notifications',
                        widget: Column(
                          children: [
                            MyText(
                              textAlign: TextAlign.center,
                              text:
                                  "Other members will not see that you muted this chat. You will still be notified if you are mentioned.",
                              size: 12,
                              weight: FontWeight.w400,
                              color: kGreyColor1,
                            ),
                            _defaultDailogCheckItems(
                              ischecked: true,
                              onChange: (v) {},
                              title: "8 hours",
                            ),
                            _defaultDailogCheckItems(
                              ischecked: false,
                              onChange: (v) {},
                              title: "1 week",
                            ),
                            _defaultDailogCheckItems(
                              ischecked: false,
                              onChange: (v) {},
                              title: "Always",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },
                  )
                : EndDrawerWidget(
                    isGroupChat: widget.chatThreadModel.isGroupChat ?? false,
                    // Report
                    //----------------------------------------
                    onReportTap: () {
                      getDefaultDialogFunction(
                        title: '${userModel.value.name}?',
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyText(
                              textAlign: TextAlign.center,
                              text:
                                  "The last 5 messages  from this contact will be forwarded to the company. If you block and delete the chat, messages will be removed from this device only.",
                              size: 13,
                              weight: FontWeight.w400,
                              color: kGreyColor1,
                            ),
                            _defaultDailogCheckItems(
                              mTop: 20,
                              ischecked: true,
                              onChange: (v) {},
                              title: "Block and delete chat",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },

                    // Block
                    //---------------------------
                    blockTitle: '',
                    onBlockTap: () async {},

                    // Clear Chat
                    //-------------------------
                    onClearChatTap: () {
                      getDefaultDialogFunction(
                        title: 'Clear Chat',
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _defaultDailogCheckItems(
                              mTop: 0,
                              ischecked: false,
                              onChange: (v) {},
                              title:
                                  "Also delete media received from this contact",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },

                    // Mute Chat
                    //--------------------------------------------
                    onMuteChatTap: () {
                      getDefaultDialogFunction(
                        title: 'Mute Notifications',
                        widget: Column(
                          children: [
                            MyText(
                              textAlign: TextAlign.center,
                              text:
                                  "Other members will not see that you muted this chat. You will still be notified if you are mentioned.",
                              size: 12,
                              weight: FontWeight.w400,
                              color: kGreyColor1,
                            ),
                            _defaultDailogCheckItems(
                              ischecked: true,
                              onChange: (v) {},
                              title: "8 hours",
                            ),
                            _defaultDailogCheckItems(
                              ischecked: false,
                              onChange: (v) {},
                              title: "1 week",
                            ),
                            _defaultDailogCheckItems(
                              ischecked: false,
                              onChange: (v) {},
                              title: "Always",
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        onOkTap: () {},
                      );
                    },
                  ),
      ),
      body: Column(
        children: [
          Obx(() =>
              controller.newMessage.isTrue ? _NewMessageBage() : Container()),
          Obx(
            () => controller.messageModels.isNotEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: controller.messageModels.length,
                        itemBuilder: (context, index) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_scrollController.hasClients) {
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            } else {
                              setState(() => null);
                            }
                          });
                          if (controller.messageModels[index].messageType ==
                              AppStrings.textMessage) {
                            return _ChatBubble(
                              messageType: MessageType.text,
                              isMe: controller.messageModels[index].sentBy ==
                                  userModelGlobal.value.uid,
                              profileImg: isGroupChat
                                  ? widget.chatThreadModel.chatImage
                                  : widget.chatThreadModel
                                          .receiverProfileImage ??
                                      dummyProfile,
                              statusOnline: true,
                              message:
                                  "${controller.messageModels[index].message}",
                              textTime:
                                  "${Utils.formatDateTimetoTime(controller.messageModels[index].sentAt!)}",
                            );
                          } else if (controller
                                  .messageModels[index].messageType ==
                              AppStrings.imageMessage) {
                            return _ChatBubble(
                              messageType: MessageType.image,
                              isMe: controller.messageModels[index].sentBy ==
                                  userModelGlobal.value.uid,
                              profileImg: isGroupChat
                                  ? widget.chatThreadModel.chatImage
                                  : widget.chatThreadModel
                                          .receiverProfileImage ??
                                      dummyProfile,
                              message:
                                  "${controller.messageModels[index].message}",
                              statusOnline: true,
                              textTime:
                                  "${Utils.formatDateTimetoTime(controller.messageModels[index].sentAt!)}",
                            );
                          } else if (controller
                                  .messageModels[index].messageType ==
                              AppStrings.audioMessage) {
                            return _ChatBubble(
                              messageType: MessageType.audio,
                              isMe: controller.messageModels[index].sentBy ==
                                  userModelGlobal.value.uid,
                              profileImg: isGroupChat
                                  ? widget.chatThreadModel.chatImage
                                  : widget.chatThreadModel
                                          .receiverProfileImage ??
                                      dummyProfile,
                              message:
                                  "${controller.messageModels[index].message}",
                              statusOnline: true,
                              textTime:
                                  "${Utils.formatDateTimetoTime(controller.messageModels[index].sentAt!)}",
                            );
                          } else {
                            return _ChatBubble(
                              fileName:
                                  controller.messageModels[index].fileName,
                              messageType: MessageType.file,
                              isMe: controller.messageModels[index].sentBy ==
                                  userModelGlobal.value.uid,
                              profileImg: isGroupChat
                                  ? widget.chatThreadModel.chatImage
                                  : widget.chatThreadModel
                                          .receiverProfileImage ??
                                      dummyProfile,
                              message:
                                  "${controller.messageModels[index].message}",
                              statusOnline: true,
                              textTime:
                                  "${Utils.formatDateTimetoTime(controller.messageModels[index].sentAt!)}",
                            );
                          }
                        },
                      ),
                    ),
                  )
                : Container(
                    child: Center(child: Text("No Messages Yet!")),
                  ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: widget.chatThreadModel.isGroupChat == false
          ? Obx(
              () => userModelGlobal.value.blockAccounts
                      .contains(userModel.value.uid)
                  ? Container(
                      height: 100,
                      decoration: AppStyling().topShadowDecoration(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Center(
                        child: Text(
                          "User blocked",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  : Container(
                      decoration: AppStyling().topShadowDecoration(),

                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      //height: 50,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(
                            () => controller.sending.isTrue
                                ? Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        child: Text("Sending..."),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                          Obx(
                            () => controller.downloading.isTrue
                                ? Row(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        child: Text("Downloading..."),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ),
                          Row(children: [
                            // Svg Icon add files or something else
                            //--------------------------------------
                            Obx(() => (controller.message.isEmpty)
                                ? Row(
                                    children: [
                                      SvgIconsButton(
                                        onTap: () {
                                          if (openFiles == false) {
                                            openFiles = true;
                                          }
                                          setState(() {});

                                          // Bottom Sheet For Files
                                          //--------------------------
                                          Get.bottomSheet(
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 20),
                                              color: kGreyColor2,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Camera
                                                      _FilesButtons(
                                                        onTap: () {
                                                          controller
                                                              .sendImageMessage(
                                                                  galleryImage:
                                                                      false);
                                                        },
                                                        svgIcon: Assets
                                                            .imagesCameraGreyIcon,
                                                        title: "Camera",
                                                      ),
                                                      // Documnet
                                                      _FilesButtons(
                                                        onTap: () {
                                                          controller
                                                              .sendFileMessage();
                                                        },
                                                        svgIcon: Assets
                                                            .imagesFileGreyIcon,
                                                        title: "File",
                                                      ),
                                                      //Gallery
                                                      _FilesButtons(
                                                        onTap: () {
                                                          controller
                                                              .sendImageMessage();
                                                        },
                                                        svgIcon: Assets
                                                            .imagesGalleryGreyIcon,
                                                        title: "Gallery",
                                                      ),
                                                      //Music
                                                      _FilesButtons(
                                                        onTap: () {
                                                          // Get.back();
                                                          controller
                                                              .sendMusicMessage();
                                                        },
                                                        svgIcon: Assets
                                                            .imagesMusicGreyIcon,
                                                        title: "Music",
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).then((value) {
                                            if (openFiles == true) {
                                              openFiles = false;
                                            }
                                            setState(() {});
                                          });
                                        },
                                        horizontalPadding: 0,
                                        right: 10,
                                        svgIcon: (openFiles == true)
                                            ? Assets.imagesCrossBlueIcon
                                            : Assets.imagesAddGreyIcon,
                                      ),
                                      SvgIconsButton(
                                        onTap: () {
                                          controller.sendImageMessage();
                                        },
                                        right: 5,
                                        svgIcon: Assets.imagesChatGalleryIcon,
                                      ),
                                    ],
                                  )
                                : Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 25,
                                      ),
                                    ),
                                  )),

                            // Custom TextFields
                            //--------------------------------------
                            Expanded(
                              child: CustomTextField(
                                  onChanged: (value) {
                                    controller.message.value = value;
                                  },
                                  controller: controller.messageController,
                                  onTextFieldTap: () {
                                    (sendIconVisibility == true)
                                        ? sendIconVisibility = false
                                        : sendIconVisibility = true;

                                    setState(() {});
                                  },
                                  hintText: "Type Something...",
                                  isUseLebelText: false,
                                  height: 40,
                                  outlineBorderColor: kTransperentColor,
                                  filled: true,
                                  backgroundColor: kGreyColor2,
                                  haveSuffixIcon: true,
                                  suffixWidget: Container(
                                    width: 50,
                                    child: Center(
                                      child: SvgIconsButton(
                                        onTap: () {
                                          tapOnGif == true
                                              ? tapOnGif = false
                                              : tapOnGif = true;
                                          setState(() {});
                                        },
                                        svgIcon: (tapOnGif == true)
                                            ? Assets.imagesGifBlueIcon
                                            : Assets.imagesGifIcon,
                                      ),
                                    ),
                                  )),
                            ),
                            Obx(
                              () => (controller.message.isEmpty)
                                  ? SvgIconsButton(
                                      left: 20,
                                      horizontalPadding: 0,
                                      onTap: () {
                                        controller.startVoiceRecording();
                                        // haveVoiceNote=!haveVoiceNote;

                                        setState(() {});
                                      },
                                      svgIcon: (controller.voiceNote.isTrue)
                                          ? Assets.imagesVoiceBlueIcon
                                          : Assets.imagesVoiceGreyIcon,
                                    )
                                  : SvgIconsButton(
                                      left: 20,
                                      horizontalPadding: 0,
                                      onTap: () {
                                        // (haveVoiceNote == true)
                                        //     ? haveVoiceNote = false
                                        //     : haveVoiceNote = true;
                                        // setState(() {});

                                        controller.sendMessage(
                                            userModel: userModel.value,
                                            chatThreadModel:
                                                widget.chatThreadModel);
                                      },
                                      svgIcon: Assets.imagesSendMessageIcon),
                            )
                          ]),
                          Obx(() => controller.voiceNote.isTrue
                              ? GestureDetector(
                                  onTap: () {
                                    controller.stopVoiceRecording();
                                  },
                                  child: Container(
                                    height: 120,
                                    margin: EdgeInsets.symmetric(vertical: 25),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.mic_none_rounded,
                                        size: 45,
                                        color: kWhiteColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Container())
                        ],
                      ),
                    ),
            )
          : Container(
              decoration: AppStyling().topShadowDecoration(),

              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //height: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => controller.sending.isTrue
                        ? Row(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                child: Text("Sending..."),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                  Row(children: [
                    // Svg Icon add files or something else
                    //--------------------------------------
                    Obx(() => (controller.message.isEmpty)
                        ? Row(
                            children: [
                              SvgIconsButton(
                                onTap: () {
                                  if (openFiles == false) {
                                    openFiles = true;
                                  }
                                  setState(() {});

                                  // Bottom Sheet For Files
                                  //--------------------------
                                  Get.bottomSheet(
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      color: kGreyColor2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Camera
                                              _FilesButtons(
                                                onTap: () {
                                                  controller.sendImageMessage(
                                                      galleryImage: false);
                                                },
                                                svgIcon:
                                                    Assets.imagesCameraGreyIcon,
                                                title: "Camera",
                                              ),
                                              // Documnet
                                              _FilesButtons(
                                                onTap: () {
                                                  controller.sendFileMessage();
                                                },
                                                svgIcon:
                                                    Assets.imagesFileGreyIcon,
                                                title: "File",
                                              ),
                                              //Gallery
                                              _FilesButtons(
                                                onTap: () {
                                                  controller.sendImageMessage();
                                                },
                                                svgIcon: Assets
                                                    .imagesGalleryGreyIcon,
                                                title: "Gallery",
                                              ),
                                              //Music
                                              _FilesButtons(
                                                onTap: () {
                                                  // Get.back();
                                                  controller.sendMusicMessage();
                                                },
                                                svgIcon:
                                                    Assets.imagesMusicGreyIcon,
                                                title: "Music",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).then((value) {
                                    if (openFiles == true) {
                                      openFiles = false;
                                    }
                                    setState(() {});
                                  });
                                },
                                horizontalPadding: 0,
                                right: 10,
                                svgIcon: (openFiles == true)
                                    ? Assets.imagesCrossBlueIcon
                                    : Assets.imagesAddGreyIcon,
                              ),
                              SvgIconsButton(
                                onTap: () {
                                  controller.sendImageMessage();
                                },
                                right: 5,
                                svgIcon: Assets.imagesChatGalleryIcon,
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 25,
                              ),
                            ),
                          )),

                    // Custom TextFields
                    //--------------------------------------
                    Expanded(
                      child: CustomTextField(
                          onChanged: (value) {
                            controller.message.value = value;
                          },
                          controller: controller.messageController,
                          onTextFieldTap: () {
                            (sendIconVisibility == true)
                                ? sendIconVisibility = false
                                : sendIconVisibility = true;

                            setState(() {});
                          },
                          hintText: "Type Something...",
                          isUseLebelText: false,
                          height: 40,
                          outlineBorderColor: kTransperentColor,
                          filled: true,
                          backgroundColor: kGreyColor2,
                          haveSuffixIcon: true,
                          suffixWidget: Container(
                            width: 50,
                            child: Center(
                              child: SvgIconsButton(
                                onTap: () {
                                  tapOnGif == true
                                      ? tapOnGif = false
                                      : tapOnGif = true;
                                  setState(() {});
                                },
                                svgIcon: (tapOnGif == true)
                                    ? Assets.imagesGifBlueIcon
                                    : Assets.imagesGifIcon,
                              ),
                            ),
                          )),
                    ),
                    Obx(
                      () => (controller.message.isEmpty)
                          ? SvgIconsButton(
                              left: 20,
                              horizontalPadding: 0,
                              onTap: () {
                                controller.startVoiceRecording();
                                // haveVoiceNote=!haveVoiceNote;

                                setState(() {});
                              },
                              svgIcon: (controller.voiceNote.isTrue)
                                  ? Assets.imagesVoiceBlueIcon
                                  : Assets.imagesVoiceGreyIcon,
                            )
                          : SvgIconsButton(
                              left: 20,
                              horizontalPadding: 0,
                              onTap: () {
                                // (haveVoiceNote == true)
                                //     ? haveVoiceNote = false
                                //     : haveVoiceNote = true;
                                // setState(() {});

                                controller.sendMessage(
                                    userModel: userModel.value,
                                    chatThreadModel: widget.chatThreadModel);
                              },
                              svgIcon: Assets.imagesSendMessageIcon),
                    )
                  ]),
                  Obx(() => controller.voiceNote.isTrue
                      ? GestureDetector(
                          onTap: () {
                            controller.stopVoiceRecording();
                          },
                          child: Container(
                            height: 120,
                            margin: EdgeInsets.symmetric(vertical: 25),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.mic_none_rounded,
                                size: 45,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        )
                      : Container())
                ],
              ),
            ),
      // bottomSheet: ,
    );
  }

  Future<dynamic> getDefaultDialogFunction({
    required VoidCallback onOkTap,
    required Widget widget,
    String? title,
  }) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: kPrimaryColor,
        shadowColor: kTransperentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the border radius as needed
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(text: "$title"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: widget,
            ),
            _DailogButton(
              mTop: 10,
              onTap: onOkTap,
              title: 'Ok',
            ),
            _DailogButton(
              mTop: 8,
              onTap: () {
                Get.back();
              },
              title: 'Cancel',
              haveOutlineBtn: true,
            ),
          ],
        ),
      ),
      // contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}

class _defaultDailogCheckItems extends StatelessWidget {
  final Function(dynamic)? onChange;
  final bool ischecked;
  final String? title;
  final double mTop;

  const _defaultDailogCheckItems(
      {super.key,
      this.onChange,
      this.ischecked = false,
      this.title,
      this.mTop = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CheckBoxWidget(isChecked: ischecked, onChanged: onChange),
          Expanded(
            child: MyText(
              paddingLeft: 10,
              //textAlign: TextAlign.center,
              text: "$title",
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailogButton extends StatelessWidget {
  final bool haveOutlineBtn;
  final String? title;
  final VoidCallback onTap;
  final double mTop;

  const _DailogButton({
    super.key,
    required this.onTap,
    this.title,
    this.haveOutlineBtn = false,
    this.mTop = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: MyButton(
        mTop: mTop,
        onTap: onTap,
        height: 32,
        buttonText: "$title",
        radius: 7,
        fontSize: 12,
        fontColor: (haveOutlineBtn == true) ? kBlackColor1 : kWhiteColor,
        fontWeight: FontWeight.w500,
        outlineColor:
            (haveOutlineBtn == true) ? kSecondaryColor : kTransperentColor,
        backgroundColor:
            (haveOutlineBtn == true) ? kTransperentColor : kSecondaryColor,
      ),
    );
  }
}

class EndDrawerWidget extends StatelessWidget {
  final VoidCallback? onMediaTap,
      onMuteChatTap,
      onClearChatTap,
      onReportTap,
      onBlockTap;

  final bool isGroupChat;
  final String blockTitle;

  const EndDrawerWidget({
    super.key,
    this.onBlockTap,
    this.onClearChatTap,
    this.onMediaTap,
    this.onMuteChatTap,
    this.onReportTap,
    required this.isGroupChat,
    this.blockTitle = 'Block',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        surfaceTintColor: kPrimaryColor,
        width: 214,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        // Your drawer content here
        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: isGroupChat == false
              ? Column(
                  children: [
                    _DrawerButton(
                      onTap: onMediaTap,
                      title: "Media",
                    ),
                    _DrawerButton(
                      onTap: onMuteChatTap,
                      title: "Mute chat",
                    ),
                    _DrawerButton(
                      onTap: onClearChatTap,
                      title: "Clear Chat",
                    ),
                    _DrawerButton(
                      onTap: onReportTap,
                      title: "Report",
                    ),
                    _DrawerButton(
                      onTap: onBlockTap,
                      title: "$blockTitle",
                    ),
                  ],
                )
              : Container(),
        ));
  }
}

class _DrawerButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;

  const _DrawerButton({
    super.key,
    this.onTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        //color: Colors.amber,
        child: Row(
          children: [
            Expanded(
              child: MyText(
                text: "$title",
                size: 16,
                weight: FontWeight.w400,
                color: kBlackColor1,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FilesButtons extends StatelessWidget {
  final String? svgIcon, title;
  final VoidCallback? onTap;

  const _FilesButtons({super.key, this.svgIcon, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CommonImageView(
            svgPath: svgIcon,
          ),
          MyText(
            paddingTop: 27,
            text: "$title",
            size: 12,
            weight: FontWeight.w500,
            color: kGreyColor1,
          )
        ],
      ),
    );
  }
}

///
class _ChatBubble extends StatelessWidget {
  final String? profileImg;
  final String? message;
  final String? fileName;
  final String? textTime;
  final bool statusOnline;
  final bool? isMe;
  final MessageType messageType; // New field for image URL

  const _ChatBubble({
    Key? key,
    this.profileImg,
    this.message,
    this.statusOnline = true,
    this.textTime,
    this.isMe = true,
    required this.messageType,
    this.fileName, // Initialize with null by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ChatController>();
    return Align(
      alignment: isMe == true ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(8.0), // Adjust padding as needed
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isMe == true ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe == false
                ? _ChatBubblePersonPicture(
                    personProfile: profileImg,
                    personStatus: statusOnline,
                  )
                : Container(),
            SizedBox(
              width: 5,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.7, // Limit the width of the chat bubble
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe == true ? Colors.blue : Colors.grey,
                // Change color based on sender or receiver
                borderRadius: BorderRadius.only(
                  topLeft:
                      isMe == true ? Radius.circular(12) : Radius.circular(0),
                  topRight:
                      isMe == true ? Radius.circular(0) : Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (messageType ==
                      MessageType.text) // Show text message if available
                    Text(
                      '${message}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  if (messageType ==
                      MessageType.image) // Show image if available
                    GestureDetector(
                      onLongPress: () {
                        print("Long Pressed");
                        Get.defaultDialog(
                            contentPadding: EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                            title: "Do You want to download",
                            middleText: '',
                            titleStyle: TextStyle(fontSize: 16),
                            confirm: MyButton(
                                onTap: () async {
                                  Get.back();
                                  bool permission =
                                      await Utils.storagePermission();
                                  final id =
                                      DateTime.now().millisecondsSinceEpoch ~/
                                          1000;
                                  if (permission) {
                                    controller.downloading.value = true;
                                    LocalNotificationService.instance
                                        .showNotification(id, "Downloading",
                                            "File is downloading");
                                    await DownloadFileService.instance
                                        .saveNetworkImage(
                                            url: message ?? '',
                                            onReceiveProgress:
                                                (int receive, int total) {
                                              LocalNotificationService.instance
                                                  .updateNotification(
                                                      id,
                                                      "Downloading",
                                                      "Image is Downloading",
                                                      int.parse(controller
                                                          .downloadingValue
                                                          .value),
                                                      total);
                                            });
                                    LocalNotificationService.instance
                                        .cancelNotification(id);
                                    CustomSnackBars.instance
                                        .showSuccessSnackbar(
                                            title: "Success",
                                            message: "Image Download");
                                    controller.downloading(false);
                                  }
                                },
                                buttonText: "Download"));
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${message}',
                        fit: BoxFit.cover,
                        width: 200,
                        // Set width as needed
                        height: 200,
                        // Set height as needed
                        placeholder: (context, url) => Container(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: Colors.white,
                        ))),
                        // Placeholder widget while loading
                        errorWidget: (context, url, error) => Icon(
                            Icons.error), // Widget to display if loading fails
                      ),
                    ),
                  if (messageType == MessageType.audio)
                    VoiceMessageView(
                      controller: VoiceController(
                        audioSrc: message ?? '',
                        maxDuration: Duration(hours: 3),
                        isFile: false,
                        onComplete: () {
                          /// do something on complete
                        },
                        onPause: () {
                          /// do something on pause
                        },
                        onPlaying: () {
                          /// do something on playing
                        },
                        onError: (err) {
                          /// do somethin on error
                        },
                      ),
                      innerPadding: 12,
                      cornerRadius: 20,
                    ),
                  if (messageType == MessageType.file)
                    GestureDetector(
                      onTap: () async {
                        await controller.openFile(
                            url: message ?? '', fileName: fileName ?? '');
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.file_copy,
                              color: kWhiteColor,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            "$fileName",
                            style: TextStyle(color: kWhiteColor),
                          ))
                        ],
                      ),
                    ),
                  if (textTime != null) // Show time if available
                    Text(
                      textTime!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///

///
// class _ChatBubble extends StatelessWidget {
//   final String? profileImg, textMessages, textTime;
//   final bool statusOnline;
//   final bool isSender; // New field to determine if the message is from the sender
//
//   const _ChatBubble({
//     super.key,
//     this.profileImg,
//     this.textMessages,
//     this.statusOnline = true,
//     this.textTime,
//     this.isSender = true, // Initialize with false by default
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: AppSizes.DEFAULT,
//       child: Row(
//         mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start, // Align sender's messages to the right
//         children: [
//           if (!isSender) // Show profile picture only for receiver's messages
//             _ChatBubblePersonPicture(
//               personProfile: profileImg,
//               personStatus: statusOnline,
//             ),
//           Container(
//             margin: EdgeInsets.only(
//               left: isSender ? 0 : 10, // Adjust margin based on sender or receiver
//               right: isSender ? 10 : 0, // Adjust margin based on sender or receiver
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             decoration: AppStyling().decorationBorderRadius(),
//             child: Column(
//               crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start, // Align sender's messages to the right
//               children: [
//                 MyText(
//                   paddingTop: 10,
//                   paddingBottom: 10,
//                   text: "$textMessages",
//                   size: 16,
//                   weight: FontWeight.w400,
//                   color: kGreyColor1,
//                 ),
//                 MyText(
//                   paddingLeft: isSender ? 0 : 12, // Adjust padding based on sender or receiver
//                   paddingTop: 10,
//                   text: "$textTime",
//                   size: 11,
//                   weight: FontWeight.w400,
//                   color: kGreyColor1,
//                 ),
//               ],
//             ),
//           ),
//           if (isSender) // Show profile picture only for sender's messages
//             _ChatBubblePersonPicture(
//               personProfile: profileImg,
//               personStatus: statusOnline,
//             ),
//         ],
//       ),
//     );
//   }
// }
///

class _ChatBubblePersonPicture extends StatelessWidget {
  final String? personProfile;
  final bool personStatus;

  const _ChatBubblePersonPicture(
      {super.key, this.personProfile, this.personStatus = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: personProfile ?? dummyProfile,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (personStatus) ? kGreenColor : kGreyColor1,
                  border: Border.all(color: kWhiteColor, width: 3)),
            ))
      ],
    );
  }
}

// New Message Bage
class _NewMessageBage extends StatelessWidget {
  const _NewMessageBage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HorizantalDivider(
            color: kSecondaryColor,
            thickness: 0.8,
          ),
        ),
        MyText(
          paddingLeft: 15,
          paddingRight: 15,
          text: "New messages",
          size: 12,
          weight: FontWeight.w500,
          color: kSecondaryColor,
        ),
        Expanded(
          child: HorizantalDivider(
            color: kSecondaryColor,
            thickness: 0.8,
          ),
        )
      ],
    );
  }
}
