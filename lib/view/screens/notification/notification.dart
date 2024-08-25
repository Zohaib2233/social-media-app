import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/notification_controller/notification_controller.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationController notificationController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (_) async {
        notificationController.isLoading.value = true;
        await notificationController.getFollowRequests();
        notificationController.isLoading.value = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 100,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
              ),
            ),
          ),
          centerTitle: true,
          title: MyText(
            text: "Notifications",
            size: 18,
            weight: FontWeight.w600,
          )),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _EventTime(),
            //   ],
            // ),
            MyText(
              text: 'Follow Requests',
              size: 14,
              weight: FontWeight.w500,
            ),
            Obx(
              () => notificationController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: notificationController.followRequests.length,
                      itemBuilder: (context, index) =>
                          _FollowRequestNotificationCard(
                        title: notificationController
                            .followRequests[index].fromUserName!,
                        time: '2 min ago',
                        url: notificationController
                            .followRequests[index].fromUserProfileImage!,
                        topMargin: 12,
                        onConfirmTap: () async {
                          notificationController.isLoading.value = true;
                          await notificationController.acceptFollowRequest(
                              notificationController
                                  .followRequests[index].fromUserId!,
                              notificationController
                                  .followRequests[index].requestId!);
                          notificationController.isLoading.value = false;
                        },
                        onDeleteTap: () async {
                          notificationController.isLoading.value = true;
                          await notificationController.rejectFollowRequest(
                              notificationController
                                  .followRequests[index].requestId!);
                          notificationController.isLoading.value = false;
                        },
                        onFollowBackTap: () {},
                      ),
                    ),
            ),

            // _EventTime()
          ],
        ),
      ),
    );
  }
}

class _EventTime extends StatelessWidget {
  final String eventTime;
  const _EventTime({
    this.eventTime = "Today",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: eventTime,
      size: 14,
      weight: FontWeight.w500,
    );
  }
}

class _FollowRequestNotificationCard extends StatelessWidget {
  final String title, time, url;
  final VoidCallback onFollowBackTap;
  final VoidCallback onConfirmTap;
  final VoidCallback onDeleteTap;
  final double topMargin;

  const _FollowRequestNotificationCard({
    required this.url,
    required this.time,
    required this.title,
    required this.onConfirmTap,
    required this.onDeleteTap,
    required this.onFollowBackTap,
    this.topMargin = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 12),
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: kGreyColor1.withOpacity(0.07),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ]),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonImageView(
                url: url,
                height: 52,
                width: 52,
                radius: 100,
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // MyText(
                        //   text: "Ahmed Khan",
                        //   size: 14,
                        //   weight: FontWeight.w600,
                        // ),
                        Expanded(
                          child: MyText(
                            text: title,
                            size: 14,
                            weight: FontWeight.w600,
                            color: kBlackColor1,
                          ),
                        ),

                        MyText(
                          text: time,
                          size: 10,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: MyText(
                            text: "$title has requested to follow you",
                            size: 12,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _MyNotificationBtn(
                  onTap: onConfirmTap,
                  btnText: "Confim",
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _MyNotificationBtn(
                  onTap: onDeleteTap,
                  btnText: "Delete",
                  fontColor: kBlackColor1,
                  btnColor: kGreyColor2,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _MyNotificationBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String btnText;
  final Color btnColor, fontColor;
  const _MyNotificationBtn(
      {super.key,
      required this.onTap,
      this.btnColor = kSecondaryColor,
      this.btnText = 'txt',
      this.fontColor = kWhiteColor});

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onTap: onTap,
      fontSize: 12,
      height: 39,
      buttonText: btnText,
      fontWeight: FontWeight.w500,
      fontColor: fontColor,
      backgroundColor: btnColor,
    );
  }
}

// class _NotificationCard extends StatelessWidget {
//   final int index;
//   final String? title, subTitle, time, description, commentImg;
//   final VoidCallback onFollowBackTap;
//   final VoidCallback onConfirmTap;
//   final VoidCallback onDeleteTap;
//   final double topMargin;

//   final bool haveCommentImg;
//   const _NotificationCard(
//       {super.key,
//       this.index = 1,
//       this.description,
//       this.subTitle,
//       this.time,
//       this.title,
//       this.commentImg,
//       this.haveCommentImg = false,
//       required this.onConfirmTap,
//       required this.onDeleteTap,
//       required this.onFollowBackTap,
//       this.topMargin = 8});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: topMargin),
//       padding: EdgeInsets.symmetric(horizontal: 11, vertical: 12),
//       decoration: BoxDecoration(
//           color: kWhiteColor,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: kGreyColor1.withOpacity(0.07),
//               spreadRadius: 1,
//               blurRadius: 5,
//             )
//           ]),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonImageView(
//                 imagePath: Assets.imagesProfileImg1,
//                 height: 52,
//                 width: 52,
//                 radius: 100,
//               ),
//               SizedBox(
//                 width: 8,
//               ),
//               Flexible(
//                 child: Column(
//                   children: [
//                     Row(
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // MyText(
//                         //   text: "Ahmed Khan",
//                         //   size: 14,
//                         //   weight: FontWeight.w600,
//                         // ),
//                         Expanded(
//                           child: RichText(
//                               text: TextSpan(
//                                   text: title ?? "Ahmed Khan",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: kBlackColor1),
//                                   children: [
//                                 WidgetSpan(
//                                   child: SizedBox(
//                                     width: 5,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                     text: subTitle ?? 'Follows you',
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400,
//                                         color: kBlackColor1)),
//                               ])),
//                         ),

//                         MyText(
//                           text: title ?? "09:13 am",
//                           size: 10,
//                           weight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 6),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: MyText(
//                             text: description ??
//                                 "Ahmed Khan has followed you you can follow back",
//                             size: 12,
//                             weight: FontWeight.w400,
//                           ),
//                         ),
//                         (haveCommentImg == true)
//                             ? CommonImageView(
//                                 imagePath: commentImg ??
//                                     Assets.imagesNotificationScreenImg,
//                                 height: 59,
//                                 width: 59,
//                               )
//                             : SizedBox()
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 13),
//           (index == 1)
//               ? Row(
//                   children: [
//                     Expanded(
//                       child: _MyNotificationBtn(
//                         onTap: onFollowBackTap,
//                         btnText: "Follow Back",
//                       ),
//                     )
//                   ],
//                 )
//               : (index == 2)
//                   ? Row(
//                       children: [
//                         Expanded(
//                           child: _MyNotificationBtn(
//                             onTap: onConfirmTap,
//                             btnText: "Confim",
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Expanded(
//                           child: _MyNotificationBtn(
//                             onTap: onDeleteTap,
//                             btnText: "Delete",
//                             fontColor: kBlackColor1,
//                             btnColor: kGreyColor2,
//                           ),
//                         )
//                       ],
//                     )
//                   : SizedBox()
//         ],
//       ),
//     );
//   }
// }