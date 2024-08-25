import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/authControllers/signup_controller.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/core/utils/validators.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/screens/auth/register/email_verfication_screen.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/intel_phone_field_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../../../core/global/functions.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> signupFormKey = GlobalKey();
    var controller = Get.find<SignupController>();

    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Form(
        key: signupFormKey,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              MyText(
                textAlign: TextAlign.center,
                text: "Sign-up today",
                size: 18,
                weight: FontWeight.w600,
              ),
              MyText(
                textAlign: TextAlign.center,
                paddingTop: 7,
                text: "Provide us your credentials to start journey",
                size: 12,
                weight: FontWeight.w600,
              ),
              CustomTextField(
                top: 22,
                labelText: "Name",
                hintText: "yourname",
                controller: controller.nameController,
                validator: ValidationService.instance.emptyValidator,
              ),
              CustomTextField(
                top: 22,
                labelText: "UserName",
                hintText: "username",
                controller: controller.userNameController,
                validator: ValidationService.instance.userNameValidator,
              ),
              CustomTextField(
                top: 12,
                labelText: "Email address",
                hintText: "youremail@gmail.com",
                controller: controller.emailController,
                validator: ValidationService.instance.emailValidator,
              ),
              // Phone Number

              IntlPhoneFieldWidget(
                validator: (value) {
                  print(value);
                  // return ValidationService.instance.emptyValidator(value);
                },
                controller: controller.phoneController,
                onSubmitted: (value) {
                  controller.combinePhoneNumber(value);
                  print("Value ${value.completeNumber}");
                },
              ),
              GestureDetector(
                onTap: () async {
                  await controller.selectDob(context);
                },
                child: CustomTextField(
                  enabled: false,
                  top: 0,
                  labelText: "Date of birth",
                  controller: controller.dobController.value,
                  validator: ValidationService.instance.emptyValidator,
                  hintText: "dd/mm/yy",
                ),
              ),
              CustomTextField(
                obscureText: true,
                top: 12,
                labelText: "Password",
                controller: controller.passwordController,
                hintText: "************",
                validator: ValidationService.instance.validatePassword,
              ),
              CustomTextField(
                  obscureText: true,
                  top: 12,
                  labelText: "Re-enter password",
                  hintText: "************",
                  controller: controller.againPasswordController,
                  validator: (value) {
                    return ValidationService.instance.validateMatchPassword(
                        controller.againPasswordController.text,
                        controller.passwordController.text);
                  }),
              SizedBox(height: 11),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    child: Transform.scale(
                        scale: 0.9,
                        child: Obx(
                          () => CheckBoxWidget(
                              isChecked: controller.isCheck.value,
                              onChanged: (value) {
                                print(value);
                                controller.isCheck.value = value!;
                                print(controller.isCheck.value);
                              }),
                        )),
                  ),
                  SizedBox(width: 10),
                  MyText(
                    text:
                        "I agree to the all Terms of Service and Privacy Policy",
                    size: 10,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              Obx(
                () => MyButton(
                    isLoading: controller.isLoading.value,
                    onTap: () async {
                      if (signupFormKey.currentState!.validate()) {
                        bool phoneNoExist = await controller.checkIfPhoneNoExists();
                        var isFound = await controller.checkIfUsernameExists(
                            userName: controller.userNameController.text);
                        if (!isFound && !phoneNoExist) {
                          // await controller.sendOTPOnPhone();

                          bool userRegistered = await controller.registerUser();

                          if(userRegistered){
                           getUserDataStream(
                                userId: FirebaseAuth.instance.currentUser!.uid);
                           Get.offAll(()=>EmailVerificationScreen());
                          }
                        } else if(isFound) {
                          CustomSnackBars.instance.showFailureSnackbar(
                              title: "Username already Exists",
                              message: "Please change username");
                        }
                        else if(phoneNoExist){
                          CustomSnackBars.instance.showFailureSnackbar(
                              title: "PhoneNo already Exists",
                              message: "Please change phone no");
                        }
                      }
                    },
                    mTop: 32,
                    mBottom: 16,
                    buttonText: "Sign up"),
              ),
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
                      Get.to(Login());
                    },
                    text: "Sign in",
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
    );
  }
}
