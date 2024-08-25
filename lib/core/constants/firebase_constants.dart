import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConstants {
  static const String userCollection = 'users';
  static const String postsCollection = 'posts';
  static const String postDataCollection = 'postData';
  static const String followingCollection = 'following';
  static const String followersCollection = 'followers';

  static const String chatRoomsCollection = 'chatRooms';
  static const String messagesCollection = 'messages';
  static const String notificationCollection = 'notifications';
  static const String followRequestsCollection = 'followRequests';

  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
}
