import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/collections.dart';

import '../../core/utils/app_strings.dart';
import '../../core/utils/snackbar.dart';
import '../../models/notifications/notification_model.dart';

class FirebaseCRUDServices {
  FirebaseCRUDServices._privateConstructor();

  //singleton instance variable
  static FirebaseCRUDServices? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to FirebaseCRUDService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static FirebaseCRUDServices get instance {
    _instance ??= FirebaseCRUDServices._privateConstructor();
    return _instance!;
  }

  /// check if the document exists in Firestore
  Future<bool> isDocExistByUsername(
      {required String collectionString, required String username}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(FirebaseConstants.userCollection)
              .where('username', isEqualTo: username)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    } catch (e) {
      log("This was the exception while reading document from Firestore: $e");

      return false;
    }
  }

  Stream<List<UserModel>> readAllUserDoc() {
    List<UserModel> userModels = [];
    // QuerySnapshot<Map<String,dynamic>> snapshots = await FirebaseConstants.fireStore
    //     .collection(FirebaseConstants.userCollection)
    //     .get();
    //
    // for(DocumentSnapshot snapshot in snapshots.docs){
    //   userModels.add(UserModel.fromJson(snapshot));
    //
    // }
    print("==========readAllUserDoc=========");

    return usersCollection.snapshots().map((snapshots) {
      return snapshots.docs.map((e) => UserModel.fromJson(e)).toList();
    });
    // return userModels;
  }

  /// Update Document
  Future<bool> updateDocument(
      {required String collectionPath,
      required String docId,
      required Map<String, dynamic> data}) async {
    try {
      await FirebaseConstants.fireStore
          .collection(collectionPath)
          .doc(docId)
          .update(data);

      return true;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  Future<bool> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await FirebaseConstants.fireStore
          .collection(collectionPath)
          .doc(docId)
          .delete();

      return true;
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
      return false;
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
      return false;
    }
  }

  Future connectToFriend({required String otherUserId}) async {
    try {
      bool isFollowed = await isUserFollowed(otherUserId: otherUserId);

      if (isFollowed) {
        await usersCollection
            .doc(userModelGlobal.value.uid)
            .collection(FirebaseConstants.followingCollection)
            .doc(otherUserId)
            .delete();

        await usersCollection
            .doc(otherUserId)
            .collection(FirebaseConstants.followersCollection)
            .doc(userModelGlobal.value.uid)
            .delete();

        await updateDocument(
            collectionPath: FirebaseConstants.userCollection,
            docId: userModelGlobal.value.uid,
            data: {'followingCount': FieldValue.increment(-1)});

        await updateDocument(
            collectionPath: FirebaseConstants.userCollection,
            docId: otherUserId,
            data: {'followerCount': FieldValue.increment(-1)});
      } else {
        await usersCollection
            .doc(userModelGlobal.value.uid)
            .collection(FirebaseConstants.followingCollection)
            .doc(otherUserId)
            .set({'followingFrom': DateTime.now()});

        await usersCollection
            .doc(otherUserId)
            .collection(FirebaseConstants.followersCollection)
            .doc(userModelGlobal.value.uid)
            .set({'followedFrom': DateTime.now()});

        await updateDocument(
            collectionPath: FirebaseConstants.userCollection,
            docId: userModelGlobal.value.uid,
            data: {'followingCount': FieldValue.increment(1)});

        await updateDocument(
            collectionPath: FirebaseConstants.userCollection,
            docId: otherUserId,
            data: {'followerCount': FieldValue.increment(1)});
      }
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
    }
  }

  Future acceptFollowRequest(
      {required String fromUserId, required toUserId}) async {
    log('From User Id :$fromUserId ');
    log('My User Id : $toUserId');
    try {
      await usersCollection
          .doc(fromUserId)
          .collection(FirebaseConstants.followingCollection)
          .doc(toUserId)
          .set({'followingFrom': DateTime.now()});

      await usersCollection
          .doc(toUserId)
          .collection(FirebaseConstants.followersCollection)
          .doc(fromUserId)
          .set({'followedFrom': DateTime.now()});

      await updateDocument(
          collectionPath: FirebaseConstants.userCollection,
          docId: fromUserId,
          data: {'followingCount': FieldValue.increment(1)});

      await updateDocument(
          collectionPath: FirebaseConstants.userCollection,
          docId: toUserId,
          data: {'followerCount': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);

      //returning false to indicate that the document was not created
    } catch (e) {
      print("This was the exception while updating document on Firestore: $e");

      //returning false to indicate that the document was not created
    }
  }

  Future<bool> isUserFollowed({required String otherUserId}) async {
    DocumentSnapshot<Map<String, dynamic>> document = await usersCollection
        .doc(userModelGlobal.value.uid)
        .collection(FirebaseConstants.followingCollection)
        .doc(otherUserId)
        .get();
    return document.exists;
  }

  /* --------- Notifications -------------------*/

  Future saveNotificationToFirestore(
      {required String title,
      required String body,
      required String sentBy,
      required String sentTo,
      required String type,
      DateTime? time,
      DateTime? date}) async {
    try {
      DocumentReference reference =
          FirebaseFirestore.instance.collection('notifications').doc();

      print("**********************reference $reference");

      await reference.set(NotificationModel(
              title: title,
              body: body,
              sentBy: sentBy,
              sentTo: sentTo,
              type: type,
              time: time,
              date: date,
              notId: reference.id)
          .toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotifications(userId) {
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.notificationCollection)
        .where(Filter.and(Filter('sentTo', isEqualTo: userId),
            Filter('type', isNotEqualTo: AppStrings.notificationMessage)))
        // .where('sentTo', isEqualTo: userId).where('type',isNotEqualTo: AppStrings.notificationMessage)
        .orderBy('time', descending: true)
        .snapshots();
  }

  blockUser({required String otherUserId}) async {
    usersCollection.doc(userModelGlobal.value.uid).update({
      'blockAccounts': FieldValue.arrayUnion([otherUserId])
    });

    usersCollection.doc(otherUserId).update({
      'blockAccounts': FieldValue.arrayUnion([userModelGlobal.value.uid])
    });

    // if (await isUserFollowed(otherUserId: otherUserId)) {
    //   connectToFriend(otherUserId: otherUserId);
    // }

    print("User Blocked");
  }

  unBlockUser({required String otherUserId}) {
    usersCollection.doc(userModelGlobal.value.uid).update({
      'blockAccounts': FieldValue.arrayRemove([otherUserId])
    });
    usersCollection.doc(otherUserId).update({
      'blockAccounts': FieldValue.arrayRemove([userModelGlobal.value.uid])
    });
  }

  Future<List<QueryDocumentSnapshot>?> readAllDoc({
    required CollectionReference collectionReference,
    bool isWithLimit = false,
    int limit = 0,
  }) async {
    try {
      QuerySnapshot documentSnapshot;

      if (isWithLimit) {
        documentSnapshot = await collectionReference.limit(limit).get();
      } else {
        documentSnapshot = await collectionReference.get();
      }

      if (documentSnapshot.docs.isNotEmpty) {
        return documentSnapshot.docs;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      //getting firebase error message
      final errorMessage = getFirestoreErrorMessage(e);

      //showing failure snackbar
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e) {
      log("This was the exception while reading document from Firestore: $e");
      return null;
    }
  }

  Future<dynamic> readDocumentSingleKey({
    required CollectionReference collectionReference,
    required String documentId,
    required String key,
  }) async {
    DocumentSnapshot _documentSnapshot =
        await collectionReference.doc(documentId).get();
    if (_documentSnapshot.exists) {
      Map<String, dynamic> data =
          _documentSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey(key)) {
        return data['$key'] ?? [];
      }
      return [];
    }
  }

  /// Method to get a user-friendly message from FirebaseException
  String getFirestoreErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'unknown':
        return 'An unknown error occurred.';
      case 'invalid-argument':
        return 'Invalid argument provided.';
      case 'deadline-exceeded':
        return 'The deadline was exceeded, please try again.';
      case 'not-found':
        return 'Requested document was not found.';
      case 'already-exists':
        return 'The document already exists.';
      case 'permission-denied':
        return 'You do not have permission to execute this operation.';
      case 'resource-exhausted':
        return 'Resource limit has been exceeded.';
      case 'failed-precondition':
        return 'The operation failed due to a precondition.';
      case 'aborted':
        return 'The operation was aborted, please try again.';
      case 'out-of-range':
        return 'The operation was out of range.';
      case 'unimplemented':
        return 'This operation is not implemented or supported yet.';
      case 'internal':
        return 'Internal error occurred.';
      case 'unavailable':
        return 'The service is currently unavailable, please try again later.';
      case 'data-loss':
        return 'Data loss occurred, please try again.';
      case 'unauthenticated':
        return 'You are not authenticated, please login and try again.';
      default:
        return 'An unexpected error occurred, please try again.';
    }
  }
}
