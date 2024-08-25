import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/models/request_model/follow_request_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';

class NotificationController extends GetxController {
  var followRequests = <FollowRequestModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> getFollowRequests() async {
    List<FollowRequestModel> _newRequest = [];
    final snapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .doc(userModelGlobal.value.uid)
        .collection(FirebaseConstants.followRequestsCollection)
        .orderBy('dateRequested', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      log(snapshot.docs.length.toString());
      snapshot.docs.forEach(
        (doc) async {
          final fromUserId = doc['fromUserId'];
          final dateRequested = doc['dateRequested'].toDate();
          DocumentSnapshot userSnapshot =
              await usersCollection.doc(fromUserId).get();
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          final FollowRequestModel request = FollowRequestModel(
            requestId: doc.id,
            fromUserId: fromUserId,
            fromUserName: userData['name'],
            fromUserProfileImage: userData['profilePicture'],
            dateRequested: dateRequested,
          );
          _newRequest.add(request);
        },
      );
    }
    followRequests.value = _newRequest;
  }

  Future<void> acceptFollowRequest(String fromUserId, String requestId) async {
    await FirebaseCRUDServices.instance.acceptFollowRequest(
        fromUserId: fromUserId, toUserId: userModelGlobal.value.uid);
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .doc(userModelGlobal.value.uid)
        .collection(FirebaseConstants.followRequestsCollection)
        .doc(requestId)
        .delete();
    await getFollowRequests();
  }

  Future<void> rejectFollowRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.userCollection)
        .doc(userModelGlobal.value.uid)
        .collection(FirebaseConstants.followRequestsCollection)
        .doc(requestId)
        .delete();
    await getFollowRequests();
  }
}
