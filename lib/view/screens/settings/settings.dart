import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/view/screens/languages/select_language.dart';
import 'package:soical_media_app/view/screens/settings/about.dart';
import 'package:soical_media_app/view/screens/settings/account_privacy.dart';
import 'package:soical_media_app/view/screens/settings/family_and_friends.dart';
import 'package:soical_media_app/view/screens/settings/help_and_support.dart';
import 'package:soical_media_app/view/screens/settings/mentions_and_tags.dart';
import 'package:soical_media_app/view/screens/settings/password_and_security.dart';
import 'package:soical_media_app/view/screens/settings/request_verification.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

import '../../../core/utils/dialogs.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool haveNotificationON = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Settings"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyContainer(
              mTop: 0,
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      Get.to(PasswordAndSecurity());
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesSettingBIcon,
                    title: 'Password and security',
                  ),
                  // SettingsTile(
                  //   onTap: () {
                  //     Get.to(RequestVerification());
                  //   },
                  //   svgIcon: Assets.imagesRVIcon,
                  //   title: 'Request verification',
                  // ),
                ],
              ),
            ),
            MyContainer(
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      if (haveNotificationON == true) {
                        haveNotificationON = false;
                      } else {
                        haveNotificationON = true;
                      }

                      setState(() {});
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesSettingNotificationIcon,
                    title: 'Notifications',
                    haveActionIcon: false,
                    haveWidget: true,
                    widget: MyText(
                      text: (haveNotificationON == true) ? "ON" : "OFF",
                      size: 12,
                      weight: FontWeight.w500,
                      color: kSecondaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       MyText(
                        paddingLeft: 15,
                        text: "Dark Theme",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor1,
                      ),
                    Obx(()=>Switch(
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.grey,
                        value: userModelGlobal.value.isDarkTheme,
                        onChanged: (value) async {
                          await FirebaseCRUDServices.instance.updateDocument(collectionPath: FirebaseConstants.userCollection, docId: userModelGlobal.value.uid, data: {
                            "isDarkTheme":value
                          });
                          // Get.changeTheme(userModelGlobal.value.isDarkTheme ? ThemeData.dark() : ThemeData.light());

                        },
                      ),
                    )],
                  ),
                  SettingsTile(
                    onTap: () {
                      Get.to(MentionsAndTags());
                    },
                    svgIcon: Assets.imagesSMATIcon,
                    title: 'Mentions and tags',
                  ),
                ],
              ),
            ),
            MyContainer(
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      Get.to(AccountPrivacy());
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesSAPIcon,
                    title: 'Account privacy',
                  ),
                  SettingsTile(
                    onTap: () {
                      Get.to(FamilyAndFriendsPage());
                    },
                    svgIcon: Assets.imagesSFAFIcon,
                    title: 'Family and friends',
                  ),
                ],
              ),
            ),
            MyContainer(
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      Get.to(Selectlanguages());
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesLanguageSvgSettingIcon,
                    title: 'Language',
                    haveActionIcon: false,
                  ),
                  SettingsTile(
                    onTap: () {
                      Get.to(HelpAndSupport());
                    },
                    svgIcon: Assets.imagesSLIcon,
                    title: 'Help and support',
                    haveActionIcon: false,
                  ),
                  SettingsTile(
                    onTap: () {
                      Get.to(About());
                    },
                    svgIcon: Assets.imagesSAboutIcon,
                    title: 'About',
                    haveActionIcon: false,
                  ),
                  SettingsTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteAccountDialog(),
                      );
                    },
                    haveActionIcon: false,
                    title: "Delete Account",
                    imagePath: 'assets/images/delete.png',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  final double mTop;
  final Widget widget;

  const MyContainer({super.key, required this.widget, this.mTop = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: mTop),
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: AppStyling().fillColorAndRadius(),
        child: widget);
  }
}

class SettingsTile extends StatelessWidget {
  final String? title, svgIcon;
  final VoidCallback? onTap;
  final double mTop;
  final bool haveActionIcon;
  final bool haveWidget;
  final Widget? widget;
  final String? imagePath;

  const SettingsTile(
      {super.key,
      this.onTap,
      this.title,
      this.svgIcon,
      this.mTop = 20,
      this.haveActionIcon = true,
      this.haveWidget = false,
      this.widget,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: mTop),
        child: Row(
          children: [
            if (imagePath != null)
              CommonImageView(
                imagePath: imagePath,
                height: 20,
                width: 20,
              ),
            if (svgIcon != null)
              CommonImageView(
                svgPath: svgIcon,
              ),
            Expanded(
              child: MyText(
                paddingLeft: 15,
                text: "$title",
                size: 14,
                weight: FontWeight.w500,
                color: kBlackColor1,
              ),
            ),
            (haveActionIcon == true)
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: kGreyColor1.withOpacity(0.5),
                  )
                : Container(
                    child: (haveWidget == true) ? widget : SizedBox(),
                  )
          ],
        ),
      ),
    );
  }
}
