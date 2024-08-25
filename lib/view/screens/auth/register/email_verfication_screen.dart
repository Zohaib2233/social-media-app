import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/view/screens/bottom_nav_bar/b_nav_bar.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../controllers/authControllers/signup_controller.dart';
import '../../../widget/my_text_widget.dart';


class EmailVerificationScreen extends StatelessWidget {
   EmailVerificationScreen({super.key});
  final controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<SignupController>();
    // var controller = Get.put<SignupController>(SignupController());
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: MyButton(
          mBottom: 20,
          onTap: () async {
            print("Current User = ${FirebaseAuth.instance.currentUser}");
            if(FirebaseAuth.instance.currentUser!=null){
              await FirebaseAuth.instance.currentUser!.reload();
              if(FirebaseAuth.instance.currentUser?.emailVerified??false){
                Get.offAll(BNavBar(),binding: HomeBindings());
              }
              else{
                CustomSnackBars.instance.showFailureSnackbar(title: "Failed", message: "Email not verified");
              }
            }

        
          }, buttonText: 'Continue',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          // padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
          // physics: BouncingScrollPhysics(),
          children: [
            MyText(
              text: 'Please verify your email using the link sent on  ',
              size: 12,
              weight: FontWeight.w500,
              textAlign: TextAlign.center,
              paddingBottom: 20,
            ),
            Obx(
                  () => MyText(
                text: userModelGlobal.value.email,
                color: kBlackColor1,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
                paddingBottom: 20,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                MyText(
                  text: 'Didn\'t receive link? ',
                  size: 12,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: 'Send again',
                  size: 12,
                  color: kSecondaryColor,
                  weight: FontWeight.w700,
                  onTap: () async {
                    controller.sendVerificationLinkAgain();
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
