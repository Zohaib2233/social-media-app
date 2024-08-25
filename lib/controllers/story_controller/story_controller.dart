import 'dart:developer';
import 'dart:io';

import 'package:advstory/advstory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/models/post_model/post_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:story_maker/story_maker.dart';

import '../../models/story_models/switch_story_model.dart';
import '../../services/collections.dart';
import '../../view/widget/image_picker_bottom_sheet.dart';

class StoryUploadController extends GetxController {
  RxBool isUploadingStories = false.obs;
  RxBool refreshStory = false.obs;
  RxList userFollowersIds = [].obs;
  RxList publicAccounts = [].obs;
  RxList postsToShow = [].obs;
  final ImagePicker imagePicker = ImagePicker();
  File? storyImage;
  var storyIndexRn = 0.obs;
  AdvStoryController advController = AdvStoryController();

  // updateViewsInStories({required viewedBy, required storyId,required ownerId}) async {
  //   await usersCollection.doc(ownerId).collection('stories').
  // }

  likeComment({required commendId, required likedById, required postId}) async {
    await postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commendId)
        .update({});
  }

  pickVideo() async {
    final XFile? images =
        await imagePicker.pickVideo(source: ImageSource.gallery);
    if (images!.path.isEmpty) return;
    storyImage = File(images.path);
    if (storyImage == null) return;
    if (storyImage != null) {
      await addStoryVideo(userModelGlobal.value.uid, images.path);
    }
    update();
  }

  pickVideoFromCamera() async {
    final XFile? images =
        await imagePicker.pickVideo(source: ImageSource.camera);
    if (images!.path.isEmpty) return;
    storyImage = File(images.path);
    if (storyImage == null) return;
    if (storyImage != null) {
      await addStoryVideo(userModelGlobal.value.uid, images.path);
    }
    update();
  }

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

  void buildOpenImagePickerBottomSheet(
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

  pickImageFromCamera() async {
    final XFile? images =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (images!.path.isEmpty) return;
    storyImage = File(images.path);
    if (storyImage == null) return;
    if (storyImage != null) {
      final res = await Get.to(StoryMaker(filePath: storyImage!.path));
      await addStoryImage(FirebaseAuth.instance.currentUser!.uid, res.path);
      update();
    }
  }

  pickImage() async {
    final XFile? images =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (images!.path.isEmpty) return;
    storyImage = File(images.path);
    if (storyImage == null) return;
    if (storyImage != null) {
      final res = await Get.to(StoryMaker(filePath: storyImage!.path));
      await addStoryImage(FirebaseAuth.instance.currentUser!.uid, res.path);
      update();
    }
  }

  addStoryImage(String uid, String path) async {
    if (path.isEmpty) return;
    isUploadingStories.value = true;
    final storageRef = FirebaseStorage.instance.ref();

    try {
      int fileName = DateTime.now().microsecondsSinceEpoch;
      final snapshot =
          await storageRef.child("stories/${uid}/story_${fileName}").putFile(
                File(path),
                SettableMetadata(contentType: "image/jpeg"),
              );

      if (snapshot.state == TaskState.error ||
          snapshot.state == TaskState.canceled) {
        throw "There was an error during upload";
      }

      if (snapshot.state == TaskState.success) {
        var imageUrl = await snapshot.ref.getDownloadURL();
        Map<String, dynamic> data = {
          "canReact": true,
          "imageURL": imageUrl,
          "type": 'image',
          "postDate": DateTime.now(),
          "showTill": DateTime.now().add(Duration(days: 1)),
          "views": 0,
          "viewBy": [],
        };
        await usersCollection.doc(uid).collection("stories").add(data);
        refreshStory.value = true;
        Future.delayed(Duration(seconds: 1)).then((value) {
          refreshStory.value = false;
        });
        isUploadingStories.value = false;
        CustomSnackBars.instance.showToast(message: 'Story uploaded!!');
      }
    } on FirebaseException catch (e) {
      log(e.code);
      Fluttertoast.showToast(msg: e.code);
      isUploadingStories.value = false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      isUploadingStories.value = false;
    }
  }

  addStoryVideo(String uid, String path) async {
    if (path.isEmpty) return;
    isUploadingStories.value = true;
    final storageRef = FirebaseStorage.instance.ref();

    try {
      int fileName = DateTime.now().microsecondsSinceEpoch;
      final snapshot =
          await storageRef.child("stories/${uid}/story_${fileName}").putFile(
                File(path),
                SettableMetadata(contentType: "video/mp4"),
              );

      if (snapshot.state == TaskState.error ||
          snapshot.state == TaskState.canceled) {
        throw "There was an error during upload";
      }

      if (snapshot.state == TaskState.success) {
        var imageUrl = await snapshot.ref.getDownloadURL();
        Map<String, dynamic> data = {
          "canReact": true,
          "imageURL": imageUrl,
          "type": 'video',
          "postDate": DateTime.now(),
          "showTill": DateTime.now().add(Duration(days: 1)),
          "views": 0,
          "viewBy": [],
        };
        await usersCollection.doc(uid).collection("stories").add(data);
        refreshStory.value = true;
        Future.delayed(Duration(seconds: 1)).then((value) {
          refreshStory.value = false;
        });
        CustomSnackBars.instance.showToast(message: 'Story uploaded!!');
        isUploadingStories.value = false;
      }
    } on FirebaseException catch (e) {
      log(e.code);
      Fluttertoast.showToast(msg: e.code);
      isUploadingStories.value = false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      isUploadingStories.value = false;
    }
  }

  Future<List<SwitchStoryGroup>> getYourStories({required userId}) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .where('userId', isEqualTo: userId)
          .get();
      if (snap.docs.isEmpty) return [];
      List<SwitchStoryGroup> stories = [];
      for (var follower in snap.docs) {
        final story = await getUserStory(follower.id);
        if (story == null) continue;
        stories.add(story);
      }
      return stories;
    } on FirebaseException catch (e) {
      log(e.code);
      Fluttertoast.showToast(msg: e.code);
      return [];
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  RxList<SwitchStoryGroup> storiesUploaded = RxList([]);
  Future<List<SwitchStoryGroup>> getFollowingStories() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      final snap = await FirebaseFirestore.instance
          .collection("users")
          // .doc(user.uid)
          // .collection("following")
          .get();
      if (snap.docs.isEmpty) return [];
      List<SwitchStoryGroup> stories = [];
      for (var follower in snap.docs) {
        final story = await getUserStory(follower.id);
        if (story == null) continue;
        stories.add(story);
      }
      storiesUploaded.value = stories;
      log('FUNCTION RAN');
      update();
      return stories;
    } on FirebaseException catch (e) {
      log(e.code);
      Fluttertoast.showToast(msg: e.code);
      return [];
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  deleteStory({required userId, required storyId}) async {
    await usersCollection
        .doc(userId)
        .collection('stories')
        .doc(storyId)
        .delete();
  }

  Future<SwitchStoryGroup?> getUserStory(String id) async {
    try {
      final snap = await usersCollection
          .doc(id)
          .collection("stories")
          .where("showTill", isGreaterThan: Timestamp.now())
          .orderBy("showTill", descending: true)
          .orderBy("postDate")
          .withConverter(
            fromFirestore: (snapshot, options) =>
                SwitchStory.fromJson({"id": snapshot.id, ...snapshot.data()!}),
            toFirestore: (value, options) => {},
          )
          .get();
      final userSnap =
          await FirebaseFirestore.instance.collection("users").doc(id).get();
      if (snap.docs.isEmpty || !userSnap.exists) return null;
      List<SwitchStory> stories = [];
      for (var story in snap.docs) {
        stories.add(story.data());
      }
      stories = stories.reversed.toList();
      UserModel userModel = UserModel.fromJson2(userSnap.data()!);
      return SwitchStoryGroup(stories, userModel, id);
    } on FirebaseException catch (e) {
      log(e.code);
      Fluttertoast.showToast(msg: e.code);
      return null;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  //my changes start
  late CollectionReference collectionReference;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var postsCollectionReference;

  //initializing list of Posts type to get posts streams in it
  RxList<PostModel> positionWisePosts = RxList<PostModel>([]);

  //fetching all the posts position wise
  Future<bool> getPositionWisePosts({required String postsOwnerId}) async {
    positionWisePosts.value = [];
    print('IN POSTION WISE FUTURE');
    try {
      collectionReference = fireStore.collection('posts');
      final snap = await FirebaseFirestore.instance
          .collection('posts')
          .where("uid", isEqualTo: postsOwnerId)
          .where("isRightFeed", isEqualTo: true)
          .where('active', isEqualTo: true)
          .orderBy('postPosition', descending: false)
          .get();

      for (var doc in snap.docs) {
        positionWisePosts.add(PostModel.fromMap(doc.data()));
      }
    } catch (e) {
      print(e.toString());
    }
    return true;
  }

  Future<void> swapPostsList(
      {required int oldIndex, required int newIndex}) async {
    var item = positionWisePosts.removeAt(oldIndex);
    positionWisePosts.insert(newIndex, item);
    for (int i = 0; i < positionWisePosts.length; i++) {
      await updatePositionOnServer(
          postId: positionWisePosts[i].postID, newPosition: i);
    }
  }

  //to update positions of dragged and dropped images on firebase
  Future<void> updatePositionOnServer(
      {required String postId, required int newPosition}) async {
    try {
      log("Post with id $postId is dragged to $newPosition position");
      await postsCollection.doc(postId).update({"postPosition": newPosition});
    } on FirebaseException catch (e) {
      CustomSnackBars.instance.showToast(message: e.code.toString());
    } catch (e) {
      CustomSnackBars.instance.showToast(message: e.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
