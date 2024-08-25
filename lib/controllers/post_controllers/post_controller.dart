import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_storage_service.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/post_model/content_model.dart';
import '../../services/zego_service/zego_service.dart';
import '../../view/screens/bottom_nav_bar/b_nav_bar.dart';
import '../../view/widget/image_picker_bottom_sheet.dart';

class PostController extends GetxController {

  RxBool downloading = false.obs;

  RxString downloadingValue = ''.obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ZegoService.onUserLogin();
    print("Posts Controlle oninit Called");
  }


  late VideoPlayerController controller;
  final ImagePicker imagePicker = ImagePicker();
  List tagged = [].obs;
  Rx<ContentModel> content =
      Rx(ContentModel(postType: '', thumbnail: '', url: ''));
  RxBool videoControllerInitialized = false.obs;
  RxBool postUploading = false.obs;
  RxBool inReplyState = false.obs;
  TextEditingController captionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  var replyingToCommentId = ''.obs;
  var replyToComment = ''.obs;


  void buildOpenVideoPickerBottomSheet(
      {required BuildContext context,
      required cameraTap,
      required galleryTap}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) {
        return ImagePickerBottomSheet(
            onCameraPick: cameraTap, onGalleryPick: galleryTap);
      },
    );
  }

  pickVideo() async {
    final XFile? images =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (images!.path.isEmpty) return;
    var thumbnail = await createThumbnail(videoLink: images.path);
    content.value.postType = 'Video';
    content.value.thumbnail = '$thumbnail';
    content.value.url = '${images.path}';
    update();
  }

  pickVideoFromCamera() async {
    final XFile? images =
        await imagePicker.pickVideo(source: ImageSource.camera);
    if (images == null) return;
    var thumbnail = await createThumbnail(videoLink: images.path);
    content.value.postType = 'Video';
    content.value.thumbnail = '$thumbnail';
    content.value.url = '${images.path}';
    update();
  }

  createThumbnail({required videoLink}) async {
    var thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoLink,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 75,
    );
    return thumbnail;
  }

  pickImageFromCamera() async {
    final XFile? images =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (images!.path.isEmpty) return;
    content.value.postType = 'Image';
    content.value.thumbnail = '';
    content.value.url = '${images.path}';
    update();
  }

  pickImageFromGallery() async {
    final XFile? images =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (images == null) return;
    content.value.postType = 'Image';
    content.value.thumbnail = '';
    content.value.url = '${images.path}';
    update();
  }

  uploadImagesOrVideos({required PostModel postModel}) async {
    postUploading(true);

    if (postModel.content.postType == 'Video') {
      CustomSnackBars.instance.showToast(message: 'Upload started!!!');
      var thumbnailDownloaded = await FirebaseStorageService.instance
          .uploadSingleImage(
              imgFilePath: postModel.content.thumbnail,
              storageRef: '${userModelGlobal.value.uid}/posts/thumbnails');
      var videoDownloaded = await FirebaseStorageService.instance
          .uploadSingleImage(
              imgFilePath: postModel.content.url,
              storageRef: '${userModelGlobal.value.uid}/posts/videos');
      postModel.content.thumbnail = thumbnailDownloaded;
      postModel.content.url = videoDownloaded;
    } else if(postModel.content.postType == 'Image') {
      var imageDownloaded = await FirebaseStorageService.instance
          .uploadSingleImage(
              imgFilePath: postModel.content.url,
              storageRef: '${userModelGlobal.value.uid}/posts/images');
      postModel.content.url = imageDownloaded;
    }
    log(postModel.toMap().toString());
    return postModel;
  }

  uploadPostToCollection({required PostModel postModel}) async {
    try {
      await postsCollection.add(postModel.toMap()).then((value) async {
        await FirebaseCRUDServices.instance.updateDocument(
            collectionPath: 'posts',
            docId: value.id,
            data: {'postID': value.id});
      });
      postUploading(false);
      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Post uploaded successfully!!!');
      captionController.clear();
      content = Rx(ContentModel(postType: '', thumbnail: '', url: ''));
      update();

    } on FirebaseException catch (e) {
      postUploading(false);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e.message}');
    } catch (e) {
      postUploading(false);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e}');
    }
  }

  likePost({required postId, required isAddLike}) async {
    if (isAddLike) {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.increment(1),
        'likesList': FieldValue.arrayUnion([userModelGlobal.value.uid])
      });
    } else {
      await postsCollection.doc(postId).update({
        'likes': FieldValue.increment(-1),
        'likesList': FieldValue.arrayRemove([userModelGlobal.value.uid])
      });
    }
  }

  addBookMark({required postId, required isAddBookmark}) async {
    if (isAddBookmark) {
      await usersCollection.doc(userModelGlobal.value.uid).update({
        'bookmarked': FieldValue.arrayUnion([postId])
      });
    } else {
      await usersCollection.doc(userModelGlobal.value.uid).update({
        'bookmarked': FieldValue.arrayRemove([postId])
      });
    }
  }

  checkIfReplies({required commentId, required postId}) async {
    var len = await postsCollection
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .collection('replies')
        .get();
    var replies = false;
    if (len.docs.length > 0) {
      replies = true;
    } else {
      replies = false;
    }
    return replies;
  }

  likeReplyComment(
      {required String postID,
      required String commentID,
      required String uid,
      required String repliedToComment,
      required bool exists}) async {
    if (exists) {
      await postsCollection
          .doc(postID)
          .collection("comments")
          .doc(commentID)
          .collection('replies')
          .doc(repliedToComment)
          .update({
        "likes": FieldValue.arrayRemove([uid]),
      });
    } else {
      await postsCollection
          .doc(postID)
          .collection("comments")
          .doc(commentID)
          .collection('replies')
          .doc(repliedToComment)
          .update({
        "likes": FieldValue.arrayUnion([uid]),
      });
    }
  }

  likeComment(
      {required String postID,
      required String commentID,
      required String uid,
      required bool exists}) async {
    if (exists) {
      await postsCollection
          .doc(postID)
          .collection("comments")
          .doc(commentID)
          .update({
        "likes": FieldValue.arrayRemove([uid]),
      });
    } else {
      await postsCollection
          .doc(postID)
          .collection("comments")
          .doc(commentID)
          .update({
        "likes": FieldValue.arrayUnion([uid]),
      });
    }
  }

  postCommentReply(
      {required commentId, required postId, required userId}) async {
    if (commentController.text.trim().isEmpty) return;
    await postsCollection
        .doc(postId!)
        .collection("comments")
        .doc(commentId)
        .collection('replies')
        .add({
      "comment": commentController.text.trim(),
      "sender": userId!,
      "date": DateTime.now(),
      "likes": [],
    }).then((value) async {
      commentController.clear();
      await postsCollection.doc(postId!).update({
        "comments": FieldValue.increment(1),
      });
      await postsCollection
          .doc(postId!)
          .collection("comments")
          .doc(commentId)
          .collection('replies')
          .doc(value.id)
          .update({
        "commentId": value.id,
      });
    });
  }

  postComment({required postId, required sendId}) async {
    if (commentController.text.trim().isEmpty) return;
    await postsCollection.doc(postId!).collection("comments").add({
      "comment": commentController.text.trim(),
      "sender": sendId!,
      "date": DateTime.now(),
      "likes": [],
    }).then((value) async {
      commentController.clear();
      await postsCollection.doc(postId!).update({
        "comments": FieldValue.increment(1),
      });
      await postsCollection
          .doc(postId!)
          .collection("comments")
          .doc(value.id)
          .update({
        "commentId": value.id,
      });
    });
  }

}
