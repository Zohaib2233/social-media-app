import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';

class SvgIconsButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? svgIcon;
  final double right, left;
  final double horizontalPadding;
  const SvgIconsButton(
      {super.key,
      this.onTap,
      this.svgIcon,
      this.right = 0,
      this.left = 0,
      this.horizontalPadding = 5});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kTransperentColor,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        margin: EdgeInsets.only(right: right, left: left),
        //color: Colors.amber,
        child: CommonImageView(
          svgPath: svgIcon,
        ),
      ),
    );
  }
}
