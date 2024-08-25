import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soical_media_app/core/global/functions.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/view/widget/progressDialogue.dart';

import '../../core/constants/firebase_constants.dart';
import '../../services/firebaseServices/firebase_crud_services.dart';
import '../../services/firebaseServices/firebase_storage_service.dart';
import '../../view/widget/image_picker_bottom_sheet.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    print("Profile Init Called");
    super.onInit();
    isPrivate.value = userModelGlobal.value.isPrivate;
    updateUserCurrentLocation(userId: FirebaseConstants.auth.currentUser!.uid);
  }

  final ImagePicker imagePicker = ImagePicker();
  RxString profilePath = ''.obs;
  RxBool isPrivate = false.obs;
  RxBool isRequested = false.obs;
  RxBool isLoading = false.obs;

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
    profilePath.value = images.path;
    update();
  }

  pickImageFromGallery() async {
    final XFile? images =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (images == null) return;
    profilePath.value = images.path;
    update();
  }

  updateCoverPicture({required BuildContext context}) async {
    showProgressDialog(context: context);
    if (profilePath.isNotEmpty) {
      String profileUrl = await FirebaseStorageService.instance
          .uploadSingleImage(imgFilePath: profilePath.value);
      await FirebaseCRUDServices.instance.updateDocument(
          collectionPath: FirebaseConstants.userCollection,
          docId: FirebaseConstants.auth.currentUser!.uid,
          data: {
            'coverPhoto': profileUrl,
          });
    }
    Get.back();
    CustomSnackBars.instance
        .showSuccessSnackbar(title: 'Success', message: 'Cover photo updated');
    profilePath.value = '';
  }

  Future<void> updateProfilePrivacy() async {
    await FirebaseCRUDServices.instance.updateDocument(
      collectionPath: FirebaseConstants.userCollection,
      docId: FirebaseConstants.auth.currentUser!.uid,
      data: {'isPrivate': isPrivate.value},
    );
  }

  Future<void> sendFollowRequest(String fromUserId, String toUserId) async {
    await usersCollection
        .doc(toUserId)
        .collection(FirebaseConstants.followRequestsCollection)
        .add({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'dateRequested': DateTime.now(),
    });
  }

  Future<void> checkIfRequested(String fromUserId, String toUserId) async {
    final snaposhot = await usersCollection
        .doc(toUserId)
        .collection(FirebaseConstants.followRequestsCollection)
        .where('fromUserId', isEqualTo: fromUserId)
        .where(
          'toUserId',
          isEqualTo: toUserId,
        )
        .get();
    if (snaposhot.docs.isNotEmpty) {
      isRequested.value = true;
    } else {
      isRequested.value = false;
    }
  }
}
