import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/view/widget/Horizantall_divider.dart';
import 'package:soical_media_app/view/widget/bar.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../controllers/post_controllers/post_controller.dart';
import '../../../core/global/instance_variables.dart';
import '../../../models/comment_models/comment_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../../services/collections.dart';
import 'home.dart';

class CommentPageCard extends StatefulWidget {
  CommentPageCard({super.key, required this.postModel});
  PostModel postModel;
  @override
  State<CommentPageCard> createState() => _CommentPageCardState();
}

class _CommentPageCardState extends State<CommentPageCard> {
  bool haveFav = false;
  PostController postController = Get.find();
  bool viewNestedComment = true;

  bool suffixIconDisplay = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          BarWith60Width(),
          Align(
            alignment: Alignment.center,
            child: MyText(
              paddingTop: 23,
              paddingBottom: 12,
              text: "Comments",
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          HorizantalDivider(),
          MyText(
            paddingLeft: 35,
            paddingTop: 12,
            paddingBottom: 12,
            text: "${widget.postModel.comments} comments",
            size: 14,
            weight: FontWeight.w500,
          ),
          Expanded(
            child: Container(
              height: Get.height * 0.07,
              child: StreamBuilder(
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return SizedBox.shrink();
                  } else if (snapshot.data == null) {
                    return SizedBox.shrink();
                  } else {
                    var dataList = snapshot.data?.docs;
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: dataList!.length,
                        itemBuilder: (context, index) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: kSecondaryColor,
                              ),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return SizedBox.shrink();
                          } else if (snapshot.data == null) {
                            return SizedBox.shrink();
                          } else {
                            CommentModel commentModel =
                                CommentModel.fromMap(dataList[index].data());
                            return StreamBuilder(
                                stream: usersCollection
                                    .doc(commentModel.sender)
                                    .snapshots(),
                                builder: (context, snapshot3) {
                                  if (!snapshot3.hasData) {
                                    return SizedBox.shrink();
                                  } else if (snapshot3.data == null) {
                                    return SizedBox.shrink();
                                  }
                                  var userData = UserModel.fromJson2(
                                      snapshot3.data!.data()!);
                                  return StreamBuilder(
                                      stream: postsCollection
                                          .doc(widget.postModel.postID)
                                          .collection('comments')
                                          .doc(commentModel.commentId)
                                          .collection('replies')
                                          .orderBy('date', descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot2) {
                                        var hasReply = false;
                                        if (!snapshot2.hasData) {
                                          hasReply = false;
                                        } else if (snapshot2
                                            .data!.docs.isNotEmpty) {
                                          hasReply = true;
                                        } else if (snapshot2.data == null) {
                                          return SizedBox.shrink();
                                        } else {
                                          hasReply = false;
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              CommentsCard(
                                                userComment:
                                                    commentModel.comment,
                                                userName: userData.username,
                                                eventTime:
                                                    '${timeago.format(commentModel.date)}',
                                                haveReplayButton: true,
                                                replyButton: () {
                                                  Get.find<PostController>()
                                                      .inReplyState
                                                      .value = true;
                                                  Get.find<PostController>()
                                                          .replyToComment
                                                          .value =
                                                      commentModel.comment;
                                                  Get.find<PostController>()
                                                          .replyingToCommentId
                                                          .value =
                                                      commentModel.commentId;
                                                },
                                                haveBar: false,
                                                profileImg:
                                                    userData.profilePicture,
                                                haveNestComment: true,
                                              ),
                                              StreamBuilder(
                                                  stream: postsCollection
                                                      .doc(widget
                                                          .postModel.postID)
                                                      .collection('comments')
                                                      .doc(commentModel
                                                          .commentId)
                                                      .collection('replies')
                                                      .orderBy('date',
                                                          descending: true)
                                                      .snapshots(),
                                                  builder:
                                                      (context, snapshot2) {
                                                    if (!snapshot2.hasData) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              kSecondaryColor,
                                                        ),
                                                      );
                                                    } else if (snapshot2
                                                        .data!.docs.isEmpty) {
                                                      return SizedBox.shrink();
                                                    } else if (snapshot2.data ==
                                                        null) {
                                                      return SizedBox.shrink();
                                                    } else {
                                                      var commentData =
                                                          snapshot2.data!.docs;

                                                      return Container(
                                                        height:
                                                            Get.height * 0.20,
                                                        child: ListView.builder(
                                                            itemCount:
                                                                commentData
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              CommentModel
                                                                  commentModel2 =
                                                                  CommentModel.fromMap(
                                                                      commentData![
                                                                              index]
                                                                          .data());
                                                              return StreamBuilder(
                                                                  stream: usersCollection
                                                                      .doc(commentModel2
                                                                          .sender)
                                                                      .snapshots(),
                                                                  builder: (context,
                                                                      userSnapshot) {
                                                                    if (!userSnapshot
                                                                        .hasData) {
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              kSecondaryColor,
                                                                        ),
                                                                      );
                                                                    } else if (userSnapshot
                                                                            .data ==
                                                                        null) {
                                                                      return SizedBox
                                                                          .shrink();
                                                                    } else {
                                                                      UserModel
                                                                          userData2 =
                                                                          UserModel.fromJson(
                                                                              userSnapshot.data!);
                                                                      return CommentsCard(
                                                                        userComment:
                                                                            commentModel2.comment,
                                                                        favButton:
                                                                            () {},
                                                                        userName:
                                                                            userData2.username,
                                                                        eventTime:
                                                                            '${timeago.format(commentModel2.date)}',
                                                                        haveReplayButton:
                                                                            false,
                                                                        replyButton:
                                                                            () {},
                                                                        haveBar:
                                                                            false,
                                                                        profileImg:
                                                                            userData2.profilePicture,
                                                                        haveNestComment:
                                                                            false,
                                                                      );
                                                                    }
                                                                  });
                                                            }),
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                });
                          }
                        });
                  }
                },
                stream: postsCollection
                    .doc(widget.postModel.postID)
                    .collection('comments')
                    .orderBy('date', descending: true)
                    .snapshots(),
              ),
            ),
          ),

          // Text Editing Field For Type Messages
          //-----------------------------------------
          //-----------------------------------------
          Container(
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              decoration: AppStyling().topShadowDecoration(),
              child: Column(
                children: [
                  Obx(
                    () => SizedBox(
                      height:
                          Get.find<PostController>().inReplyState.value == true
                              ? 0
                              : 30,
                    ),
                  ),
                  Obx(() => Get.find<PostController>().inReplyState.value ==
                          true
                      ? replyCommentField(
                          commentController:
                              Get.find<PostController>().commentController,
                          commentPostTap: () async {
                            await postController.postCommentReply(
                                commentId:
                                    postController.replyingToCommentId.value,
                                postId: widget.postModel.postID,
                                userId: userModelGlobal.value.uid);
                            postController.replyingToCommentId.value = '';
                            postController.replyToComment.value = '';
                            postController.commentController.clear();
                            postController.inReplyState.value = false;
                          },
                          comment:
                              Get.find<PostController>().replyToComment.value,
                          commentId: Get.find<PostController>()
                              .replyingToCommentId
                              .value)
                      : commentField(
                          commentController:
                              Get.find<PostController>().commentController,
                          commentPostTap: () async {
                            await Get.find<PostController>().postComment(
                                postId: widget.postModel.postID,
                                sendId: userModelGlobal.value.uid);
                          }))
                ],
              )),
        ],
      ),
    );
  }
}

