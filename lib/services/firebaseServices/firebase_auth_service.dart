import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';

import '../../core/utils/snackbar.dart';
import '../../core/utils/utils.dart';

class FirebaseAuthService{

  FirebaseAuthService._privateConstructor();

  //singleton instance variable
  static FirebaseAuthService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to ValidationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static FirebaseAuthService get instance {
    _instance ??= FirebaseAuthService._privateConstructor();
    return _instance!;
  }

  //signing up user with email and password
  Future<User?> signUpUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {

      await FirebaseConstants.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        return user;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } catch (e) {
      log("This was the exception while signing up: $e");

      return null;
    }

    return null;
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Done", message: "Account Deleted Suucessfully", );
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      throw Exception(e);

      // Handle general exception
    }
  }
  Future<void> _reauthenticateAndDelete() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      final providerData = currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await currentUser?.delete();
      CustomSnackBars.instance.showSuccessSnackbar(
          title: "Done", message: "Account Deleted Suucessfully");
    } catch (e) {
      // Handle exceptions
    }
  }


//method to check if the user's account already exists on firebase
  // Future<bool> isAlreadyExist({required String uid}) async {
  //   bool isExist = await FirebaseCRUDService.instance
  //       .isDocExist(collectionReference: usersCollection, docId: uid);
  //
  //   return isExist;
  // }


}