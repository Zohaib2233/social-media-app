import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/profile_controller/profiel_controller.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class AccountPrivacy extends StatefulWidget {
  const AccountPrivacy({super.key});

  @override
  State<AccountPrivacy> createState() => _AccountPrivacyState();
}

class _AccountPrivacyState extends State<AccountPrivacy> {
  ProfileController profileController = Get.find<ProfileController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Account Privacy"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            // text

            MyText(
              text:
                  """When your account is public, your profile and posts can be seen by anyone, on or off Instagram, even if they don’t have an Instagram account.""",
              size: 12,
              weight: FontWeight.w400,
              color: kBlackColor1.withOpacity(0.5),
              lineHeight: 2,
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: "Public",
                  size: 14,
                  color: kBlackColor1,
                  weight: FontWeight.w500,
                ),
                Obx(
                  () => SwitchButtonWidget(
                    swichValue: profileController.isPrivate.value,
                    onChanged: (value) async {
                      profileController.isPrivate.value = value;
                      await profileController.updateProfilePrivacy();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SwitchButtonWidget extends StatelessWidget {
  final swichValue;
  final Function(dynamic)? onChanged;

  const SwitchButtonWidget({
    super.key,
    this.onChanged,
    this.swichValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 43,
      decoration: BoxDecoration(
          //color: (swichValue == false) ? kTransperentColor : kSecondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Transform.scale(
        scale: 0.7,
        child: Switch(
            activeTrackColor: kSecondaryColor,
            inactiveTrackColor: kGreyColor1,
            value: swichValue,
            onChanged: onChanged),
      ),
    );
  }
}
