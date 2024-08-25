import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/messages_controllers/inbox_controller.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/models/chat_models/chat_thread_model.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/view/screens/chat/chat_page.dart';
import 'package:soical_media_app/view/screens/chat/new_message.dart';
import 'package:soical_media_app/view/widget/appbar_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var inboxController = Get.find<InboxController>();
    return Scaffold(
      appBar:
          appbar_widget(haveTitle: true, haveBackIcon: false, title: "Message"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyText(
                  text: "Messages",
                  size: 16,
                  weight: FontWeight.w500,
                  color: kBlackColor1,
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(
              () => inboxController.chatThreadModels.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: inboxController.chatThreadModels.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            ChatThreadModel chatThreadModel =
                                inboxController.chatThreadModels[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Slidable(
                                endActionPane: ActionPane(
                                    motion: DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: kQuaternaryColor,
                                        onPressed: (contex) {},
                                        icon: Icons.visibility_off,
                                        foregroundColor: kWhiteColor,
                                      ),
                                      SlidableAction(
                                        onPressed: (contex) async {
                                          await FirebaseCRUDServices.instance
                                              .deleteDocument(
                                                  collectionPath:
                                                      FirebaseConstants
                                                          .chatRoomsCollection,
                                                  docId: chatThreadModel
                                                          .chatHeadId ??
                                                      '');
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: kTertiaryColor,
                                      ),
                                    ]),
                                child: _ChatCard(
                                  profileUrl: chatThreadModel.senderID ==
                                          userModelGlobal.value.uid
                                      ? chatThreadModel.receiverProfileImage
                                      : chatThreadModel.senderProfileImage,
                                  onCardTap: () {
                                    Get.to(
                                        () => ChatPage(
                                              chatThreadModel: chatThreadModel,
                                            ),
                                        binding: ChatBinding(chatThreadModel));
                                  },
                                  userName: chatThreadModel.isGroupChat??false?chatThreadModel.chatTitle: chatThreadModel.senderID ==
                                          userModelGlobal.value.uid
                                      ? chatThreadModel.receiverName ?? ''
                                      : chatThreadModel.senderName ?? '',
                                  userVerified: true,
                                  reciveMsgText:
                                      "${chatThreadModel.lastMessage}",
                                  haveAttachedImg: true,
                                  eventTime:
                                      '${timeago.format(chatThreadModel.lastMessageTime!, locale: 'en_short')} ${timeago.format(chatThreadModel.lastMessageTime!, locale: 'en_short') == 'now'?'':"ago"}',
                                ),
                              ),
                            );
                          }),
                    )
                  : Container(
                      child: Center(
                      child: Text("No Chats Available"),
                    )),

              ///
              // Expanded(
              //   child: StreamBuilder(
              //     stream: ChattingService.instance.streamChatHeads(),
              //     builder: (BuildContext context,
              //         AsyncSnapshot<List<ChatThreadModel>> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       } else if (!snapshot.hasData) {
              //         return Center(
              //           child: Text("No Chats Available"),
              //         );
              //       } else {
              //         print("Has Data**************** ${snapshot.data?.length}");
              //         print(snapshot.data);
              //         return Slidable(
              //           endActionPane: ActionPane(motion: DrawerMotion(), children: [
              //             SlidableAction(
              //               backgroundColor: kQuaternaryColor,
              //               onPressed: (contex) {},
              //               icon: Icons.visibility_off,
              //               foregroundColor: kWhiteColor,
              //             ),
              //             SlidableAction(
              //               onPressed: (contex) {},
              //               icon: Icons.delete,
              //               backgroundColor: kTertiaryColor,
              //             ),
              //           ]),
              //           child: _ChatCard(
              //             onCardTap: () {
              //               Get.to(ChatPage(chatThreadModel: ChatThreadModel(),));
              //             },
              //             userName: "Pamela E Soto",
              //             userVerified: true,
              //             reciveMsgText: "Yahoo, you just made it ❤️ last...",
              //             haveAttachedImg: true,
              //             eventTime: '10:00',
              //           ),
              //         );
              //         ///
              //         //   ListView.builder(
              //         //     itemCount: snapshot.data?.length,
              //         //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //         //     physics: const BouncingScrollPhysics(),
              //         //     itemBuilder: (context, index) {
              //         //
              //         //       ChatThreadModel chatThreadModel = snapshot.data![index];
              //         //       return  Slidable(
              //         //         endActionPane: ActionPane(motion: DrawerMotion(), children: [
              //         //           SlidableAction(
              //         //             backgroundColor: kQuaternaryColor,
              //         //             onPressed: (contex) {},
              //         //             icon: Icons.visibility_off,
              //         //             foregroundColor: kWhiteColor,
              //         //           ),
              //         //           SlidableAction(
              //         //             onPressed: (contex) {},
              //         //             icon: Icons.delete,
              //         //             backgroundColor: kTertiaryColor,
              //         //           ),
              //         //         ]),
              //         //         child: _ChatCard(
              //         //           onCardTap: () {
              //         //             Get.to(ChatPage(chatThreadModel: ChatThreadModel(),));
              //         //           },
              //         //           userName: "Pamela E Soto",
              //         //           userVerified: true,
              //         //           reciveMsgText: "Yahoo, you just made it ❤️ last...",
              //         //           haveAttachedImg: true,
              //         //           eventTime: '10:00',
              //         //         ),
              //         //       );
              //         //     });
              //       }
              //     },
              //   ),
              // ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(NewMessages());
        },
        backgroundColor: kSecondaryColor,
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
    );
  }
}

