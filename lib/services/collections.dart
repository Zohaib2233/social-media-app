import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soical_media_app/core/constants/firebase_constants.dart';

final usersCollection =
    FirebaseFirestore.instance.collection(FirebaseConstants.userCollection);
final postsCollection =
    FirebaseFirestore.instance.collection(FirebaseConstants.postsCollection);
