import 'package:flutter/cupertino.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';

class AppStyling {
  BoxDecoration borderColorAndRadius() {
    return BoxDecoration(
        border: Border.all(color: kSecondaryColor, width: 1),
        borderRadius: BorderRadius.circular(8));
  }

  BoxDecoration fillColorAndRadius({Color color = kWhiteColor}) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(8));
  }

  DecorationImage onBoardingBkImg({
    String bk = Assets.imagesOnBoardingBkImg,
  }) {
    return DecorationImage(image: AssetImage(bk), fit: BoxFit.cover);
  }

  DecorationImage onBoardingContentImg({
    String bk = Assets.imagesOnBoardingBkImg,
  }) {
    return DecorationImage(image: AssetImage(bk), fit: BoxFit.contain);
  }

  BoxDecoration topShadowDecoration() {
    return BoxDecoration(color: kPrimaryColor, boxShadow: [
      BoxShadow(color: kGreyColor1.withOpacity(0.1), spreadRadius: 2)
    ]);
  }

  BoxDecoration decorationBorderRadius(
      {double topL = 6.0, topR = 6.0, bottomL = 0.0, bottomR = 6.0}) {
    return BoxDecoration(
        color: kGreyColor1.withOpacity(0.2),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topL),
            topRight: Radius.circular(topR),
            bottomLeft: Radius.circular(bottomL),
            bottomRight: Radius.circular(bottomR)));
  }

  BoxDecoration decorationForBottomSheet({double topL = 20, double topR = 20}) {
    return BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topL),
          topRight: Radius.circular(topR),
        ));
  }
}
