import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class WrongOtp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: true),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Wrong OTP",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              textAlign: TextAlign.center,
              paddingTop: 7,
              paddingBottom: 15,
              text:
                  "Don’t worry it happens. Please click the button to\nsend code again.",
              size: 12,
              weight: FontWeight.w600,
            ),
            SizedBox(height: 109),
            Container(
              padding: EdgeInsets.symmetric(vertical: 13),
              decoration: AppStyling().borderColorAndRadius(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    onTap: () {},
                    paddingRight: 10,
                    text: "Send code again",
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                  MyText(
                    text: "00:25",
                    size: 12,
                    weight: FontWeight.w400,
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
