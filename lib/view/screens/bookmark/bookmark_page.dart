import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/view/widget/appbar_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_styling.dart';
import '../../../controllers/post_controllers/post_controller.dart';
import '../../../core/utils/snackbar.dart';
import '../../../core/utils/utils.dart';
import '../../../models/user_model/user_model.dart';
import '../../../services/download_file_service.dart';
import '../../../services/local_notification_service.dart';
import '../../widget/bar.dart';
import '../../widget/post_widget.dart';
import '../home/comments.dart';
import '../home/home.dart';
import '../home/home.dart' as post;
import '../profile/profile.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  PostController postController = Get.find();
  bool haveBookMark = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar_widget(
          haveActionIcons: false,
          title: "Bookmark Posts"
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
                userModelGlobal.value.bookmarked.length, (index) {
              return FutureBuilder(future: postsCollection.doc(
                  userModelGlobal.value.bookmarked[index]).get(), builder: (context, snapshot) {
                    if(snapshot.hasData){
                      PostModel posts = PostModel.fromMap(snapshot.data?.data() as Map<String,dynamic>);
                      return StreamBuilder(
                          stream: usersCollection.doc(posts.uid).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return const SizedBox.shrink();
                            UserModel udata =
                            UserModel.fromJson(snapshot.data!);
                            var profilePic = udata.profilePicture;

                            var userName = udata.name;
                            bool liked = false;
                            bool bookmarked = userModelGlobal.value.bookmarked
                                .contains(posts.postID);
                            int likes = 0;
                            int comments = 0;
                            if (!snapshot.hasData) {
                              liked = false;
                              likes = 0;
                              comments = 0;
                            }

                            if (snapshot.hasData) {
                              likes = posts.likes;
                            }

                            if (posts.likesList
                                .contains(userModelGlobal!.value.uid!)) {
                              liked = true;
                            }
                            return post.PostCard(
                              postedImg: profilePic,
                              posterName: userName,
                              commentsCount: posts.comments,
                              likesCount: likes,
                              shareOnTap: () {},
                              totallCommentOnTap: () {},
                              popMenuTap: () {
                                Get.bottomSheet(Container(
                                  padding: AppSizes.DEFAULT,
                                  decoration:
                                  AppStyling().decorationForBottomSheet(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BarWith60Width(),

                                      BottomSheetButton(
                                        onTap: () {
                                          Get.to(() => ProfilePage(
                                            userId: posts.uid,
                                          ));
                                        },
                                        title: "View profile",
                                        svgIcon: Assets.imagesViewProfileIcon,
                                      ),
                                      BottomSheetButton(
                                        onTap: () {},
                                        title: "Report account",
                                        svgIcon: Assets.imagesReportAccountIcon,
                                      ),
                                      BottomSheetButton(
                                        onTap: () async {
                                          print("Tapped");
                                          // DownloadFileService.instance
                                          //     .downloadFiles(
                                          //     url: posts.content.url,
                                          //     desc: posts.content.postType);
                                          // _flutterMediaDownloaderPlugin.downloadFile(posts.content.url, "Downloading", posts.content.postType, 'images');
                                          Get.back();
                                          bool permissionStatus =
                                          await Utils.storagePermission();

                                          if (permissionStatus) {
                                            final id = DateTime.now()
                                                .millisecondsSinceEpoch ~/
                                                1000;
                                            postController.downloading.value =
                                            true;
                                            if (posts.content.postType ==
                                                'Video') {
                                              await DownloadFileService.instance
                                                  .saveNetworkVideoFile(
                                                  url: posts.content.url);
                                              CustomSnackBars.instance
                                                  .showSuccessSnackbar(
                                                  title: "Success",
                                                  message:
                                                  "Video Downloaded");
                                            } else {
                                              LocalNotificationService.instance
                                                  .showNotification(
                                                  id,
                                                  "Downloading",
                                                  "Image is Downloading");
                                              await DownloadFileService.instance
                                                  .saveNetworkImage(
                                                  url: posts.content.url,
                                                  onReceiveProgress:
                                                      (int receive,
                                                      int total) {
                                                    if (total != -1) {
                                                      postController
                                                          .downloadingValue
                                                          .value = ((receive /
                                                          total) *
                                                          100)
                                                          .toStringAsFixed(
                                                          0) +
                                                          '%';
                                                      LocalNotificationService
                                                          .instance
                                                          .updateNotification(
                                                          id,
                                                          "Downlaoding",
                                                          "Image is downloading",
                                                          int.parse(postController
                                                              .downloadingValue
                                                              .value),
                                                          total);
                                                    }
                                                  });
                                              LocalNotificationService.instance
                                                  .cancelNotification(id);
                                              postController.downloading.value =
                                              false;
                                              CustomSnackBars.instance
                                                  .showSuccessSnackbar(
                                                  title: "Success",
                                                  message:
                                                  "Image Downloaded");
                                            }
                                          } else {
                                            CustomSnackBars.instance
                                                .showFailureSnackbar(
                                                title: "Failed",
                                                message:
                                                "Permission Denied");
                                          }

                                          ///
                                          // DownloadFileService.instance.downloadFile(
                                          //     posts.content.url,
                                          //     'file_${DateTime.now().millisecondsSinceEpoch}.${posts.content.postType == 'Video' ? '.mp4' : '.jpeg'}',
                                          //     posts.content.postType ==
                                          //         'Video');
                                        },
                                        title: "Download",
                                        svgIcon: Assets.imagesReportAccountIcon,
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ));
                              },
                              otherProfileTap: () {
                                Get.to(
                                      () => ProfilePage(
                                    userId: posts.uid,
                                  ),
                                );
                              },
                              postIImg: Assets.imagesFoodImgPng,
                              haveFav: liked,
                              haveBookMark: bookmarked,
                              favOnTap: () {
                                postController.likePost(
                                    postId: posts.postID, isAddLike: !liked);
                              },
                              bookMarkOnTap: () {
                                postController.addBookMark(
                                    isAddBookmark: !bookmarked,
                                    postId: posts.postID);
                                (haveBookMark)
                                    ? haveBookMark = false
                                    : haveBookMark = true;
                                setState(() {});
                              },
                              postCommentOnTap: () async {
                                // Get.bottomSheet(CommentPageCard(),
                                //     isScrollControlled: true, elevation: 0);
                                await postController.postComment(
                                    postId: posts.postID,
                                    sendId: userModelGlobal.value.uid);
                              },
                              replyCommentTap: () async {
                                await postController.postCommentReply(
                                    commentId: postController
                                        .replyingToCommentId.value,
                                    postId: posts.postID,
                                    userId: userModelGlobal.value.uid);
                                postController.replyingToCommentId.value = '';
                                postController.replyToComment.value = '';
                                postController.commentController.clear();
                                postController.inReplyState.value = false;
                              },
                              postModel: posts,
                              commentIconTap: () {
                                Get.bottomSheet(
                                    CommentPageCard(
                                      postModel: posts,
                                    ),
                                    isScrollControlled: true,
                                    elevation: 0);
                              },
                              commentController:
                              postController.commentController,
                            );
                          });
                    }
                    else{
                      return Container(height: 300,child: Center(child: CircularProgressIndicator(),),);
                    }

              },);
            }),
          ),
        ),
      ),
    );
  }
}


