import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/view/screens/chat/zego_widgets.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

AppBar chat_Page_appbar({
  bool haveBackIcon = true,
  required VoidCallback menuOnTap,
  required VoidCallback voiceCallOnTap,
  required VoidCallback videoCallOnTap,
  required Widget zegoButton,
  required Widget zegoVideoButton,
  String personName = 'Jeneva',
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: (haveBackIcon == true)
        ? GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: kBlackColor1,
              size: 16,
            ),
          )
        : null,
    centerTitle: true,
    title: _IsUserVerification(
      personName: personName,
    ),
    actions: [
      Row(
        children: [

            zegoButton,
          zegoVideoButton,

          SizedBox(
            width: 5,
          ),

          // Video Call Icon
          // _ActionButtons(
          //   onTap: videoCallOnTap,
          //   svgIcon: Assets.imagesVideoCallIcon,
          // ),

          // phone call icon

          // _ActionButtons(
          //   onTap: voiceCallOnTap,
          //   w: 17,
          //   svgIcon: Assets.imagesPhoneIcon,
          // ),

          // menu icon
          _ActionButtons(
            onTap: menuOnTap,
            svgIcon: Assets.imagesMenuIcon,
          ),
          SizedBox(
            width: 5,
          )
        ],
      )
    ],
  );
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String? svgIcon;
  final double? h, w;
  _ActionButtons(
      {super.key, required this.onTap, this.svgIcon, this.h, this.w});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        // color: Colors.amber,
        child: CommonImageView(
          svgPath: svgIcon,
          height: h,
          width: w,
        ),
      ),
    );
  }
}

class _IsUserVerification extends StatelessWidget {
  final String personName;
  final bool userVerified;
  const _IsUserVerification({
    super.key,
    this.personName = 'userName',
    this.userVerified = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: MyText(
            paddingRight: 8,
            text: personName,
            size: 18,
            weight: FontWeight.w500,
            color: kBlackColor1,
          ),
        ),
        (userVerified)
            ? Container(
                //color: Colors.amber,
                child: CommonImageView(
                  svgPath: Assets.imagesUserVerifiedIcon,
                  height: 16,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
