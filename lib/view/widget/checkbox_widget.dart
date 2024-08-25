import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Color kborderColor;
  final bool haveCheckBoxTrue = false;

  CheckBoxWidget(
      {super.key,
      this.isChecked = false,
      required this.onChanged,
      this.kborderColor = kSecondaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      width: 20,
      child: Checkbox(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: BorderSide(
            color: (isChecked == true) ? kSecondaryColor : kborderColor),
        checkColor: Colors.white,
        activeColor: Colors.red,
        focusColor: Colors.amber,
        fillColor: MaterialStatePropertyAll(
            (isChecked == true) ? kSecondaryColor : Colors.transparent),
        value: isChecked,
        onChanged: onChanged,
      ),
    );
  }
}
