import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/settings/privacy_policy.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/screens/settings/terms_of_use.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "About"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyContainer(
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      Get.to(PrivacyPolicy());
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesPrivacyAboutIcon,
                    title: 'Privacy policy',
                  ),
                  SettingsTile(
                    onTap: () {
                      Get.to(TearmOfUse());
                    },
                    svgIcon: Assets.imagesTermOfUseIcon,
                    title: 'Terms of use',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
