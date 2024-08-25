import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/home_controllers/search_controller.dart';
import 'package:soical_media_app/controllers/post_controllers/post_controller.dart';
import 'package:soical_media_app/controllers/profile_controller/profiel_controller.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/services/chatting_service.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/local_notification_service.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/screens/profile/edit_profile.dart';
import 'package:soical_media_app/view/screens/settings/help_and_support.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../../models/post_model/post_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../../services/zego_service/zego_service.dart';
import '../../widget/post_widget.dart';
import '../home/comments.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String userId;

  ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  ProfileController profileController = Get.find();
  RxBool isFollowing = false.obs;
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

  @override
  void initState() {
    log("********************** profile Init State ******************************************* ${userModelGlobal.value.uid}");
    log('Other ID : ${widget.userId}');
    super.initState();

    Future.delayed(Duration.zero).then((_) async {
      if (widget.userId == userModelGlobal.value.uid || widget.userId.isEmpty) {
        log('Own Profile');
        userModel.value = userModelGlobal.value;
      } else {
        log('Other Profile');

        getUserOfTheProfile(uid: widget.userId);
        profileController.checkIfRequested(
            userModelGlobal.value.uid, widget.userId);
      }
      _tabController = TabController(length: 2, vsync: this);
    });
  }

  getUserOfTheProfile({required String uid}) async {
    if (userModelGlobal.value.uid != uid) {
      isFollowing.value =
          await FirebaseCRUDServices.instance.isUserFollowed(otherUserId: uid);
      usersCollection.doc(uid).snapshots().listen((event) {
        print("getUserOfTheProfile---------------");
        print(event.data());
        userModel.value = UserModel.fromJson(event);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchController = Get.find<SearchScreenController>();
    log("-------------- =>${searchController.followUserModels}");
    return Scaffold(
      body: Obx(() => userModel.value.uid == ''
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                // App Bar
                //-------------------------
                Obx(
                  () => StreamBuilder(
                      stream: postsCollection
                          .where('uid', isEqualTo: userModel.value.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var postsCount = 0;
                        if (snapshot.hasData) {
                          postsCount = snapshot.data!.size;
                        }
                        return Obx(
                          () => profileController.profilePath.value == ''
                              ? _ProfilePageAppBar(
                                  isMe: widget.userId ==
                                          userModelGlobal.value.uid ||
                                      widget.userId.isEmpty,
                                  backgroundImg: userModel.value.coverPhoto,
                                  profileImg: userModel.value.profilePicture,
                                  onBackTap: () {
                                    Get.back();
                                  },
                                  showCameraIcon: userModel.value.uid ==
                                      userModelGlobal.value.uid,
                                  onLogoutTap: () async {
                                    SharedPreferenceService.instance
                                        .removeSharedPreferenceBool(
                                            SharedPrefKeys.loggedIn);
                                    await FirebaseAuth.instance.signOut().then(
                                        (value) => ZegoService.onUserLogout());
                                    Get.offAll(() => Login(),
                                        binding: AuthBindings());
                                  },
                                  onCameraTap: () {
                                    profileController
                                        .buildOpenImagePickerBottomSheet(
                                            context: context,
                                            cameraTap: () async {
                                              await profileController
                                                  .pickImageFromCamera();
                                            },
                                            galleryTap: () async {
                                              await profileController
                                                  .pickImageFromGallery();
                                            });
                                  },
                                  readyToUpload: false,
                                  onHomeTap: () {},
                                  posts: '${postsCount}',
                                  followers: '${userModel.value.followerCount}',
                                  following:
                                      '${userModel.value.followingCount}',
                                  isFileImage: false,
                                )
                              : _ProfilePageAppBar(
                                  isMe: widget.userId ==
                                          userModelGlobal.value.uid ||
                                      widget.userId.isEmpty,
                                  backgroundImg:
                                      profileController.profilePath.value,
                                  profileImg: userModel.value.profilePicture,
                                  onBackTap: () {
                                    Get.back();
                                  },
                                  onLogoutTap: () async {
                                    SharedPreferenceService.instance
                                        .removeSharedPreferenceBool(
                                            SharedPrefKeys.loggedIn);
                                    await FirebaseAuth.instance.signOut();
                                    Get.offAll(() => Login(),
                                        binding: AuthBindings());
                                  },
                                  onCameraTap: () {
                                    profileController
                                        .buildOpenImagePickerBottomSheet(
                                            context: context,
                                            cameraTap: () async {
                                              await profileController
                                                  .pickImageFromCamera();
                                            },
                                            galleryTap: () async {
                                              await profileController
                                                  .pickImageFromGallery();
                                            });
                                  },
                                  onHomeTap: () {},
                                  readyToUpload: true,
                                  onCheckTap: () async {
                                    await profileController.updateCoverPicture(
                                        context: context);
                                  },
                                  posts: '${postsCount}',
                                  followers: '${userModel.value.followerCount}',
                                  following:
                                      '${userModel.value.followingCount}',
                                  isFileImage: true,
                                ),
                        );
                      }),
                ),

                StreamBuilder(
                    stream: postsCollection
                        .where('uid', isEqualTo: userModel.value.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var postsCount = 0;
                      if (snapshot.hasData) {
                        postsCount = snapshot.data!.size;
                      }
                      return Padding(
                        padding: AppSizes.HORIZONTAL,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => _UserProfileInfo(
                                title: "${userModel.value.name}",
                                subTitle: "@${userModel.value.username}",
                                haveUserVerified:
                                    userModel.value.isOfficialVerified,
                              ),
                            ),
                            MyText(
                              paddingTop: 17,
                              text: "${userModel.value.bio}",
                              size: 13,
                              weight: FontWeight.w400,
                            ),
                            SizedBox(height: 10),
                            _MoreInfoButton(
                              onTap: () {},
                            ),
                            SizedBox(height: 20),
                            Obx(
                              () => profileController.isLoading.value
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: kSecondaryColor,
                                      ),
                                    )
                                  : widget.userId ==
                                              userModelGlobal.value.uid ||
                                          widget.userId.isEmpty
                                      ? Container()
                                      : isFollowing.value
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Obx(
                                                  () => Container(
                                                    width: Get.width * 0.43,
                                                    child: MyButton(
                                                        backgroundColor:
                                                            isFollowing.value
                                                                ? Colors.green
                                                                : kSecondaryColor,
                                                        onTap: () async {
                                                          searchController
                                                              .updateList
                                                              .value = false;

                                                          isFollowing.value =
                                                              !isFollowing
                                                                  .value;
                                                          FirebaseCRUDServices
                                                              .instance
                                                              .connectToFriend(
                                                                  otherUserId:
                                                                      widget
                                                                          .userId);
                                                          if (isFollowing
                                                                  .value ==
                                                              true) {
                                                            print(
                                                                "Other User Device Token: ${userModel.value.deviceTokenID}");
                                                            await LocalNotificationService.instance.sendFCMNotification(
                                                                deviceToken:
                                                                    userModel
                                                                        .value
                                                                        .deviceTokenID,
                                                                title:
                                                                    "New Notification",
                                                                body:
                                                                    "${userModelGlobal.value.name} start following you",
                                                                type: AppStrings
                                                                    .notificationGeneral,
                                                                sentBy:
                                                                    userModelGlobal
                                                                        .value
                                                                        .uid,
                                                                sentTo:
                                                                    userModel
                                                                        .value
                                                                        .uid,
                                                                savedToFirestore:
                                                                    true);
                                                          }
                                                        },
                                                        buttonText:
                                                            isFollowing.value
                                                                ? "Following"
                                                                : "Follow"),
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width * 0.43,
                                                  child: MyButton(
                                                      onTap: () async {
                                                        await ChattingService
                                                            .instance
                                                            .createChatThread(
                                                                userModel:
                                                                    userModel
                                                                        .value);
                                                      },
                                                      buttonText: "Message"),
                                                ),
                                              ],
                                            )
                                          : userModel.value.isPrivate
                                              ? profileController
                                                      .isRequested.value
                                                  ? Container(
                                                      width: Get.width,
                                                      child: MyButton(
                                                          backgroundColor:
                                                              kSecondaryColor,
                                                          onTap: () {},
                                                          buttonText:
                                                              'Requested'),
                                                    )
                                                  : Container(
                                                      width: Get.width,
                                                      child: MyButton(
                                                          backgroundColor:
                                                              kSecondaryColor,
                                                          onTap: () async {
                                                            await profileController
                                                                .sendFollowRequest(
                                                              userModelGlobal
                                                                  .value.uid,
                                                              userModel
                                                                  .value.uid,
                                                            );
                                                            await profileController
                                                                .checkIfRequested(
                                                                    userModelGlobal
                                                                        .value
                                                                        .uid,
                                                                    widget
                                                                        .userId);
                                                          },
                                                          buttonText:
                                                              'Send Request'),
                                                    )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Obx(
                                                      () => Container(
                                                        width: Get.width * 0.43,
                                                        child: MyButton(
                                                            backgroundColor:
                                                                isFollowing
                                                                        .value
                                                                    ? Colors
                                                                        .green
                                                                    : kSecondaryColor,
                                                            onTap: () async {
                                                              searchController
                                                                  .updateList
                                                                  .value = false;

                                                              isFollowing
                                                                      .value =
                                                                  !isFollowing
                                                                      .value;
                                                              FirebaseCRUDServices
                                                                  .instance
                                                                  .connectToFriend(
                                                                      otherUserId:
                                                                          widget
                                                                              .userId);
                                                              if (isFollowing
                                                                      .value ==
                                                                  true) {
                                                                print(
                                                                    "Other User Device Token: ${userModel.value.deviceTokenID}");
                                                                await LocalNotificationService.instance.sendFCMNotification(
                                                                    deviceToken:
                                                                        userModel
                                                                            .value
                                                                            .deviceTokenID,
                                                                    title:
                                                                        "New Notification",
                                                                    body:
                                                                        "${userModelGlobal.value.name} start following you",
                                                                    type: AppStrings
                                                                        .notificationGeneral,
                                                                    sentBy:
                                                                        userModelGlobal
                                                                            .value
                                                                            .uid,
                                                                    sentTo:
                                                                        userModel
                                                                            .value
                                                                            .uid,
                                                                    savedToFirestore:
                                                                        true);
                                                              }
                                                            },
                                                            buttonText:
                                                                isFollowing
                                                                        .value
                                                                    ? "Following"
                                                                    : "Follow"),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Get.width * 0.43,
                                                      child: MyButton(
                                                          onTap: () async {
                                                            await ChattingService
                                                                .instance
                                                                .createChatThread(
                                                                    userModel:
                                                                        userModel
                                                                            .value);
                                                          },
                                                          buttonText:
                                                              "Message"),
                                                    ),
                                                  ],
                                                ),
                            ),
                            profileController.isLoading.value
                                ? const SizedBox()
                                : widget.userId != userModelGlobal.value.uid &&
                                        widget.userId.isNotEmpty &&
                                        userModel.value.isPrivate && !isFollowing.value
                                    ? Center(
                                        child: MyText(
                                          text: 'Private Account',
                                          paddingTop: 100,
                                        ),
                                      )
                                    : TabBar.secondary(
                                        controller: _tabController,
                                        labelColor: kSecondaryColor,
                                        dividerColor:
                                            kGreyColor1.withOpacity(0.5),
                                        tabs: [
                                            Tab(text: '${postsCount} POSTS'),
                                            Tab(text: '${postsCount} MEDIA'),
                                          ]),
                            profileController.isLoading.value
                                ? const SizedBox()
                                : widget.userId != userModelGlobal.value.uid &&
                                        userModel.value.isPrivate && !isFollowing.value
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: Get.height * 0.7,
                                        child: TabBarView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          controller: _tabController,
                                          children: [
                                            _TabBarContent(
                                              userId: widget.userId,
                                            ),
                                            _TabBarContent2(
                                              userId: widget.userId,
                                            ),
                                          ],
                                        ),
                                      )
                          ],
                        ),
                      );
                    })
              ],
            )),
    );
  }
}

