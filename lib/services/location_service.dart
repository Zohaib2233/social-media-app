import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/collections.dart';

class LocationService {
  LocationService._privateConstructor();

  static LocationService? _instance;

  static LocationService get instance {
    _instance ??= LocationService._privateConstructor();
    return _instance!;
  }

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

  //fetching all the nearby places
  void getNearbyUsers() async {
    try {
      //getting user's current location
      Position userLocation = await getCurrentLocation();

      // GeoPoint userGeoPoint = userModelGlobal.value.userActiveAddress['geopoint'] as GeoPoint;

      GeoPoint geoPoint =
          GeoPoint(userLocation.latitude, userLocation.longitude);
      final GeoFirePoint center = GeoFirePoint(geoPoint);

      // Detection range from the center point.
      const double radiusInKm = 50;

      ///
      ///  //creating geo point
      //     GeoFirePoint placeGeohash = geo.point(
      //         latitude: placeDetails.result.geometry != null
      //             ? placeDetails.result.geometry!.location.lat
      //             : 37.77483,
      //         longitude: placeDetails.result.geometry != null
      //             ? placeDetails.result.geometry!.location.lng
      //             : -122.41942);

// Field name of Cloud Firestore documents where the geohash is saved.
      const String field = 'userActiveAddress';

      // Function to get GeoPoint instance from Cloud Firestore document data.
      GeoPoint geopointFrom(Map<String, dynamic> data) =>
          (data[field] as Map<String, dynamic>)['geopoint'] as GeoPoint;

      // Streamed document snapshots of geo query under given conditions.
      final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
          GeoCollectionReference<Map<String, dynamic>>(usersCollection)
              .subscribeWithin(
        center: center,
        radiusInKm: radiusInKm,
        field: field,
        geopointFrom: geopointFrom,
      );
      List<UserModel> tempList = [];
      stream.listen((event) {
        tempList.clear();

        print("Near By Stream ----------");
        for (DocumentSnapshot doc in event) {
          UserModel userModel = UserModel.fromJson(doc);
          if (userModel.uid != userModelGlobal.value.uid &&
              !userModelGlobal.value.blockAccounts.contains(userModel.uid)) {
            tempList.add(UserModel.fromJson(doc));
          }
        }
        nearbyUsers.value = tempList;
      });

      ///

      // //center point for fetching the nearby places
      // GeoFirePoint centerPoint = geo.geopoint(
      //   latitude: userLocation.latitude,
      //   longitude: userLocation.longitude,
      // );

      // //for getting places snapshots
      // Stream<List<DocumentSnapshot>> nearbyPlacesStream =
      // radius.switchMap((rad) {
      //
      //   return geo.collection(collectionRef: usersCollection).within(
      //       center: centerPoint,
      //       radius: rad,
      //       field: 'geoHash',
      //       strictMode: true);
      // });
      //
      // //adding neaby places snapshots to reactive list
      // nearbyPlacesStream.listen((List<DocumentSnapshot> documentList) {
      //   //adding documents to nearbyPlaces list (binding stream)
      //   for (var doc in documentList) {
      //     nearbyPlaces.add(PlaceModel.fromJson(doc));
      //   }
      // });
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failure", message: '$e');
    }
  }
}
