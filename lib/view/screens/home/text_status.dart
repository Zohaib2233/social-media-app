import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/home/upload_status.dart';

class TextStatusPage extends StatefulWidget {
  const TextStatusPage({super.key});

  @override
  State<TextStatusPage> createState() => _TextStatusPageState();
}

class _TextStatusPageState extends State<TextStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightRedColor,
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                Spacer(),
                SvgButton(
                  onTap: () {
                    Get.to(TextStatusPage());
                  },
                  svgIcon: Assets.imagesTIcon,
                ),
                SizedBox(width: 28),
                SvgButton(
                  onTap: () {},
                  svgIcon: Assets.imagesChangeStatusColorIcon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
