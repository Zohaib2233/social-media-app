import 'package:get/get.dart';

import '../../models/user_model/user_model.dart';

Rx<UserModel> userModelGlobal = UserModel(
  isDarkTheme: false,
  name: '',
  username: '',
  email: '',
  dob: '',
  uid: '',
  profilePicture: '',
  deviceTokenID: '',
  bio: '',
  followerCount: 0,
  followingCount: 0,
  joinAt: DateTime.now(),
  activeNow: false,
  coverPhoto: '',
  blockAccounts: [],
  notificationOn: false,
  mentionTags: '',
  // isPublic: false,
  // isOfficialVerified: false,
  location: '',
  lastSeen: DateTime.now(),
  loginWith: '',
  phoneNo: '',
  isOfficialVerified: false,
  bookmarked: [],
  userActiveAddress: {},
  isPrivate: false,
).obs;

RxList<UserModel> nearbyUsers = <UserModel>[].obs;
