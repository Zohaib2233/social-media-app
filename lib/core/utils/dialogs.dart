import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/view/widget/my_button.dart';

import '../../services/firebaseServices/firebase_auth_service.dart';
import '../../view/screens/auth/login/login.dart';

class DeleteAccountDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Delete Account'),
      content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
      actions: <Widget>[
        MyButton(
          onTap: () {
            Navigator.of(context)
                .pop(false); // Dismiss the dialog and return false
          },
          buttonText: 'Cancel',
        ),
        SizedBox(
          height: 30,
        ),
        MyButton(
          backgroundColor: Colors.red,
          onTap: () {
            // Perform delete account operation here
            // Once done, you can close the dialog and maybe navigate to a login screen or exit the app
            Navigator.of(context)
                .pop(true);


            FirebaseAuthService.instance.deleteUserAccount().then((value){
              SharedPreferenceService.instance.removeSharedPreferenceBool(SharedPrefKeys.loggedIn);
              Get.offAll(()=>Login());
            });// Dismiss the dialog and return true
          },
          buttonText: 'Delete',
        ),
      ],
    );
  }
}