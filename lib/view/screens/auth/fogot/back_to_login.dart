import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class BackToLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Password changed",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              textAlign: TextAlign.center,
              paddingTop: 7,
              text: "Password has been changed. Kindly log in to\ncontinue.",
              size: 12,
              weight: FontWeight.w600,
            ),
            MyButton(
                onTap: () {
                  Get.to(Login());
                },
                mTop: 109,
                buttonText: "Back to login"),
          ],
        ),
      ),
    );
  }
}
