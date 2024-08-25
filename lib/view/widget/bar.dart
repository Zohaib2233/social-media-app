import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';

class BarWith60Width extends StatelessWidget {
  const BarWith60Width({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 6,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kGreyColor1,
        ),
      ),
    );
  }
}