class _TabBarContent extends StatefulWidget {
  String userId;

  _TabBarContent({
    super.key,
    required this.userId,
  });

  @override
  State<_TabBarContent> createState() => _TabBarContentState();
}

class _TabBarContentState extends State<_TabBarContent> {
  bool haveBookMark = true;

  PostController postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.2,
      child: PaginateFirestore(
        itemsPerPage: 10,
        onEmpty: Center(
          child: MyText(
            text: userModelGlobal.value.isPrivate.toString(),
            size: 18,
            color: kSecondaryColor,
            weight: FontWeight.w600,
          ),
        ),
        allowImplicitScrolling: true,
        shrinkWrap: true,
        query: postsCollection
            .where('uid', isEqualTo: widget.userId)
            .orderBy('postDate', descending: true),
        itemBuilder: (context, documentSnapshots, index) {
          PostModel posts = PostModel.fromMap(
              documentSnapshots[index].data() as Map<String, dynamic>);
          return StreamBuilder(
              stream: usersCollection.doc(posts.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                UserModel udata = UserModel.fromJson(snapshot.data!);
                var profilePic = udata.profilePicture;

                var userName = udata.name;
                bool liked = false;
                bool bookmarked =
                    userModelGlobal.value.bookmarked!.contains(posts.postID);
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

                if (posts.likesList.contains(userModelGlobal!.value.uid!)) {
                  liked = true;
                }

                return PostCard(
                  postedImg: profilePic,
                  posterName: userName,
                  commentsCount: posts.comments,
                  likesCount: likes,
                  shareOnTap: () {},
                  totallCommentOnTap: () {},
                  popMenuTap: () {},
                  otherProfileTap: () {
                    // Get.to(UserProfilePage());
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
                        isAddBookmark: !bookmarked, postId: posts.postID);
                    (haveBookMark) ? haveBookMark = false : haveBookMark = true;
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
                        commentId: postController.replyingToCommentId.value,
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
                  commentController: postController.commentController,
                );
              });
        },
        initialLoader: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) => Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black12,
            ),
          ),
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilderType: PaginateBuilderType.pageView,
        isLive: true,
        includeMetadataChanges: true,
      ),
    );
  }
}

