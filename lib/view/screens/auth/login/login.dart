import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/authControllers/login_controller.dart';
import 'package:soical_media_app/core/utils/validators.dart';
import 'package:soical_media_app/view/screens/auth/fogot/forget_password.dart';
import 'package:soical_media_app/view/screens/auth/register/register.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../../../services/zego_service/zego_service.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginFormKey = GlobalKey<FormState>();
    var controller = Get.find<LoginController>();
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Stack(
        children: [
          Form(
            key: loginFormKey,
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: [
                  MyText(
                    textAlign: TextAlign.center,
                    text: "Welcome back!",
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                  MyText(
                    textAlign: TextAlign.center,
                    paddingTop: 7,
                    text: "Glad to see you again. Sign in with us.",
                    size: 12,
                    weight: FontWeight.w600,
                  ),
                  CustomTextField(
                    top: 22,
                    labelText: "Email address",
                    hintText: "youremail@gmail.com",
                    controller: controller.emailController,
                    validator: ValidationService.instance.emailValidator,
                  ),
                  CustomTextField(
                    top: 12,
                    labelText: "Password",
                    hintText: "**********",
                    validator: ValidationService.instance.validatePassword,
                    controller: controller.passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  // Check Box missing
                  //-------------------------------
                  Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Transform.scale(
                            scale: 0.9,
                            child: Obx(
                              () => CheckBoxWidget(
                                  isChecked: controller.isRememberMe.value,
                                  onChanged: (value) {
                                    controller.rememberMeMethod(value);
                                  }),
                            )),
                      ),
                      MyText(
                        paddingLeft: 10,
                        text: "Remember me",
                        size: 10,
                        weight: FontWeight.w600,
                      ),
                      Spacer(),
                      MyText(
                        onTap: () {
                          Get.to(ForgotPassword());
                        },
                        text: "Forgot Password?",
                        size: 10,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),

                  MyButton(
                      onTap: () async {
                        if (loginFormKey.currentState!.validate()) {
                          await controller.loginMethod();
                        }
                      },
                      mTop: 32,
                      mBottom: 16,
                      buttonText: "Log in"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        paddingRight: 10,
                        text: "Don’t have an Account?",
                        size: 12,
                        weight: FontWeight.w400,
                      ),
                      MyText(
                        onTap: () {
                          Get.to(Register());
                        },
                        text: "Sign up",
                        size: 12,
                        weight: FontWeight.w600,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),

                  // MyText(
                  //   textAlign: TextAlign.center,
                  //   paddingTop: 22,
                  //   paddingBottom: 16,
                  //   text: "or Sign in with",
                  //   size: 12,
                  //   weight: FontWeight.w500,
                  // ),
                  //
                  // MyButton(
                  //   onTap: () {},
                  //   buttonText: "Sign in with Google",
                  //   haveSvg: true,
                  //   svgIcon: Assets.imagesGoogleIcon,
                  //   backgroundColor: kTransperentColor,
                  //   fontColor: kBlackColor1,
                  //   outlineColor: kGreyColor3,
                  // ),
                ],
              ),
            ),
          ),
          Obx(() => controller.isLoading.value
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.grey.withOpacity(0.8),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container())
        ],
      ),
    );
  }
}
