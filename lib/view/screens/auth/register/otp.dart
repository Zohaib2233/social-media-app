import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_fonts.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/authControllers/signup_controller.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;
  OtpScreen(this.verificationId);
  SignupController signupController = Get.find();
  @override
  Widget build(BuildContext context) {
    signupController.startResendTimer();
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: true),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Phone Verification",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              paddingTop: 7,
              paddingBottom: 15,
              text: "We sent a code to your number",
              size: 12,
              weight: FontWeight.w600,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  paddingRight: 10,
                  text: "${signupController.combineNumber.value}",
                  size: 14,
                  weight: FontWeight.w600,
                ),

              ],
            ),
            SizedBox(height: 59),
            _OtpFields(onCodeChanged: (code) {}),
            SizedBox(height: 24),
            SizedBox(
              height: 50,
            ),
            Obx(
              () => MyButton(
                  isLoading: signupController.isLoading.value,
                  onTap: () async {
                    print(signupController.otpController.text);
                    await signupController.verifyCode(
                        verficationId: verificationId,
                        smsCode: signupController.otpController.text,
                        firstLogin: true);
                  },
                  buttonText: 'Verify'),
            ),
            SizedBox(height: 30,),
            Obx(()=>signupController.isResendEnable.isTrue?Center(
              child: TextButton( onPressed: (){
                            signupController.resendOTPOnPhone();
              },
                  child: MyText(
                    text: "Resend"),
            )):Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${signupController.resendCounter.value}"),
                  TextButton( onPressed: (){

                  },
                  child: MyText(
                    text: "Resend",color: Colors.grey,
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OtpFields extends StatelessWidget {
  final Function(dynamic)? onCodeChanged;
  _OtpFields({super.key, required this.onCodeChanged});
  SignupController signupController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: OtpTextField(
        margin: EdgeInsets.only(right: 10),
        numberOfFields: 6,
        onSubmit: (s) {
          signupController.otpController.text = s;
        },
        filled: false,
        fillColor: kTertiaryColor,
        borderColor: kSecondaryColor,
        enabledBorderColor: kSecondaryColor,
        focusedBorderColor: kSecondaryColor,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(6),
        showFieldAsBox: true,
        fieldWidth: 40,
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kBlackColor1,
            fontFamily: AppFonts.Poppins),
        onCodeChanged: onCodeChanged,
      ),
    );
  }
}