class _TabBarContent2 extends StatelessWidget {
  String userId;

  _TabBarContent2({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Get.height * 0.2,
        child: StreamBuilder(
            stream: postsCollection
                .where('uid', isEqualTo: userId)
                .orderBy('postDate', descending: true)
                .snapshots(),
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
                return MasonryGridView.builder(
                  padding: EdgeInsets.only(top: 15),
                  physics: BouncingScrollPhysics(),
                  itemCount: dataList!.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 5,
                  itemBuilder: (context, index) {
                    PostModel posts = PostModel.fromMap(dataList[index].data());
                    return posts.content.postType == 'Image'
                        ? CommonImageView(
                            url: posts.content.url,
                            height: 100,
                            width: 150,
                          )
                        : Stack(
                            children: [
                              CommonImageView(
                                url: posts.content.thumbnail,
                                height: 100,
                                width: 150,
                              ),
                              Positioned(
                                top: 35,
                                left: 50,
                                child: Icon(
                                  Icons.play_circle_outlined,
                                  color: kPrimaryColor,
                                  size: 24,
                                ),
                              )
                            ],
                          );
                  },
                );
              }
            }));
  }
}

class _FollowAndMessageBtn extends StatelessWidget {
  final bool haveFollowAndMessageBtn;
  final VoidCallback onFollowTap, onMessageTap;

