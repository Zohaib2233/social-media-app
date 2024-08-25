import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/auth/fogot/back_to_login.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Create new password",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              textAlign: TextAlign.center,
              paddingTop: 7,
              text:
                  "Your new password must be unique from those\npreviously used",
              size: 12,
              weight: FontWeight.w600,
            ),
            CustomTextField(
              obscureText: true,
              top: 22,
              labelText: "Password",
              hintText: "************",
            ),
            CustomTextField(
              obscureText: true,
              top: 12,
              labelText: "Confirm password",
              hintText: "************",
            ),
            MyButton(
                onTap: () {
                  Get.to(BackToLogin());
                },
                mTop: 50,
                mBottom: 16,
                buttonText: "Done"),
          ],
        ),
      ),
    );
  }
}