class DiplayCount extends StatelessWidget {
  final String? svgIcon, count;
  const DiplayCount({
    super.key,
    this.count,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonImageView(
          svgPath: svgIcon,
          height: 14,
        ),
        MyText(
          paddingLeft: 5,
          text: '1$count',
          size: 13,
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}

class CommentsCard extends StatelessWidget {
  final bool haveNestComment;
  final String? profileImg, userName, userComment, eventTime;
  final VoidCallback? replyButton;
  final VoidCallback? favButton;
  final bool haveIconFav;
  final VoidCallback? viewAllOnTap;
  final Widget? nestedCommentWidget;
  final double horizontalPadding;
  final bool haveReplayButton;
  final double verticalPadding;
  final bool haveBar;
  const CommentsCard({
    super.key,
    this.haveNestComment = false,
    this.eventTime,
    this.profileImg,
    this.userComment,
    this.userName,
    this.replyButton,
    this.favButton,
    this.haveIconFav = false,
    this.viewAllOnTap,
    this.nestedCommentWidget,
    this.horizontalPadding = 8,
    this.verticalPadding = 10,
    this.haveReplayButton = true,
    this.haveBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: (haveNestComment == false)
                ? AppSizes.HORIZONTAL
                : EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImageView(
                      url: profileImg,
                      radius: 100,
                      height: 28,
                      width: 28,
                    ),
                    SizedBox(width: 7),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            paddingBottom: 2,
                            text: "$userName",
                            size: 12,
                            weight: FontWeight.w400,
                            color: kGreyColor1.withOpacity(0.7),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyText(
                                  paddingTop: 2,
                                  text: "$userComment",
                                  size: 12,
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              MyText(
                                text: "$eventTime",
                                size: 11,
                                weight: FontWeight.w400,
                                color: kGreyColor1.withOpacity(0.7),
                              ),
                              !haveReplayButton
                                  ? SizedBox.shrink()
                                  : MyText(
                                      onTap: replyButton,
                                      paddingLeft: 16,
                                      paddingRight: 10,
                                      text: "Reply",
                                      size: 11,
                                      weight: FontWeight.w400,
                                      color: kGreyColor1.withOpacity(0.7),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // total comments & make Fav
                    //-------------------------
                    // GestureDetector(
                    //   onTap: favButton,
                    //   child: Column(
                    //     children: [
                    //       CommonImageView(
                    //         svgPath: (haveIconFav == true)
                    //             ? Assets.imagesFavFillIcon
                    //             : Assets.imagesFavOutlineIcon,
                    //         height: 11,
                    //         width: 13,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    //--------------------------------------
                  ],
                ),
                SizedBox(
                  height: 14,
                ),

                // Nested Widget
                //---------------------------
                //---------------------------
                //---------------------------
                (haveNestComment == false)
                    ? Container(
                        child: nestedCommentWidget,
                      )
                    : SizedBox.shrink(),

                // Nested Widget
                //---------------------------
                //---------------------------
                //---------------------------
                (haveBar == true)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: HorizantalDivider()),
                          MyText(
                            paddingLeft: 20,
                            paddingRight: 20,
                            onTap: viewAllOnTap,
                            paddingTop: 2,
                            text: "View Replies",
                            size: 11,
                            weight: FontWeight.w400,
                            color: kGreyColor1.withOpacity(0.7),
                          ),
                          Expanded(flex: 3, child: HorizantalDivider()),
                        ],
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