  const _FollowAndMessageBtn(
      {super.key,
      this.haveFollowAndMessageBtn = true,
      required this.onFollowTap,
      required this.onMessageTap});

  @override
  Widget build(BuildContext context) {
    return (haveFollowAndMessageBtn == true)
        ? Row(
            children: [
              Expanded(
                child: MyButton(
                  radius: 7,
                  onTap: onFollowTap,
                  buttonText: 'Follow',
                  height: 40,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: MyButton(
                  radius: 7,
                  onTap: onMessageTap,
                  buttonText: 'Message',
                  height: 40,
                ),
              ),
            ],
          )
        : SizedBox();
  }
}

class _MoreInfoButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _MoreInfoButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          MyText(
            paddingRight: 15,
            text: 'More info',
            size: 13,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          CommonImageView(
            svgPath: Assets.imagesEditIconSvg,
          )
        ],
      ),
    );
  }
}

class _UserProfileInfo extends StatelessWidget {
  final String? title, subTitle;
  final bool haveUserVerified, haveUserOnline;

  const _UserProfileInfo({
    super.key,
    this.haveUserOnline = true,
    this.haveUserVerified = false,
    this.subTitle,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            MyText(
              paddingRight: 10,
              text: "$title",
              size: 16,
              weight: FontWeight.w500,
            ),
            (haveUserVerified == true)
                ? CommonImageView(
                    svgPath: Assets.imagesUserVerifiedBlueIcon,
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            MyText(
              paddingRight: 10,
              text: "$subTitle",
              size: 14,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
            ),
            Icon(
              Icons.circle,
              color: (haveUserOnline == true) ? kGreenColor : kGreyColor1,
              size: 10,
            )
          ],
        ),
      ],
    );
  }
}

