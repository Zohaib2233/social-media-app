import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/view/screens/bookmark/bookmark_page.dart';
import 'package:soical_media_app/view/screens/notification/notification.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

AppBar appbar_widget({
  bool haveBackIcon = true,
  Widget? leadingWidget,
  bool haveTitle = true,
  String title = 'title',
  bool haveNotification = true,
  bool haveActionIcons = true,
}) {
  return AppBar(
    elevation: 0,
    surfaceTintColor: kWhiteColor,
    //shadowColor: Colors.amber,
    //backgroundColor: Colors.amber,
    //automaticallyImplyLeading: false,
    leadingWidth: Get.width * 0.29,
    leading: (haveBackIcon == true)
        ? Container(
            //color: Colors.red,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 37,
                    width: 68,
                    // color: Colors.amber,
                    child: CommonImageView(
                      // height: 40,
                      // width: 40,
                      svgPath: Assets.imagesLogoWithNurIcon,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: leadingWidget,
          ),
    centerTitle: true,
    title: (haveTitle == true)
        ? MyText(
            text: title,
            size: 18,
            weight: FontWeight.w600,
          )
        : null,

    actions: [
      (haveActionIcons == true)
          ? Row(
              children: [
                NotificationButtonWithDot(
                  haveNotification: haveNotification,
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => BookMarkPage());
                  },
                  child: CommonImageView(
                    svgPath: Assets.imagesBookMarkIcon,
                  ),
                ),
                SizedBox(width: 20),
              ],
            )
          : SizedBox()
    ],
  );
}

class BookMarkButton extends StatelessWidget {
  final VoidCallback? onTap;

  BookMarkButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CommonImageView(
        svgPath: Assets.imagesBookMarkIcon,
      ),
    );
  }
}

class NotificationButtonWithDot extends StatelessWidget {
  final bool haveNotification;

  const NotificationButtonWithDot({
    super.key,
    this.haveNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              NotificationPage(),
              binding: NotificationBindings(),
            );
          },
          child: Container(
              child: CommonImageView(
            svgPath: Assets.imagesNotificationIcon,
          )),
        ),
        Positioned(
            right: 0,
            child: (haveNotification == true)
                ? Icon(
                    Icons.circle,
                    size: 10,
                    color: kBlackColor1,
                  )
                : SizedBox())
      ],
    );
  }
}
