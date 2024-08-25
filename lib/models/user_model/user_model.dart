import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';

class UserModel {
  final String name;
  final String email;
  final String phoneNo;
  final String dob;
  final String uid;
  final String profilePicture;
  final String deviceTokenID; // Add deviceTokenID field
  final String bio;
  final int followerCount;
  final int followingCount;
  final DateTime joinAt;
  final bool activeNow;
  final bool isDarkTheme;
  final bool isOfficialVerified;
  final String coverPhoto;
  final List blockAccounts;
  final bool notificationOn;
  final String mentionTags;
  final String location;
  final DateTime lastSeen;
  final String loginWith;
  final String username;
  final List bookmarked;
  final Map<String, dynamic> userActiveAddress;
  final bool isPrivate;

  // Constructor
  UserModel({
    required this.name,
    required this.bookmarked,
    required this.email,
    required this.phoneNo,
    required this.dob,
    required this.uid,
    required this.isOfficialVerified,
    required this.profilePicture,
    required this.deviceTokenID, // Add deviceTokenID parameter
    required this.bio,
    required this.followerCount,
    required this.followingCount,
    required this.joinAt,
    required this.activeNow,
    required this.coverPhoto,
    required this.blockAccounts,
    required this.notificationOn,
    required this.mentionTags,
    required this.location,
    required this.lastSeen,
    required this.loginWith,
    required this.username,
    required this.userActiveAddress,
    required this.isPrivate,
    required this.isDarkTheme,
  });

  // Factory methods to create UserModel from JSON
  factory UserModel.fromJson(DocumentSnapshot json) {
    Map<String, dynamic> data = json.data() as Map<String, dynamic>;
    return UserModel(
      phoneNo: json['phoneNo'],
      bookmarked: json['bookmarked'],
      name: json['name'] ?? '',
      email: json['email'],
      isOfficialVerified: json['isOfficialVerified'],
      dob: json['dob'],
      uid: json['uid'],
      profilePicture: json['profilePicture'],
      deviceTokenID: json['deviceTokenID'], // Parse deviceTokenID from JSON
      bio: json['bio'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      joinAt: json['joinAt'].toDate(),
      activeNow: json['activeNow'],
      coverPhoto: json['coverPhoto'],
      blockAccounts: List.from(json['blockAccounts']),
      notificationOn: json['notificationOn'],
      mentionTags: json['mentionTags'],
      location: json['location'],
      lastSeen: json['lastSeen'].toDate(),
      loginWith: json['loginWith'],
      username: json['username'] ?? '',
      userActiveAddress: data.containsKey('userActiveAddress')
          ? data['userActiveAddress']
          : {},
      isPrivate: json['isPrivate'] ?? false,
      isDarkTheme: data.containsKey('isDarkTheme')? json['isDarkTheme'] : false,
    );
  }

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
      phoneNo: json['phoneNo'],
      bookmarked: json['bookmarked'],
      name: json['name'] ?? '',
      email: json['email'],
      isOfficialVerified: json['isOfficialVerified'],
      dob: json['dob'],
      isDarkTheme: json.containsKey("isDarkTheme")?json['isDarkTheme']:false,
      uid: json['uid'],
      profilePicture: json['profilePicture'],
      deviceTokenID: json['deviceTokenID'], // Parse deviceTokenID from JSON
      bio: json['bio'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      joinAt: json['joinAt'].toDate(),
      activeNow: json['activeNow'],
      coverPhoto:
          json['coverPhoto'] == '' ? dummyCoverImage : json['coverPhoto'],
      blockAccounts: List.from(json['blockAccounts']),
      notificationOn: json['notificationOn'],
      mentionTags: json['mentionTags'],
      location: json['location'],
      lastSeen: json['lastSeen'].toDate(),
      loginWith: json['loginWith'],
      username: json['username'] ?? '',
      userActiveAddress: json['userActiveAddress'] ?? {},
      isPrivate: json['isPrivate'] ?? false,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'bookmarked': bookmarked,
      'phoneNo': phoneNo,
      'dob': dob,
      'isOfficialVerified': isOfficialVerified,
      'uid': uid,
      'profilePicture': profilePicture,
      'deviceTokenID': deviceTokenID, // Include deviceTokenID in JSON
      'bio': bio,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'joinAt': joinAt,
      'activeNow': activeNow,
      'coverPhoto': coverPhoto,
      'blockAccounts': blockAccounts,
      'notificationOn': notificationOn,
      'mentionTags': mentionTags,
      'location': location,
      'lastSeen': lastSeen,
      'loginWith': loginWith,
      'username': username,
      'userActiveAddress': userActiveAddress,
      'isPrivate': isPrivate,
      'isDarkTheme': isDarkTheme,
    };
  }
}

/// An entity of `geo` field of Cloud Firestore location document.
class Geo {
  Geo({
    required this.geohash,
    required this.geopoint,
  });

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        geohash: json['geohash'] as String,
        geopoint: json['geopoint'] as GeoPoint,
      );

  final String geohash;
  final GeoPoint geopoint;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'geohash': geohash,
        'geopoint': geopoint,
      };
}
