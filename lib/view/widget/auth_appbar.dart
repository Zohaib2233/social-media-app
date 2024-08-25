import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';

AppBar auth_appbar({
  bool haveBackIcon = true,
}) {
  return AppBar(
    surfaceTintColor: kWhiteColor,
    automaticallyImplyLeading: false,
    leading: (haveBackIcon == true)
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kBlackColor1,
            ),
          )
        : null,
    centerTitle: true,
    title: CommonImageView(
      svgPath: Assets.imagesLogoWithHorizantallText,
    ),
  );
}
