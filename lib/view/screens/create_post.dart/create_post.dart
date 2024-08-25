import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/controllers/post_controllers/post_controller.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/view/screens/bottom_nav_bar/b_nav_bar.dart';
import 'package:soical_media_app/view/widget/appbar_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/custom_simple_textField.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../models/post_model/content_model.dart';

class CreatePost extends StatelessWidget {
  CreatePost({
    super.key,
  });
  PostController postController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appbar_widget(haveTitle: true, haveBackIcon: false, title: "Create"),
      body: GetBuilder<PostController>(
          init: PostController(),
          builder: (ctrlr) {
            return Padding(
              padding: AppSizes.DEFAULT,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Create Post",
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                          width: 70,
                          child: MyButton(
                            onTap: () async {
                              if (ctrlr.captionController.text == '') {
                                CustomSnackBars.instance.showFailureSnackbar(
                                    title: 'Error',
                                    message: 'Please Enter Captaion');
                              } else {
                                Get.off(() => BNavBar(
                                  index: 0,
                                ));
                                print("post Type = ${ctrlr.content.value.postType} ${ctrlr.content.value.postType !="Image"}");
                                if(ctrlr.content.value.postType =="Video"|| ctrlr.content.value.postType =="Image"){
                                  PostModel postModel = PostModel(
                                      postID: '',
                                      uid: userModelGlobal.value.uid,
                                      caption: ctrlr.captionController.text,
                                      content: ctrlr.content.value,
                                      tags: [],
                                      likes: 0,
                                      comments: 0,
                                      postDate: DateTime.now(),
                                      active: true,
                                      location: '',
                                      likesList: []);
                                  PostModel newPostModel = await ctrlr
                                      .uploadImagesOrVideos(postModel: postModel);
                                  ctrlr.uploadPostToCollection(
                                      postModel: newPostModel);

                                }
                                else{
                                  ctrlr.content.value.postType = "Text";
                                  PostModel postModel = PostModel(
                                      postID: '',
                                      uid: userModelGlobal.value.uid,
                                      caption: ctrlr.captionController.text,
                                      content: ctrlr.content.value,
                                      tags: [],
                                      likes: 0,
                                      comments: 0,
                                      postDate: DateTime.now(),
                                      active: true,
                                      location: '',
                                      likesList: []);
                                  PostModel newPostModel = await ctrlr
                                      .uploadImagesOrVideos(postModel: postModel);
                                  ctrlr.uploadPostToCollection(
                                      postModel: newPostModel);
                                  Get.to(() => BNavBar(
                                        index: 0,
                                      ));

                                }
                                print("post Type After = ${ctrlr.content.value.postType}");

                              }
                            },
                            height: 32,
                            buttonText: 'Post',
                            fontSize: 12,
                          )),
                    ],
                  ),
                  SizedBox(height: 22),
                  Row(
                    children: [
                      Obx(
                        () => CommonImageView(
                          height: 43,
                          width: 43,
                          radius: 100,
                          fit: BoxFit.fill,
                          url: userModelGlobal.value.profilePicture,
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => MyText(
                            paddingLeft: 10,
                            text: "${userModelGlobal.value.name}",
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(left: 15, right: 5),
                      //   height: 27,
                      //   decoration: AppStyling().fillColorAndRadius(
                      //       color: kSecondaryColor.withOpacity(0.2)),
                      //   child: Row(
                      //     children: [
                      //       MyText(
                      //         paddingRight: 8,
                      //         text: "Public",
                      //         size: 12,
                      //         weight: FontWeight.w500,
                      //         color: kSecondaryColor,
                      //       ),
                      //       Icon(
                      //         Icons.keyboard_arrow_down_outlined,
                      //         size: 15,
                      //         color: kSecondaryColor,
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 13),
                  CustomSimpleTextField(
                    maxLines: 4,
                    contentPaddingLeft: 0,
                    controller: ctrlr.captionController,
                    hintText: "What's on your mind?",
                    hintTextFontSize: 20,
                    hintFontWeight: FontWeight.w500,
                    hintTextFontColor: kGreyColor1.withOpacity(0.5),
                    outlineBorderColor: kTransperentColor,
                    focusedBorderColor: kTransperentColor,
                    fontSize: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ctrlr.content.value.postType == ''
                      ? SizedBox.shrink()
                      : Center(
                          child: Stack(
                            children: [
                              ctrlr.videoControllerInitialized.value == false
                                  ? CommonImageView(
                                      height: 300,
                                      width: 350,
                                      radius: 15,
                                      fit: BoxFit.fill,
                                      file: File(ctrlr.content.value.postType ==
                                              'Video'
                                          ? ctrlr.content.value.thumbnail
                                          : ctrlr.content.value.url),
                                    )
                                  : Container(
                                      height: 300,
                                      width: 350,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                          child: VideoPlayer(
                                        ctrlr.controller,
                                      ))),
                              ctrlr.content.value.postType == 'Video'
                                  ? Positioned(
                                      top: 120,
                                      right: 140,
                                      child: IconButton(
                                        onPressed: () {
                                          if (ctrlr.videoControllerInitialized
                                              .isFalse) {
                                            ctrlr.controller =
                                                VideoPlayerController.file(File(
                                                    ctrlr.content.value.url))
                                                  ..addListener(() {
                                                    ctrlr.update();
                                                  })
                                                  ..setLooping(true)
                                                  ..play()
                                                  ..initialize().then((_) {
                                                    ctrlr
                                                        .videoControllerInitialized
                                                        .value = true;
                                                    ctrlr.update();
                                                  });
                                          }
                                          if (ctrlr
                                              .controller.value.isPlaying) {
                                            ctrlr.controller.pause();
                                          } else if (!ctrlr
                                              .controller.value.isPlaying) {
                                            ctrlr.controller.play();
                                          } else {
                                            ctrlr.videoControllerInitialized
                                                .value = false;
                                            ctrlr.controller.pause();
                                            ctrlr.controller.dispose();
                                          }
                                          ctrlr.update();
                                        },
                                        icon: Icon(
                                          ctrlr.videoControllerInitialized.value ==
                                                      true &&
                                                  ctrlr.controller.value
                                                      .isPlaying
                                              ? Icons
                                                  .pause_circle_outline_outlined
                                              : Icons.play_circle_outlined,
                                          size: 50,
                                          color: kWhiteColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    if (ctrlr
                                        .videoControllerInitialized.isTrue) {
                                      ctrlr.controller.pause();
                                      ctrlr.controller.dispose();
                                      ctrlr.videoControllerInitialized.value =
                                          false;
                                    }
                                    ctrlr.content = Rx(ContentModel(
                                        postType: '', thumbnail: '', url: ''));
                                    ctrlr.update();
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: kPrimaryColor,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            );
          }),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: AppStyling().topShadowDecoration(),
        child: Row(
          children: [
            // Gallery Button
            //---------------------
            _SystemButtons(
              onTap: () {
                postController.pickImageFromGallery();
              },
              svgIcon: Assets.imagesGalleryOrangeIcon,
            ),
            SizedBox(width: 20),

            // Camera Button
            //---------------------
            _SystemButtons(
              onTap: () {
                postController.pickImageFromCamera();
              },
              svgIcon: Assets.imagesCameraBlueIcon,
            ),
            SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  postController.buildOpenVideoPickerBottomSheet(
                      context: context,
                      cameraTap: () {
                        Navigator.pop(context);
                        postController.pickVideoFromCamera();
                      },
                      galleryTap: () {
                        Navigator.pop(context);
                        postController.pickVideo();
                      });
                },
                icon: Icon(
                  Icons.video_collection_outlined,
                  color: kSecondaryColor,
                  size: 20,
                )),
            Spacer(),

            // Location Button
            //---------------------
            // _SystemButtons(
            //   onTap: (){
            //
            //   },
            //   svgIcon: Assets.imagesLoacationIcon,
            // ),
          ],
        ),
      ),
    );
  }
}

class _SystemButtons extends StatelessWidget {
  final VoidCallback? onTap;
  final String? svgIcon;
  const _SystemButtons({
    super.key,
    this.onTap,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 35,
        child: Center(
          child: CommonImageView(
            svgPath: svgIcon,
          ),
        ),
      ),
    );
  }
}
