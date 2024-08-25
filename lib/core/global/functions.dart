import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/services/local_notification_service.dart';

import '../../models/user_model/user_model.dart';
import 'instance_variables.dart';

Future<Position> getCurrentLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    print("--------------------------- permission === $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();


  } catch (e) {
    print('Error getting current location: $e');
    rethrow; // Rethrow the exception for handling at the caller's level
  }
}

updateUserCurrentLocation({required String userId}) async {
  print("-----------------------updateUserCurrentLocation--------------");
  final Position position = await getCurrentLocation();
  // Define GeoFirePoint by instantiating GeoFirePoint with latitude and longitude.



  final GeoFirePoint geoFirePoint =
      GeoFirePoint(GeoPoint(position.latitude, position.longitude));


  print("------------------- geoFirePoint ${geoFirePoint}");

  await FirebaseCRUDServices.instance.updateDocument(
      collectionPath: FirebaseConstants.userCollection,
      docId: userId,
      data: {'userActiveAddress': geoFirePoint.data});
}

Future<void> getUserDataStream({required String userId}) async {
  //getting user's data stream

  print("*****************Get Stream Data**************");

  await FirebaseFirestore.instance
      .collection(FirebaseConstants.userCollection)
      .doc(userId)
      .snapshots()
      .listen((event) {
    print(event);

    //binding that user's data stream into an observable UserModel object

    userModelGlobal.value = UserModel.fromJson(event);

    // log("User first name from model is: ${userModel.value.firstName}");
  });

  String token = await LocalNotificationService.instance.getDeviceToken()??'';

  await  FirebaseFirestore.instance
      .collection(FirebaseConstants.userCollection)
      .doc(userId).update({
    'deviceTokenID': token
  });
}
