import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/screens/settings/update_password.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class PasswordAndSecurity extends StatefulWidget {
  const PasswordAndSecurity({super.key});

  @override
  State<PasswordAndSecurity> createState() => _PasswordAndSecurityState();
}

class _PasswordAndSecurityState extends State<PasswordAndSecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Password and Security"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyContainer(
              mTop: 0,
              widget: Column(
                children: [
                  SettingsTile(
                    onTap: () {
                      Get.to(UpdatePassword());
                    },
                    mTop: 0,
                    svgIcon: Assets.imagesRVIcon,
                    title: 'Change password',
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
