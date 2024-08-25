import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/core/utils/utils.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';

import '../../core/bindings/bindings.dart';
import '../../core/global/functions.dart';
import '../../core/utils/snackbar.dart';
import '../../services/collections.dart';
import '../../view/screens/auth/register/otp.dart';
import '../../view/screens/bottom_nav_bar/b_nav_bar.dart';

class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Rx<TextEditingController> dobController = TextEditingController().obs;
  TextEditingController passwordController = TextEditingController();
  TextEditingController againPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  RxString codeVerificationId = ''.obs;

  RxString combineNumber = ''.obs;

  RxBool isLoading = false.obs;

  RxBool isCheck = false.obs;

  RxInt resendCounter = 60.obs;

  RxBool isResendEnable = false.obs;

  Timer? _resendTimer;

  startResendTimer() {
    isResendEnable(false);

    resendCounter.value = 60;

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCounter.value > 0) {
        resendCounter.value--;
      } else {
        isResendEnable(true);
        _resendTimer?.cancel();
      }
    });
  }

  checkIfUsernameExists({required userName}) async {
    var isFound =
        await usersCollection.where('username', isEqualTo: userName).get();
    if (isFound.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkIfPhoneNoExists() async {
    var isFound = await usersCollection
        .where('phoneNo', isEqualTo: combineNumber.value)
        .get();
    if (isFound.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  selectDob(BuildContext context) async {
    dobController.value.text = await Utils.createDatePicker(context);
  }

  combinePhoneNumber(PhoneNumber number) {
    phoneController.text = number.number ?? '';
    combineNumber.value = '${number.countryCode} ${number.number}';
    print(combineNumber.value);
  }

  registerUser() async {
    if (isCheck.value == false) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Checkbox", message: "Please Select checkbox");
    } else if (combineNumber.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "PhoneNumber required", message: "Please Enter Phone Number");
    } else {
      isLoading(true);
      try {
        // final credential = EmailAuthProvider.credential(
        //     email: emailController.text, password: passwordController.text);
        // UserCredential? creds = await FirebaseAuth.instance.currentUser!
        //     .linkWithCredential(credential);

        UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        User? firebaseUser = creds.user;
        if (firebaseUser != null) {

          DocumentReference reference = FirebaseConstants.fireStore
              .collection(FirebaseConstants.userCollection)
              .doc(firebaseUser.uid);
          final locationPosition = await getCurrentLocation();
          // Define GeoFirePoint by instantiating GeoFirePoint with latitude and longitude.
          final GeoFirePoint geoFirePoint = GeoFirePoint(
              GeoPoint(locationPosition.latitude, locationPosition.longitude));

          await reference.set(UserModel(
            isDarkTheme: false,
            phoneNo: combineNumber.value,
            name: nameController.text,
            email: emailController.text,
            dob: dobController.value.text,
            uid: reference.id,
            profilePicture: dummyProfile,
            deviceTokenID: '',
            bio: '',
            followerCount: 0,
            followingCount: 0,
            joinAt: DateTime.now(),
            activeNow: true,
            coverPhoto: dummyCoverImage,
            blockAccounts: [],
            notificationOn: true,
            mentionTags: '',
            location: '',
            lastSeen: DateTime.now(),
            loginWith: 'email',
            username: userNameController.text,
            isOfficialVerified: false,
            bookmarked: [],
            userActiveAddress: geoFirePoint.data,
            isPrivate: false,
          ).toJson());

          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          SharedPreferenceService.instance.saveSharedPreferenceBool(key: SharedPrefKeys.loggedIn, value: true);

          CustomSnackBars.instance.showSuccessSnackbar(title: "Success", message: "Email Verification Sent");
        }
        isLoading(false);
        return true;
      } catch (e) {
        return false;
      }
    }
  }

  sendVerificationLinkAgain() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        CustomSnackBars.instance.showSuccessSnackbar(
            title: 'Email Sent'
            , message: 'An email has been sent to your email. Kindly verify your email');
      } on FirebaseAuthException catch (e) {
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error',
            message: 'Please wait for some time to resend your email');
        // Utils.showFailureSnackbar(title: 'Error', msg: e.message.toString());
      }
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Auth Error',
          message: "You have to sign up again due to an error",
          );
    }
  }

  var smsCode;

  resendOTPOnPhone() async {
    try {
      startResendTimer();
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber:
            '${combineNumber.value.split(' ')[0]}${combineNumber.value.split(' ')[1]}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          print('Verification failed: ${e.message}');
          isLoading(false);
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          codeVerificationId.value = verificationId;
          // Handle code sent to the user's phone
          print("Code send Again  = $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout

          print('Code auto-retrieval timeout');
        },
      );
    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.message!);
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.toString());
    }
  }

  sendOTPOnPhone() async {
    isLoading(true);
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber:
            '${combineNumber.value.split(' ')[0]}${combineNumber.value.split(' ')[1]}',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
          print('Verification failed: ${e.message}');
          isLoading(false);
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          codeVerificationId.value = verificationId;
          // Handle code sent to the user's phone
          print(verificationId);
          isLoading(false);
          Get.to(() => OtpScreen(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
          isLoading(false);

          print('Code auto-retrieval timeout');
        },
      );
    } on FirebaseException catch (e) {
      isLoading(false);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.message!);
    } catch (e) {
      isLoading(false);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.toString());
    }
  }

  Future verifyCode(
      {required verficationId,
      required smsCode,
      required bool firstLogin}) async {
    isLoading(true);
    try {
      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: codeVerificationId.value, smsCode: smsCode));
      if (FirebaseAuth.instance.currentUser != null && firstLogin == true) {
        var isRegistered = await registerUser();
        isLoading(false);
        if (isRegistered) {
          await getUserDataStream(
              userId: FirebaseAuth.instance.currentUser!.uid);
          Get.offAll(() => BNavBar(), binding: HomeBindings());
        }
      }
    } on FirebaseException catch (e) {
      isLoading(false);
      log(e.message!);
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.message!);
    } catch (e) {
      isLoading(false);
      log(e.toString());
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: e.toString());
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.value.dispose();
    passwordController.dispose();
    againPasswordController.dispose();
  }
}
