import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/global/functions.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_storage_service.dart';

import '../../core/utils/utils.dart';
import '../../view/widget/image_picker_bottom_sheet.dart';

class EditProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();

  // TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  RxString combinePhoneNumber = ''.obs;

  RxString profilePath = ''.obs;
  // RxString profileUrl = ''.obs;
  final ImagePicker imagePicker = ImagePicker();

  RxBool isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameController.text = userModelGlobal.value.name;
    userNameController.text = userModelGlobal.value.username;
    // emailController.text = userModelGlobal.value.email;
    phoneNumberController.text = userModelGlobal.value.phoneNo;
    bioController.text = userModelGlobal.value.bio;
    dobController.text = userModelGlobal.value.dob;
  }

  selectDob(BuildContext context) async {
    dobController.text = await Utils.createDatePicker(context);
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

  updateProfile() async {
    isLoading(true);
    bool isExists = false;
    if (userNameController.text != userModelGlobal.value.username) {
      isExists = await FirebaseCRUDServices.instance.isDocExistByUsername(
          collectionString: FirebaseConstants.userCollection,
          username: userNameController.text);
    } else {
      isExists = false;
    }
    if (isExists) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Username already exists", message: "Please change username");
    } else {
      await FirebaseCRUDServices.instance.updateDocument(
          collectionPath: FirebaseConstants.userCollection,
          docId: FirebaseConstants.auth.currentUser!.uid,
          data: {
            'name': nameController.text,
            'username': userNameController.text,
            'combinePhoneNo': combinePhoneNumber.value,
            'phoneNo': phoneNumberController.text,
            'dob': dobController.text,
            'bio': bioController.text,
          });

      if (profilePath.isNotEmpty) {
        String profileUrl = await FirebaseStorageService.instance
            .uploadSingleImage(imgFilePath: profilePath.value);
        await FirebaseCRUDServices.instance.updateDocument(
            collectionPath: FirebaseConstants.userCollection,
            docId: FirebaseConstants.auth.currentUser!.uid,
            data: {
              'profilePicture': profileUrl,
            });
      }
      await getUserDataStream(userId: userModelGlobal.value.uid);
      Get.back();
      CustomSnackBars.instance.showSuccessSnackbar(
          title: 'Success', message: 'Profile updated successfully');

      isLoading(false);
    }
  }
}
