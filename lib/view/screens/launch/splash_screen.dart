import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/services/zego_service/zego_service.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/screens/auth/register/email_verfication_screen.dart';
import 'package:soical_media_app/view/screens/bottom_nav_bar/b_nav_bar.dart';
import 'package:soical_media_app/view/screens/onboarding/onboarding.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';

import '../../../controllers/authControllers/login_controller.dart';
import '../../../controllers/authControllers/signup_controller.dart';
import '../../../core/bindings/bindings.dart';
import '../../../core/global/functions.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  void splashScreenHandler() async {
    bool onBoardingComplete = await SharedPreferenceService.instance
            .getSharedPreferenceBool(SharedPrefKeys.completeOnboarding) ??
        false;
    bool loggedIn = await SharedPreferenceService.instance
            .getSharedPreferenceBool(SharedPrefKeys.loggedIn) ??
        false;

    print("$onBoardingComplete   $loggedIn");

    if (onBoardingComplete && loggedIn) {
      bool emailVerified = await FirebaseAuth.instance.currentUser?.emailVerified??false;
      if(emailVerified){
        Timer(
          Duration(seconds: 2),
              () => Get.offAll(() => BNavBar(), binding: HomeBindings()),
        );
        Get.delete<SignupController>();
        Get.delete<LoginController>();
        print("      getUserDataStream(userId: FirebaseConstants.auth.currentUser!.uid); ${FirebaseConstants.auth.currentUser?.uid}");
        await getUserDataStream(userId: FirebaseConstants.auth.currentUser!.uid);
      }else{
        Timer(
          Duration(seconds: 2),
              () => Get.offAll(() => EmailVerificationScreen()),
        );
      }

      // ZegoService.onUserLogin();
      // updateUserCurrentLocation(userId: FirebaseConstants.auth.currentUser!.uid);
    } else if (onBoardingComplete) {
      Timer(
        Duration(seconds: 2),
        () => Get.offAll(() => Login()),
      );
    } else {
      Timer(
        Duration(seconds: 2),
        () => Get.offAll(() => OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CommonImageView(
        svgPath: Assets.imagesLogoVerticalWithText,
      ),
    ));
  }
}
