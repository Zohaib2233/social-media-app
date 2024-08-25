import 'package:flutter/material.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../constants/app_colors.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton(
      {required this.onTap,
        required this.buttonText,
        this.height = 48,
        this.backgroundColor = kSecondaryColor,
        this.fontColor = kWhiteColor,
        this.fontSize = 16,
        this.outlineColor = kTransperentColor,
        this.radius = 8,
        this.svgIcon,
        this.haveSvg = false,
        this.mBottom = 0,
        this.mTop = 0,
        this.progressColor = kPrimaryColor,
        this.fontWeight = FontWeight.w600,
        this.isLoading = false});

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double radius;
  final double fontSize;
  final Color outlineColor;
  final Color backgroundColor, fontColor;
  final String? svgIcon;
  final bool haveSvg;
  final double mTop, mBottom;
  final FontWeight fontWeight;
  final bool isLoading;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop, bottom: mBottom),
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: outlineColor),
        // boxShadow: [
        //   BoxShadow(
        //     offset: Offset(0, 4),
        //     color: kPrimaryColor.withOpacity(0.25),
        //     blurRadius: 15,
        //     spreadRadius: 0,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Material(
        color: kTransperentColor,
        child: InkWell(
          onTap: onTap,
          splashColor: kPrimaryColor.withOpacity(0.1),
          highlightColor: kTertiaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          child: (isLoading)
              ? Center(
            child: CircularProgressIndicator(
              color: progressColor,
              strokeWidth: 2,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (haveSvg == true)
                  ? CommonImageView(
                svgPath: svgIcon,
              )
                  : SizedBox(),
              MyText(
                paddingLeft: (haveSvg == true) ? 10 : 0,
                text: buttonText,
                size: fontSize,
                color: fontColor,
                weight: fontWeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
