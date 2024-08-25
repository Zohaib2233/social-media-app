import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/authControllers/edit_profile_controller.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../widget/custom_textfield.dart';
import '../../widget/intel_phone_field_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<EditProfileController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => controller.profilePath.value == ''
                  ? ProfileImage(
                      profileImg: userModelGlobal.value.profilePicture,
                      userName: "Change profile photo",
                      onProfileChange: () {
                        controller.buildOpenImagePickerBottomSheet(
                            context: context,
                            cameraTap: () async {
                              Get.back();
                              await controller.pickImageFromCamera();
                            },
                            galleryTap: () async {
                              Get.back();
                              await controller.pickImageFromGallery();
                            });
                      },
                    )
                  : ProfileImage(
                      fileImage: controller.profilePath.value,
                      userName: "Change profile photo",
                      onProfileChange: () {
                        controller.buildOpenImagePickerBottomSheet(
                            context: context,
                            cameraTap: controller.pickImageFromCamera(),
                            galleryTap: controller.pickImageFromGallery());
                      },
                    ),
            ),
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _LebelTextFieldCustom(
                  //   label: "Name",
                  //   cPL: 15,
                  // ),
                  // SizedBox(height: 5),
                  // _LebelTextFieldCustom(
                  //   label: "Email",
                  //   cPL: 15,
                  // ),
                  // SizedBox(height: 5),
                  // _LebelTextFieldCustom(
                  //   label: "Phone Number",
                  //   cPL: 15,
                  // ),
                  // SizedBox(height: 5),
                  // _LebelTextFieldCustom(
                  //   label: "Username",
                  //   cPL: 15,
                  // ),
                  // SizedBox(height: 5),
                  // _LebelTextFieldCustom(
                  //   label: "Bio",
                  //   cPL: 15,
                  // ),
                  // SizedBox(height: 10),
                  // CustomDropDown(
                  //   hint: 'Gender',
                  //   items: ['Male', 'Female'],
                  //   onChanged: (value) {},
                  // ),
                  CustomTextField(
                    top: 22,
                    labelText: "Name",
                    hintText: "yourname",
                    controller: controller.nameController,
                    // validator: ValidationService.instance.emptyValidator,
                  ),
                  CustomTextField(
                    top: 22,
                    labelText: "Bio",
                    hintText: "Bio here",
                    controller: controller.bioController,
                    // validator: ValidationService.instance.emptyValidator,
                  ),
                  CustomTextField(
                    top: 22,
                    labelText: "Username",
                    hintText: "username",
                    controller: controller.userNameController,
                    // validator: ValidationService.instance.emptyValidator,
                  ),
                  // CustomTextField(
                  //   top: 12,
                  //   labelText: "Email address",
                  //   hintText: "youremail@gmail.com",
                  //   controller: controller.emailController,
                  //   // validator: ValidationService.instance.emailValidator,
                  // ),
                  // Phone Number

                  IntlPhoneFieldWidget(
                    controller: controller.phoneNumberController,
                    onSubmitted: (value) {
                      // controller.combinePhoneNumber(value);
                      print("Value ${value.completeNumber}");
                      controller.combinePhoneNumber.value =
                          value.completeNumber;
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.selectDob(context);
                    },
                    child: CustomTextField(
                      enabled: false,
                      top: 0,
                      labelText: "Date of birth",
                      controller: controller.dobController,
                      hintText: "dd/mm/yy",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.isTrue
                          ? Center(
                              child: CircularProgressIndicator(
                                color: kSecondaryColor,
                              ),
                            )
                          : MyButton(
                              onTap: () {
                                controller.updateProfile();
                              },
                              buttonText: "Done"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _LebelTextFieldCustom extends StatelessWidget {
  final String? label;
  final double cPL;
  TextEditingController? controller = TextEditingController();
  _LebelTextFieldCustom({super.key, this.label, this.cPL = 0, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        cursorHeight: 15,
        cursorWidth: 1,
        controller: controller,
        // controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: cPL),
          label: MyText(
            text: '$label',
            size: 14,
            weight: FontWeight.w400,
            color: kGreyColor1,
          ),
          hintStyle:
              TextStyle(fontSize: 13, color: kGreyColor1.withOpacity(0.5)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kGreyColor1.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String? profileImg, userName, fileImage;
  final VoidCallback? onProfileChange;
  const ProfileImage(
      {super.key,
      this.profileImg,
      this.userName,
      this.fileImage,
      this.onProfileChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: EdgeInsets.only(top: 60),
      width: double.maxFinite,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.imagesBkDecorationPngImg),
              fit: BoxFit.fill)),
      child: Column(
        children: [
          fileImage == null
              ? Container(
                  height: 131,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage("$profileImg"),
                          fit: BoxFit.fill)),
                )
              : Container(
                  height: 131,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: FileImage(
                            File("$fileImage"),
                          ),
                          fit: BoxFit.fill)),
                ),
          GestureDetector(
            onTap: onProfileChange,
            child: MyText(
              paddingTop: 10,
              text: "$userName",
              size: 12,
              weight: FontWeight.w400,
              color: kSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
