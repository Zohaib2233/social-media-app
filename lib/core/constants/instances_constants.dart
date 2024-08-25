// global model of user

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';




class UserGlobalCtrl extends GetxController {
  //SignUpController globalCtrl = Get.put(SignUpController());
  // --------------------- UserModel ---------------------



  // --------------------- Get User Model From FireStore ---------------------

  // Future<void> fetchUserData({required String userId}) async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('usersInfo')
  //         .doc(userId)
  //         .get()
  //         .then((DocumentSnapshot documentSnapshot) {
  //       if (documentSnapshot.exists) {
  //         log('doc Data Exists');
  //
  //         final Map<String, dynamic> data =
  //             documentSnapshot.data() as Map<String, dynamic>;
  //         userModel.value = UserModel.fromJson(data);
  //
  //         log(userModel.value.email);
  //         // userData = documentSnapshot.data() as Map<String, dynamic>;
  //
  //         // = documentSnapshot.data() as Map<String, dynamic>;
  //
  //         log('--------------------');
  //         log('${userModel}');
  //       } else {
  //         log('No Data Exists');
  //       }
  //     });
  //   } catch (e) {
  //     log('error $e');
  //   }
  // }
}
