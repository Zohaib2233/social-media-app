import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/auth/fogot/change_password.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Forget Password",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              paddingTop: 7,
              text: "Enter the email address linked to your account.",
              size: 12,
              weight: FontWeight.w600,
            ),
            CustomTextField(
              top: 50,
              labelText: "Email address",
              hintText: "youremail@gmail.com",
            ),
            MyButton(
                onTap: () {
                  Get.to(ChangePassword());
                },
                mTop: 50,
                mBottom: 16,
                buttonText: "Next"),
          ],
        ),
      ),
    );
  }
}
