import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Change Password"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              text: """
You will be logged out of all sessions except this one to protect your account nif anyone is trying to gain access.

Your password must be at least 6 chracters and should include a combination of numbers, letters and special characters.""",
              size: 12,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
              lineHeight: 2,
            ),
            SizedBox(height: 15),
            CustomTextField(
              labelText: "Current password",
              hintText: '**********',
            ),
            SizedBox(height: 15),
            CustomTextField(
              labelText: "New password",
              hintText: '**********',
            ),
            SizedBox(height: 15),
            CustomTextField(
              labelText: "Confirm new password",
              hintText: '**********',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 20, top: 10),
        padding: AppSizes.HORIZONTAL,
        child: Row(
          children: [
            Expanded(
                child: MyButton(
                    onTap: () {
                      Get.to(()=>SettingScreen());
                    },
                    buttonText: "Done"))
          ],
        ),
      ),
    );
  }
}
