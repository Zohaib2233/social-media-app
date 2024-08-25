import 'package:advstory/advstory.dart' as advs;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/controllers/post_controllers/post_controller.dart';
import 'package:soical_media_app/controllers/story_controller/story_controller.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/core/utils/utils.dart';
import 'package:soical_media_app/models/comment_models/comment_model.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/download_file_service.dart';
import 'package:soical_media_app/services/local_notification_service.dart';
import 'package:soical_media_app/view/screens/bookmark/bookmark_page.dart';
import 'package:soical_media_app/view/screens/home/comments.dart';
import 'package:soical_media_app/view/screens/profile/profile.dart';
import 'package:soical_media_app/view/widget/appbar_widget.dart';
import 'package:soical_media_app/view/widget/bar.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import '../../../core/global/instance_variables.dart';
import '../../../models/story_models/switch_story_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool haveFav = true;
  bool haveBookMark = true;
  bool _isScrollingDown = false;
  RxBool showStatus = true.obs;
  PostController postController = Get.find();
  StoryUploadController storyUploadController = Get.find();

  PageController _pageController = PageController();


  @override
  void initState() {

    super.initState();

    print("Home init called");
    _pageController.addListener(() {
      print("scroll direction = ${_pageController.position.userScrollDirection}");
      if (_pageController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          _isScrollingDown = true;
          showStatus.value=false;
        }
      } else if (_pageController.position.userScrollDirection == ScrollDirection.forward) {
        if (_isScrollingDown) {
          _isScrollingDown = false;
          showStatus.value=true;
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      //physics: const BouncingScrollPhysics(),
      slivers: [
        Obx(
          () => _SliverAppBarWidget(
            isStatusShow: showStatus.value,
            isSpaceActive:
                Get.find<PostController>().postUploading.value == true
                    ? true
                    : storyUploadController.isUploadingStories.isTrue == true
                        ? true
                        : false,
            // status
            //----------------------
            widget: Obx(()=>showStatus.value == true?
                Column(
                children: [
                  Expanded(
                    child: Container(

                      margin: EdgeInsets.only(top: 120),
                      // color: Colors.amber,
                      height: Get.height * 0.12,
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child:
                        Row(
                            children: [
                              _UploadStatusBtn(
                                onTap: () {
                                  // Get.to(UploadStatusPage());
                                  Get.defaultDialog(
                                      title: 'Pick from',
                                      backgroundColor: kPrimaryColor,
                                      content: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                              storyUploadController
                                                  .buildOpenImagePickerBottomSheet(
                                                      context: context,
                                                      cameraTap: () async {
                                                        Navigator.pop(context);
                                                        await storyUploadController
                                                            .pickImageFromCamera();
                                                      },
                                                      galleryTap: () async {
                                                        Navigator.pop(context);
                                                        await storyUploadController
                                                            .pickImage();
                                                      });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  size: 40,
                                                  color: kSecondaryColor,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Image',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                              storyUploadController
                                                  .buildOpenVideoPickerBottomSheet(
                                                      context: context,
                                                      cameraTap: () async {
                                                        Navigator.pop(context);
                                                        await storyUploadController
                                                            .pickVideoFromCamera();
                                                      },
                                                      galleryTap: () async {
                                                        Navigator.pop(context);
                                                        await storyUploadController
                                                            .pickVideo();
                                                      });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.video_call,
                                                  size: 45,
                                                  color: kSecondaryColor,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Video',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              ),
                              Obx(
                                () => storyUploadController.refreshStory.isTrue
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CircularProgressIndicator(
                                          color: kSecondaryColor,
                                        ),
                                      )
                                    : FutureBuilder<List<SwitchStoryGroup>>(
                                        future: storyUploadController
                                            .getFollowingStories(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null ||
                                              snapshot.data!.isEmpty)
                                            return Container();
                                          final stories = snapshot.data!;
                                          return Expanded(
                                            child: advs.AdvStory(
                                              style: advs.AdvStoryStyle(
                                                  trayListStyle:
                                                      advs.TrayListStyle()),
                                              storyCount: stories.length,
                                              controller: storyUploadController
                                                  .advController,
                                              storyBuilder: (storyIndex) {
                                                return advs.Story(
                                                  header: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          stories[storyIndex]
                                                                              .owner
                                                                              .profilePicture),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      top: 60,
                                                                      left: 10),
                                                              child: Container(
                                                                height: 60,
                                                                width: 200,
                                                                child: Text(
                                                                  '@${stories[storyIndex].owner.username}',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 14),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Center(
                                                                  child: Icon(
                                                                      Icons
                                                                          .cancel_outlined,
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  contentCount: stories[storyIndex]
                                                      .stories
                                                      .length,
                                                  contentBuilder: (contentIndex) {
                                                    storyUploadController
                                                        .storyIndexRn
                                                        .value = contentIndex;
                                                    // print(contentIndex);
                                                    // print(storyIndexRn.value);
                                                    final content =
                                                        stories[storyIndex]
                                                            .stories[contentIndex]
                                                            .image;
                                                    final type = stories[storyIndex]
                                                        .stories[contentIndex]
                                                        .type;
                                                    return type == 'image'
                                                        ? advs.ImageContent(
                                                            url: content,
                                                          )
                                                        : advs.VideoContent(
                                                            url: content);
                                                  },
                                                );
                                              },
                                              trayBuilder: (storyIndex) {
                                                final owner =
                                                    stories[storyIndex].owner;
                                                return advs.AdvStoryTray(
                                                  url: owner.profilePicture,
                                                  size: Size(70, 70),
                                                  username: Text(
                                                    owner.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                  Get.find<PostController>().postUploading.value
                      ? _buildPostUploadingContainer()
                      : storyUploadController.isUploadingStories.value == true
                          ? _buildStoryUploadingContainer()
                          : postController.downloading.isTrue
                              ? Container(
                                  width: Get.width,
                                  height: 20,
                                  color: Colors.blueAccent,
                                  child: Center(
                                      child: Text(
                                          "Downloading ${postController.downloadingValue.value}")),
                                )
                              : SizedBox.shrink(),
                ],
              ):Container(),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child:
                    Container(
                    height: Get.height * 0.7,
                    child: PaginateFirestore(
                        pageController: _pageController,

                      itemsPerPage: 10,
                      onEmpty: Center(
                        child: MyText(
                          text: 'No data to show!!!',
                          size: 18,
                          color: kSecondaryColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                      allowImplicitScrolling: true,
                      shrinkWrap: true,
                      query:
                          postsCollection.orderBy('postDate', descending: true),
                      itemBuilder: (context, documentSnapshots, index) {
                        List filteredSnapshots = documentSnapshots.where((doc) {
                          PostModel post = PostModel.fromMap(
                              doc.data() as Map<String, dynamic>);
                          return !userModelGlobal.value.blockAccounts
                              .contains(post.uid);
                        }).toList();

                        if (index >= filteredSnapshots.length) {
                          return SizedBox.shrink();
                        }

                        PostModel posts = PostModel.fromMap(
                            filteredSnapshots[index].data()
                                as Map<String, dynamic>);
                        // if (userModelGlobal.value.blockAccounts
                        //     .contains(posts.uid)) return SizedBox.shrink();
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
                              return PostCard(
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
                      },

                      initialLoader: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          height: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      padding: AppSizes.HORIZONTAL,
                      physics: const BouncingScrollPhysics(),
                      itemBuilderType: PaginateBuilderType.pageView,
                      isLive: true,
                      includeMetadataChanges: true,
                    ),
                  ),

              ),
            ],
          ),
        ),

        // SliverList.builder(
        //   itemCount: 10,
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: AppSizes.HORIZONTAL,
        //       child: _PostCard(
        //         popMenuTap: () {
        //           Get.bottomSheet(Container(
        //             padding: AppSizes.DEFAULT,
        //             decoration: AppStyling().decorationForBottomSheet(),
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 BarWith60Width(),
        //                 BottomSheetButton(
        //                   mTop: 20,
        //                   onTap: () {},
        //                   title: "Unfollow account",
        //                   svgIcon: Assets.imagesUnfollowIcon,
        //                 ),
        //                 BottomSheetButton(
        //                   onTap: () {},
        //                   title: "View profile",
        //                   svgIcon: Assets.imagesViewProfileIcon,
        //                 ),
        //                 BottomSheetButton(
        //                   onTap: () {},
        //                   title: "Report account",
        //                   svgIcon: Assets.imagesReportAccountIcon,
        //                 ),
        //                 SizedBox(height: 20),
        //               ],
        //             ),
        //           ));
        //         },
        //         otherProfileTap: () {
        //           Get.to(UserProfilePage());
        //         },
        //         postIImg: Assets.imagesFoodImgPng,
        //         haveFav: haveFav,
        //         haveBookMark: haveBookMark,
        //         favOnTap: () {
        //           (haveFav) ? haveFav = false : haveFav = true;
        //           setState(() {});
        //         },
        //         bookMarkOnTap: () {
        //           (haveBookMark) ? haveBookMark = false : haveBookMark = true;
        //           setState(() {});
        //         },
        //         postCommentOnTap: () {
        //           // Bottom Sheet
        //           //------------------------------------
        //           //------------------------------------
        //           //------------------------------------
        //
        //           Get.bottomSheet(CommentPageCard(),
        //               isScrollControlled: true, elevation: 0);
        //
        //           //------------------------------------
        //           //------------------------------------
        //           //------------------------------------
        //         },
        //       ),
        //     );
        //   },
        // )
      ],
    ));
  }

  Widget _buildPostUploadingContainer() {
    PostController postController = Get.find();
    return Obx(
      () => postController.postUploading.value == true
          ? Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                color: kSecondaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    MyText(
                      text: 'Uploading post!!',
                      size: 16,
                      color: kPrimaryColor,
                      weight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildStoryUploadingContainer() {
    StoryUploadController storyUploadController = Get.find();
    return Obx(
      () => storyUploadController.isUploadingStories.value == true
          ? Container(
              height: 60,
              width: Get.width,
              decoration: BoxDecoration(
                color: kSecondaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    MyText(
                      text: 'Uploading story!!',
                      size: 16,
                      color: kPrimaryColor,
                      weight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

class BottomSheetButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title, svgIcon;
  final double mTop;

  const BottomSheetButton(
      {super.key, this.onTap, this.title, this.svgIcon, this.mTop = 10});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.only(top: mTop),
        //color: Colors.amber,
        child: Row(
          children: [
            CommonImageView(
              svgPath: svgIcon,
            ),
            MyText(
              paddingLeft: 10,
              paddingRight: 10,
              text: "$title",
              size: 14,
              weight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}

handleClick(String value, Future<dynamic> onDel) {
  switch (value) {
    case 'Delete':
      onDel;
      break;
  }
}

Widget StroyOptions({required onDel}) {
  return PopupMenuButton<String>(
    onSelected: handleClick('Delete', onDel),
    itemBuilder: (BuildContext context) {
      return {'Delete'}.map((String choice) {
        return PopupMenuItem<String>(
          value: choice,
          child: Text(choice),
        );
      }).toList();
    },
  );
}

class _SliverAppBarWidget extends StatelessWidget {
  final Widget? widget;
  final bool isSpaceActive,isStatusShow;

  const _SliverAppBarWidget(
      {super.key, this.widget, this.isSpaceActive = false,this.isStatusShow=true});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      surfaceTintColor: kPrimaryColor,
      backgroundColor: kPrimaryColor,
      leadingWidth: Get.width * 0.29,
      leading: Container(
        //color: Colors.red,
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              height: 37,
              width: 68,
              // color: Colors.amber,
              child: CommonImageView(
                // height: 40,
                // width: 40,
                svgPath: Assets.imagesLogoWithNurIcon,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            NotificationButtonWithDot(),
            SizedBox(width: 20),
            BookMarkButton(
              onTap: (){
                Get.to(()=>BookMarkPage());
              },
            ),
            SizedBox(width: 20),
          ],
        )
      ],
      stretchTriggerOffset: 300.0,
      expandedHeight:
          isStatusShow==true? isSpaceActive == true ? Get.height * 0.30 : Get.height * 0.25:0,
      flexibleSpace: FlexibleSpaceBar(background: widget),
    );
  }
}

class PostCard extends StatefulWidget {
  final VoidCallback? otherProfileTap,
      popMenuTap,
      favOnTap,
      totallCommentOnTap,
      shareOnTap,
      bookMarkOnTap,
      postCommentOnTap,
      commentIconTap,
      replyCommentTap;
  final PostModel postModel;
  final bool haveFav, haveBookMark;
  final int? likesCount;
  final int? commentsCount;
  final String? postIImg, posterName, postedImg;
  final TextEditingController commentController;

  const PostCard({
    super.key,
    this.bookMarkOnTap,
    this.replyCommentTap,
    this.posterName,
    this.commentIconTap,
    this.postedImg,
    required this.postModel,
    required this.commentController,
    this.favOnTap,
    this.commentsCount,
    this.likesCount,
    this.otherProfileTap,
    this.popMenuTap,
    this.postCommentOnTap,
    this.shareOnTap,
    this.totallCommentOnTap,
    this.haveFav = true,
    this.haveBookMark = true,
    this.postIImg,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  VideoPlayerController? videoPlayerController;
  RxBool videoPlayerInit = false.obs;
  bool isVideoPlaying = false; // Track if the video is currently playing
  bool isLoading = false; // Track if the video is loading

  @override
  void initState() {
    // if (widget.postModel.content.postType == 'Video') {
    //   // Initialize video player
    //   videoPlayerController = VideoPlayerController.network(
    //     widget.postModel.content.url,
    //   )..initialize().then((_) {
    //       // Once video is initialized, update state
    //       videoPlayerInit.value = true;
    //       setState(() {});
    //     });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.otherProfileTap,
                child: CommonImageView(
                  url: widget.postedImg,
                  height: 44,
                  width: 44,
                  radius: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      paddingBottom: 4,
                      paddingLeft: 6,
                      text: "${widget.posterName}",
                      size: 12,
                      weight: FontWeight.w600),

                  ///Todo: Add Location Here
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 6,
                  //     ),
                  //     CommonImageView(
                  //       svgPath: Assets.imagesLocationMarkerIcon,
                  //     ),
                  //     MyText(
                  //         paddingLeft: 6,
                  //         text: "${widget.postModel.location}",
                  //         size: 10,
                  //         weight: FontWeight.w400),
                  //   ],
                  // ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: widget.popMenuTap,
                child: Container(
                  // color: Colors.amber,
                  padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: CommonImageView(
                    svgPath: Assets.imagesMoreIcon,
                  ),
                ),
              ),
            ],
          ),
          MyText(
            paddingBottom: 8,
            paddingTop: 14,
            text: '${widget.postModel.caption}',
            size: 13,
            weight: FontWeight.w500,
          ),
          // Other widgets...
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    // Toggle play/pause on video tap
                    if (videoPlayerController != null) {
                      setState(() {
                        if (isVideoPlaying) {
                          videoPlayerController!.pause();
                          isVideoPlaying = false;
                        } else {
                          videoPlayerController!.play();
                          isVideoPlaying = true;
                        }
                      });
                    } else {
                      isLoading = true; // Show loader when video starts loading
                      videoPlayerController = VideoPlayerController.networkUrl(
                          Uri.parse(widget.postModel.content.url))
                        ..addListener(() {
                          setState(() {});
                        })
                        ..setLooping(true)
                        ..play()
                        ..initialize().then((_) {
                          videoPlayerInit.value = true;
                          isLoading = false;
                          isVideoPlaying = true;
                          setState(() {});
                        });
                    }
                  },
                  child: Stack(
                    children: [
                      widget.postModel.content.postType == 'Text'?Container():
                      Container(
                        height: Get.height * 0.27,
                        width: Get.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: videoPlayerInit.value == true
                            ? VideoPlayer(videoPlayerController!)
                            : CommonImageView(
                                height: 238,
                                width: 350,
                                radius: 15,
                                fit: BoxFit.fill,
                                url:
                                    widget.postModel.content.postType == 'Video'
                                        ? widget.postModel.content.thumbnail
                                        : widget.postModel.content.url,
                              ),
                      ),
                    ],
                  ),
                ),

                // Play/Pause button
                widget.postModel.content.postType == 'Video'
                    ? isLoading == true
                        ? Positioned.fill(
                            child: Align(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            ),
                          ))
                        : Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: AnimatedOpacity(
                                opacity: isVideoPlaying ? 0.0 : 1.0,
                                duration: Duration(seconds: 1),
                                child: IconButton(
                                  onPressed: () {
                                    // Play video when button is tapped
                                    if (videoPlayerController != null) {
                                      setState(() {
                                        videoPlayerController!.play();
                                        isVideoPlaying = true;
                                      });
                                    } else {
                                      isLoading =
                                          true; // Show loader when video starts loading
                                      videoPlayerController =
                                          VideoPlayerController.networkUrl(
                                              Uri.parse(
                                                  widget.postModel.content.url))
                                            ..addListener(() {
                                              setState(() {});
                                            })
                                            ..setLooping(true)
                                            ..play()
                                            ..initialize().then((_) {
                                              videoPlayerInit.value = true;
                                              isVideoPlaying = true;

                                              isLoading =
                                                  false; // Hide loader when video is loaded
                                              setState(() {});
                                            });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.play_circle_outline,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                    : SizedBox.shrink()
              ],
            ),
          ),
          // CommonImageView(
          //   url: widget.postIImg,
          //   radius: 10,
          //   height: 238,
          //   width: double.maxFinite,
          //   fit: BoxFit.cover,
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              _PostBottomBtn(
                onTap: widget.favOnTap,
                svgIcon: (widget.haveFav == true)
                    ? Assets.imagesFavFillIcon
                    : Assets.imagesFavOutlineIcon,
                title: "${widget.likesCount}",
              ),
              _PostBottomBtn(
                onTap: widget.commentIconTap,
                svgIcon: Assets.imagesTotalCommentsIcon,
                title: "${widget.commentsCount}",
              ),
              _PostBottomBtn(
                onTap: widget.shareOnTap,
                svgIcon: Assets.imagesSharePostIcon,
                title: "",
              ),
              Spacer(),
              _PostBottomBtn(
                onTap: widget.bookMarkOnTap,
                svgIcon: (widget.haveBookMark == true)
                    ? Assets.imagesPostBookmarkFillIcon
                    : Assets.imagesPostBookmarkOutlineIcon,
                haveTitle: false,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
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
                      itemCount: dataList!.length > 2 ? 2 : dataList.length,
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
                                      return CommentsCard(
                                        userComment: commentModel.comment,
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
                                              .value = commentModel.comment;
                                          Get.find<PostController>()
                                              .replyingToCommentId
                                              .value = commentModel.commentId;
                                        },
                                        haveBar: hasReply,
                                        viewAllOnTap: () {
                                          Get.bottomSheet(
                                              CommentPageCard(
                                                postModel: widget.postModel,
                                              ),
                                              isScrollControlled: true,
                                              elevation: 0);
                                        },
                                        profileImg: userData.profilePicture,
                                        haveNestComment: true,
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
          Obx(
            () => SizedBox(
              height: Get.find<PostController>().inReplyState.value == true
                  ? 0
                  : 30,
            ),
          ),
          Obx(() => Get.find<PostController>().inReplyState.value == true
              ? replyCommentField(
                  commentController: widget.commentController,
                  commentPostTap: widget.replyCommentTap,
                  comment: Get.find<PostController>().replyToComment.value,
                  commentId:
                      Get.find<PostController>().replyingToCommentId.value)
              : commentField(
                  commentController: widget.commentController,
                  commentPostTap: widget.postCommentOnTap))
        ],
      ),
    );
  }
}

Widget commentField({required commentController, required commentPostTap}) {
  return Row(
    children: [
      CommonImageView(
        url: userModelGlobal.value.profilePicture,
        radius: 100,
        width: 36,
        height: 36,
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: CustomTextField(
          radius: 5,
          controller: commentController,
          isUseLebelText: false,
          height: 40,
          hintText: 'Write your comment',
          focusedBorderColor: kTransperentColor,
          filled: true,
          backgroundColor: kGreyColor2,
          outlineBorderColor: kTransperentColor,
        ),
      ),
      MyText(
        onTap: commentPostTap,
        paddingLeft: 34,
        text: "Post",
        size: 12,
        weight: FontWeight.w600,
        color: kPostColor,
      )
    ],
  );
}

Widget replyCommentField(
    {required commentController,
    required commentPostTap,
    required String comment,
    required commentId}) {
  PostController postController = Get.find();
  return Column(
    children: [
      Container(
          height: 30,
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                text: 'Replying to: ${comment}',
                size: 14,
                color: kPrimaryColor,
                weight: FontWeight.w500,
              ),
              InkWell(
                  onTap: () {
                    postController.inReplyState.value = false;
                  },
                  child: Icon(
                    Icons.cancel,
                    color: kPrimaryColor,
                    size: 20,
                  ))
            ],
          )),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          CommonImageView(
            url: userModelGlobal.value.profilePicture,
            radius: 100,
            width: 36,
            height: 36,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: CustomTextField(
              radius: 5,
              controller: commentController,
              isUseLebelText: false,
              height: 40,
              hintText: 'Write your reply here',
              focusedBorderColor: kTransperentColor,
              filled: true,
              backgroundColor: kGreyColor2,
              outlineBorderColor: kTransperentColor,
            ),
          ),
          MyText(
            onTap: commentPostTap,
            paddingLeft: 34,
            text: "Post",
            size: 12,
            weight: FontWeight.w600,
            color: kPostColor,
          )
        ],
      ),
    ],
  );
}

class _PostBottomBtn extends StatelessWidget {
  final String? svgIcon, title;
  final VoidCallback? onTap;
  final bool haveTitle;

  const _PostBottomBtn({
    super.key,
    this.svgIcon,
    this.title,
    this.onTap,
    this.haveTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CommonImageView(
            svgPath: svgIcon,
          ),
          haveTitle
              ? MyText(
                  paddingLeft: 6,
                  paddingRight: 21,
                  text: "$title",
                  size: 12,
                  weight: FontWeight.w400,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class _UploadStatusBtn extends StatelessWidget {
  final VoidCallback? onTap;

  const _UploadStatusBtn({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: CommonImageView(
                url: userModelGlobal.value.profilePicture,
                height: 62,
                width: 62,
                radius: 100,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CommonImageView(
                svgPath: Assets.imagesAddProfileImg,
                // height: 62,
                // width: 62,
              ),
            )
          ],
        ),
        MyText(paddingTop: 11, text: "You", size: 13, weight: FontWeight.w400),
      ],
    );
  }
}

class _WatchStatusBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final String? img, title;

  const _WatchStatusBtn({super.key, this.onTap, this.img, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 11),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CommonImageView(
              imagePath: img,
              height: 62,
              width: 62,
            ),
          ),
          MyText(
              paddingTop: 11,
              text: "$title",
              size: 13,
              weight: FontWeight.w400),
        ],
      ),
    );
  }
}
