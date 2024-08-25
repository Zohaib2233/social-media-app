//local notification service class
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';

class LocalNotificationService {
  LocalNotificationService._privateConstructor();

  //singleton instance variable
  static LocalNotificationService? _instance;

  //getter to access the singleton instance
  static LocalNotificationService get instance {
    _instance ??= LocalNotificationService._privateConstructor();
    return _instance!;
  }

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final firebaseMessaging = FirebaseMessaging.instance;

  //method to initialize the initialization settings
  Future<void> initialize() async {
    await requestNotificationPermission();
    //initializing settings for android
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    //we are getting details variable from the payload parameter of the notificationsPlugin.show() method
    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Key of the map is: ${details.payload}");
      },
    );

    getDeviceToken();
  }

  requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openAppSettings();
    }
  }

  //getting device token for FCM
  Future<String?> getDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Device token := $token");
    return token;
  }

  //method to display push notification on top of screen
  void display(RemoteMessage message) async {
    try {
      //getting a unique id
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      //creating notification details channel
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("social", "general",
              importance: Importance.max, priority: Priority.max));

      //displaying heads up notification
      await notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['type']);
    } on Exception catch (e) {
      print(
          "This exception occured while getting notification: $e Push Notification Exception");
    }
  }

  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccessToken() async {
    /// Generate Service Key through Project Setting => Service Account => Generate New Private Key
    /// Copy Map from that file

    var serviceAccountKey = {
      "type": "service_account",
      "project_id": "nur-socialmedia-app",
      "private_key_id": "595fd0c92adf0b28e5268ba8ea4081e854fc4182",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCpMnsGOhr7VTq4\nRG2Jodkw5uZZ7FBBDjScNeWPrYLP8NKkcHqybUSdmQpsPTHMp2TLnRZM0PSi4t+S\nOBs8XhtFOz/yNRvhQrxZmfKt2uZvZIqHiNmmf5sx6M+NC9lv6AsgH0I9I8GlT7c7\niZeOAeo++KDDwl/X8CzKTdrDXEBQVlqOxSANCwCDtkPW9SL2Er047v+S27hm/SeL\nV6opTZLWcjlKK3eLbtFca8oeYAwZQd9AEnTo9EUB3rb7x+wleLH3PO//QxmGtqi2\neiwnYb4JYFMit3dHZS+VdKiLSPm4Fn8zb3LZ1wZfbcS801o3otB/r53Oj1OBFvgp\nGTvmjf5rAgMBAAECggEAUpHCjN7lVPsaXVtzc0OrONyt1HtpDN5wWT1KKqw71tuJ\nCFul3RZK8ngBqKHSgDO+kkk2XUVp5WW/Ql2kGPk56LbJ9ZrqYKtPPJDO5/4YD4tq\nuUrVIJZMd/ZL92KteZmteD8Y9bpR4ak9283BSrlvhcyStAXS/RAF47JLzKPj9O/s\nIYLb3rYUzbVK8xBig8npMdasw1kIaCUCW6+NpmSpltGp4FJJB0N/cQw1A1IpyRWP\nf9tFvd0wZ6H9fWEHMcJnoI24v28Us9mgCi1zO2jLfK6z0hXms173wU8ktTEMtTw/\nJPl9eS3ngWAJ/iX4oqOXR7/ek6Vj/8soed+qn4WqDQKBgQDXNyNwYN8uKHvtQIrh\nItdxio8VDl1odeg/P+gYtSTJMY2BM+WJrePmoK13d8AzKcuCGqET71Ar/c9xHi6D\nU2vWQa2X2UPfvntQKumDs9nKhQEcIdzXScQbpj43pjw7DfCSLu7zNpaXto9xuKKt\ni9DCEVCPY1cDg+Pcqv/6SypcJQKBgQDJQtYXgj6gvCLYGHScM38yZ8PdrahVTaED\nEl6LT5Gd/QcRfO6YN9oRCr3QaE0Ig/PqdMnBHVld3/wZ+H1kv3u4Qx1T21l6XK2q\nT7yG14/BnzmgU54T2x3y+3CuQviZO+BPCZRjzyL8l01wJ6E60vO+UhMbsaedvPSL\nA2gLG5CjTwKBgQCf/mTBObMRLJWctlvIrU8/IIPoYmp8qxMCWm8gVyJG1CjfgYZG\nSVjg7linNQZUwuCBE2zmVgXi/mhGLurjRJQpj2APQDzeTEx+N7ir6XuivCgsEtyL\nzFIXQAqG8nVaba2H745CjzV7CgQvxdRicku6yoZ6Yp6ghV9TgGiWWWTfZQKBgDsy\nGV5YxKrqKyV8K/A1hVgCBS4Sgcx1RMJuiLhY8u+RGJ8gK91BsDYK/sFprB6xEPEI\n4L6YL0zZMIFDAT68w1rzApFDlxHSaJILWdwfUv0UJBLwBTK55Bkvs3jN4ejQH62f\nl7GznwrERdaTEW0H1wFHiq8+lZpjlVm96sA5n1UpAoGBALJ5HQcZf6qnXhdtQq56\nF4Dqd7vIx4Iu1lJRzceaICiNby/AJ9tjODFmTy9wqEjfEZGNu3WhlPGt81QayWaU\nQtAy3aS1NMpGL9I+GoEHmHTCXgIhJ820xP2zAVNU/XXVgVnvH0fR+ETADKlIiTgu\nMPtPZkvJR3s9YaDc6+S2xesC\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-3ba66@nur-socialmedia-app.iam.gserviceaccount.com",
      "client_id": "115506445425641481666",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-3ba66%40nur-socialmedia-app.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountKey),
        [firebaseMessagingScope]);

    final accessToken = client.credentials.accessToken.data;

    return accessToken;
  }

  // A function to send the notification to the user upon messaging the other user
  Future<void> sendFCMNotification(
      {required String deviceToken,
      required String title,
      required String body,
      required String type,
      required String sentBy,
      required String sentTo,
      required bool savedToFirestore}) async {
    print("Send Method Called");
    //in header we put the server key of the firebase console that is used for this project
    String accessToken = await getAccessToken();

    print("Access Tokennn = $accessToken");
    String projectId = "nur-socialmedia-app";
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'));

      request.body = json.encode({
        "message": {
          "token": deviceToken,
          "notification": {"title": title, "body": body},
          "data": {"type": type, "sentBy": sentBy, "sentTo": sentTo}
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("************ Notification has been send**********");
        if (savedToFirestore) {
          await FirebaseCRUDServices.instance.saveNotificationToFirestore(
              title: title,
              body: body,
              sentBy: sentBy,
              sentTo: sentTo,
              type: type);
        }

        //showSuccessSnackbar(title: 'Success', msg: '${response.statusCode}');
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: 'Error sending FCM notification',
            message: '${response.statusCode}');
      }
    } catch (e) {
      print("Exception ****** $e *******");
      // Utils.showFailureSnackbar(
      //     title: 'Error sending FCM notification', msg: '$e');
    }
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Channel for download notifications',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      enableVibration: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> updateNotification(
      int id, String title, String body, int progress, int total) async {
    // final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Channel for download notifications',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: total,
      progress: progress,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
