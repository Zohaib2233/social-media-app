import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';

class CustomSimpleTextField extends StatelessWidget {
  final double radius;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  TextEditingController? controller;
  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final Color outlineBorderColor;
  final double outlineBorderWidth;

  final String hintText;
  final double hintTextFontSize;
  final Color hintTextFontColor;
  final bool filled;
  final Color backgroundColor;
  final double contentPaddingLeft;
  final double contentPaddingRight;
  final double contentPaddingBottom;
  final double contentPaddingTop;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final String img;
  final bool haveSuffixIcon;
  final bool obscureText;
  final double iconScale;
  final bool expands;
  final FontWeight? hintFontWeight;
  final int maxLines;
  final Widget? suffixWidget;
  final double fontSize;
  final FontWeight fontWeight;

  CustomSimpleTextField(
      {super.key,
      this.radius = 5,
      this.borderRadius = 5,
      this.borderColor = kGreyColor3,
      this.borderWidth = 0,
      this.focusedBorderColor = kSecondaryColor,
      this.focusedBorderWidth = 1,
      this.outlineBorderColor = kGreyColor3,
      this.outlineBorderWidth = 1,
      required this.hintText,
      this.hintTextFontColor = kGreyColor1,
      this.hintTextFontSize = 12,
      this.controller,
      this.filled = false,
      this.backgroundColor = kPrimaryColor,
      this.contentPaddingLeft = 15,
      this.contentPaddingRight = 0,
      this.contentPaddingBottom = 0,
      this.contentPaddingTop = 15,
      this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0,
      this.img = '',
      this.haveSuffixIcon = false,
      this.obscureText = false,
      this.iconScale = 4,
      this.expands = false,
      this.maxLines = 3,
      this.suffixWidget,
      this.hintFontWeight = FontWeight.w400,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: TextField(
        cursorWidth: 1,
        expands: expands,
        maxLines: maxLines,
        controller: controller,
        // expands: expand,

        obscureText: obscureText,
        style: TextStyle(
            color: kBlackColor1, fontSize: fontSize, fontWeight: fontWeight),
        decoration: InputDecoration(
          suffixIcon:
              (haveSuffixIcon == false) ? null : Container(child: suffixWidget),
          filled: filled,
          fillColor: backgroundColor,
          hintText: hintText,
          hintStyle: TextStyle(
              color: hintTextFontColor,
              fontSize: hintTextFontSize,
              fontWeight: hintFontWeight),
          border: outlineInputBorderDecoration(
              r: borderRadius, borderClr: borderColor, width: borderRadius),
          focusedBorder: outlineInputBorderDecoration(
              r: radius,
              borderClr: focusedBorderColor,
              width: focusedBorderWidth),
          enabledBorder: outlineInputBorderDecoration(
              r: radius,
              borderClr: outlineBorderColor,
              width: outlineBorderWidth),
          contentPadding: EdgeInsets.only(
              left: contentPaddingLeft,
              bottom: contentPaddingBottom,
              top: contentPaddingTop,
              right: contentPaddingRight),
        ),
      ),
    );
  }

  OutlineInputBorder outlineInputBorderDecoration(
      {double? r, Color? borderClr, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(r!),
      borderSide: BorderSide(color: borderClr!, width: width!),
    );
  }
}
