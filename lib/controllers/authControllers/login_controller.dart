import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/core/global/functions.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/view/screens/bottom_nav_bar/b_nav_bar.dart';

import '../../core/bindings/bindings.dart';
import '../../core/constants/firebase_constants.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  rememberMeMethod(value) {
    isRememberMe.value = value;
  }

  Future loginMethod() async {
    UserCredential? userCredential;

    try {
      isLoading(true);

      userCredential = await FirebaseConstants.auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      print("userCredential = $userCredential");
      print("isRememberMe = $isRememberMe");
      if (userCredential.user!.uid.isNotEmpty) {
        await getUserDataStream(userId: userCredential.user!.uid);
        if (isRememberMe == true) {
          await SharedPreferenceService.instance.saveSharedPreferenceBool(
              key: SharedPrefKeys.loggedIn, value: isRememberMe.value);
        }
        CustomSnackBars.instance
            .customSnackBar(message: "Login Successfully", color: kGreenColor);
        Get.offAll(() => BNavBar(), binding: HomeBindings());
      }

      isLoading(false);
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      print("Error $e");
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Login Failed", message: e.message.toString());
    }
  }
}