// Home App Bar Widgets
//--------------------------------

class _ProfilePageAppBar extends StatelessWidget {
  final String? backgroundImg, profileImg, posts, followers, following;
  final VoidCallback? onCameraTap,
      onVerticalPopupTap,
      onBackTap,
      onHomeTap,
      onCheckTap;
  final VoidCallback? onLogoutTap;
  final bool isFileImage;
  final bool? readyToUpload;
  final bool? showCameraIcon, isMe;

  const _ProfilePageAppBar({
    super.key,
    this.backgroundImg,
    this.profileImg,
    this.posts,
    this.followers,
    this.showCameraIcon,
    this.following,
    this.onCheckTap,
    this.onBackTap,
    this.readyToUpload,
    this.onCameraTap,
    required this.isFileImage,
    this.onHomeTap,
    this.onVerticalPopupTap,
    this.onLogoutTap,
    this.isMe = true,
  });

  @override
  Widget build(BuildContext context) {
    log(backgroundImg!);
    log(isFileImage.toString()!);
    return Container(
      height: 240,
      // color: Colors.amber,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 189,
                decoration: BoxDecoration(
                    image: isFileImage == true
                        ? DecorationImage(
                            image: FileImage(File('${backgroundImg}')),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage("$backgroundImg"),
                            fit: BoxFit.cover)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 52,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Popoup menu button
                        //-----------------------------
                        isMe == true
                            ? PopupMenuButton<String>(
                                iconColor: kWhiteColor,
                                color: kWhiteColor,
                                shadowColor: kWhiteColor,
                                elevation: 0,
                                onSelected: (value) {
                                  // Handle menu item selection
                                  print('Selected: $value');
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      onTap: () {
                                        Get.to(() => EditProfilePage(),
                                            binding: EditProfileBinding());
                                      },
                                      value: 'option1',
                                      child: Text('Edit Profile'),
                                    ),
                                    PopupMenuItem<String>(
                                      onTap: () {
                                        Get.to(() => SettingScreen());
                                      },
                                      value: 'option2',
                                      child: Text('Settings'),
                                    ),
                                    PopupMenuItem<String>(
                                      onTap: () {
                                        Get.to(HelpAndSupport());
                                      },
                                      value: 'option3',
                                      child: Text('Help'),
                                    ),
                                    PopupMenuItem<String>(
                                      onTap: onLogoutTap,
                                      value: 'option3',
                                      child: Text('Logout'),
                                    )
                                  ];
                                })
                            : Container(),

                        SizedBox(width: 10),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        showCameraIcon == true
                            ? _RoundButtons(
                                onTap: onCameraTap,
                                svgIcon: Assets.imagesCameraWhiteIcon,
                              )
                            : SizedBox.shrink(),
                        readyToUpload == true
                            ? SizedBox.shrink()
                            : SizedBox(width: 15),
                        readyToUpload == true
                            ? IconButton(
                                onPressed: onCheckTap,
                                icon: Icon(
                                  Icons.check,
                                  color: kGreenColor,
                                  size: 26,
                                ))
                            : SizedBox.shrink()
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child: CachedNetworkImage(
              imageUrl: profileImg ?? dummyProfile,
              height: 96,
              width: 96,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: kWhiteColor),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: kWhiteColor),
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                _DisplayInfo(
                  title: "$posts",
                  subTitle: "Posts",
                ),
                SizedBox(width: 18),
                _DisplayInfo(
                  title: "$followers",
                  subTitle: "Followers",
                ),
                SizedBox(width: 18),
                _DisplayInfo(
                  title: "$following",
                  subTitle: "Following",
                ),
                SizedBox(width: 18),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DisplayInfo extends StatelessWidget {
  final String? title, subTitle;

  const _DisplayInfo({super.key, this.subTitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(
          text: "$title",
          size: 15.36,
          weight: FontWeight.w500,
        ),
        MyText(
          paddingTop: 5.56,
          text: "$subTitle",
          size: 11.52,
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}

class _RoundButtons extends StatelessWidget {
  final String? svgIcon;
  final VoidCallback? onTap;

  const _RoundButtons({
    super.key,
    this.onTap,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.amber,
        width: 40,
        height: 30,
        child: Center(
          child: CommonImageView(
            svgPath: svgIcon,
          ),
        ),
      ),
    );
  }
}
