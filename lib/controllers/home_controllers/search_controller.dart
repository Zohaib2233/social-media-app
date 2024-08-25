import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/models/user_model/follow_user_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/collections.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/location_service.dart';

class SearchScreenController extends GetxController {
  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<FollowedUserModel> followUserModels = <FollowedUserModel>[].obs;
  RxList<FollowedUserModel> searchResultList = <FollowedUserModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxBool updateList = true.obs;

  RxList<bool> listOfFollows = <bool>[].obs;
  RxBool showSearchResults = false.obs;

  @override
  void onInit() {
    print("SearchController ======== onInit");

    LocationService.instance.getNearbyUsers();
    // TODO: implement onInit
    super.onInit();


    getAllUsers();
  }


  getAllUsers() {
    print("Called getAllUsers----------------");
    List<FollowedUserModel> tempList = [];
    List<UserModel> tempUserList = [];
    usersCollection.snapshots().listen((events) async {
      tempList.clear();
      tempUserList.clear();

      for (DocumentSnapshot<Map<String, dynamic>> user in events.docs) {

        UserModel userModel = UserModel.fromJson(user);
        if(userModel.uid!=userModelGlobal.value.uid){

          print("Search User $userModel");
          tempUserList.add(UserModel.fromJson(user));
          bool isFollow = await FirebaseCRUDServices.instance
              .isUserFollowed(otherUserId: userModel.uid);
          tempList.add(FollowedUserModel(user: userModel, isFollowed: isFollow));
        }


      }

      followUserModels.assignAll(tempList);
      userModels.assignAll(tempUserList);

    });

  }

  searchUsers() {
    for(FollowedUserModel userModel in followUserModels){
      print(userModel.toJson());
    }
    List<FollowedUserModel> temp = [];
    searchResultList.clear();
    if (searchController.value.text.isEmpty) {

      print("Search controller is Empty");
      showSearchResults.value = false;
      temp.addAll(followUserModels);
    } else {
      temp.clear();
      showSearchResults.value = true;
      temp.addAll(followUserModels
          .where((users) => users.user.name
              .toLowerCase()
              .contains(searchController.value.text.toLowerCase()))
          .toList());
      searchResultList.value = temp;
    }
  }
}
