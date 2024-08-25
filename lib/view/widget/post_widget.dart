import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../models/post_model/post_model.dart';
import 'common_image_view_widget.dart';
import 'my_text_widget.dart';

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
                  Row(
                    children: [
                      SizedBox(
                        width: 6,
                      ),
                      CommonImageView(
                        svgPath: Assets.imagesLocationMarkerIcon,
                      ),
                      MyText(
                          paddingLeft: 6,
                          text: "${widget.postModel.location}",
                          size: 10,
                          weight: FontWeight.w400),
                    ],
                  ),
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
                    : SizedBox.shrink(),
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
        ],
      ),
    );
  }
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
