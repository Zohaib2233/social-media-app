import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

AppBar simple_appbar_with_back_button({
  bool haveSubTitle = false,
  String title = 'title',
  String subTitle = 'title',
}) {
  return AppBar(
      surfaceTintColor: kWhiteColor,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: kBlackColor1,
          size: 18,
        ),
      ),
      centerTitle: true,
      title: Column(
        children: [
          MyText(
            text: title,
            size: 18,
            weight: FontWeight.w600,
            color: kBlackColor1,
          ),
          (haveSubTitle == true)
              ? MyText(
                  paddingTop: 4,
                  text: subTitle,
                  size: 12,
                  weight: FontWeight.w400,
                  color: kGreyColor1,
                )
              : SizedBox()
        ],
      ));
}