// This Code For Chat Card shows on Chat Home Page
//-------------------------------------------------

class _ChatCard extends StatelessWidget {
  final String? userName, reciveMsgText, eventTime, profileUrl;
  final bool userVerified, haveAttachedImg;
  final VoidCallback? onCardTap;

  const _ChatCard(
      {super.key,
      this.userName,
      this.eventTime,
      this.reciveMsgText,
      this.haveAttachedImg = true,
      this.userVerified = true,
      this.onCardTap,
      this.profileUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonImageView(
            url: profileUrl ?? dummyProfile,
            // imagePath: Assets.imagesProfileImg4,
            radius: 100,
            height: 50,
            width: 50,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                _UserNameVerification(
                  userName: '$userName',
                  userVerified: userVerified,
                  eventTime: "$eventTime",
                ),
                SizedBox(height: 5),
                _UserAttachFiles(
                  recivePicture: haveAttachedImg,
                  userMessage: '$reciveMsgText',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _UserNameVerification extends StatelessWidget {
  final String userName, eventTime;
  final bool userVerified;

  const _UserNameVerification(
      {super.key,
      this.userName = 'userName',
      this.userVerified = true,
      this.eventTime = '18:00'});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingRight: 8,
          text: userName,
          size: 14,
          weight: FontWeight.w500,
          color: kBlackColor1,
        ),
        (userVerified)
            ? Container(
                //color: Colors.amber,
                child: CommonImageView(
                  svgPath: Assets.imagesUserVerifiedIcon,
                  height: 15,
                ),
              )
            : SizedBox(),
        Spacer(),
        MyText(
          text: eventTime,
          size: 12,
          weight: FontWeight.w500,
          color: kGreyColor1,
        ),
      ],
    );
  }
}

class _UserAttachFiles extends StatelessWidget {
  final String userMessage;
  final bool recivePicture;

  const _UserAttachFiles({
    super.key,
    this.userMessage = 'message',
    this.recivePicture = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        (recivePicture)
            ? Container(
                //color: Colors.amber,
                child: CommonImageView(
                  svgPath: Assets.imagesGallerySmallIcon,
                ),
              )
            : SizedBox(),
        Expanded(
          child: MyText(
            maxLines: 1,
            paddingRight: 8,
            text: " · $userMessage",
            size: 14,
            weight: FontWeight.w400,
            color: kGreyColor1,
          ),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
