import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';

class HorizantalDivider extends StatelessWidget {
  final Color color;
  final double thickness;
  const HorizantalDivider(
      {super.key, this.color = kGreyColor1, this.thickness = 0.2});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: thickness, color: color);
  }
}
