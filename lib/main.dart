import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soical_media_app/config/routes/routes.dart';
import 'package:soical_media_app/config/theme/light_theme.dart';
import 'package:soical_media_app/core/bindings/bindings.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/services/local_notification_service.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';


//for getting notifications when the app is in background and the user doesn't tap on the notification
@pragma('vm:entry-point')   //for getting background notifications in release mode also
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  print('Notification is: ${message.notification.toString()}');
  print("Message is (App is in background): ${message.data}");
  log('Notification is: ${message.notification!.title.toString()}');
  LocalNotificationService.instance.display(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LocalNotificationService.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);
  await pushNotifications();

  /// 1.1.1 define a navigator key
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value)  {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );


    runApp(MyApp(navigatorKey: navigatorKey,));
  });
}

//DO NOT REMOVE Unless you find their usage.
String dummyImg =
    'https://images.unsplash.com/photo-1558507652-2d9626c4e67a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    LocalNotificationService.instance.getDeviceToken();

    return Obx(()=> GetMaterialApp(
        // key: widget.navigatorKey,
        navigatorKey: widget.navigatorKey,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: 'TITLE',
        theme: userModelGlobal.value.isDarkTheme?darkTheme:lightTheme,
        themeMode: userModelGlobal.value.isDarkTheme?ThemeMode.dark:ThemeMode.light,
        initialRoute: AppLinks.splash_screen,
        getPages: AppRoutes.pages,
        initialBinding: InitialBindings(),
      ),
    );
  }
}



//method to listen to firebase push notifications
//adding push notifications
Future<void> pushNotifications() async {
  //for onMessage to work properly
  //to get the notification message when the app is in terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print("Notification got from the terminated state: ${message.data}");
      // Get.to(() => HostProfile());
    }
  });

  //works only if the app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //displaying push notification via local notification package
    print("Message is (App is in foreground): ${message.data}");
    //adding new notification data to notification models list
    // Get.find<NotificationController>().addNewNotification(message: message);
    log('Notification is: ${message.notification!.title.toString()}');
    LocalNotificationService.instance.display(message);
  });

  //works only when the app is in background but opened and the user taps on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("Message is (App is in background and user tapped): ${message.data}");
    //adding new notification data to notification models list
    // Get.find<NotificationController>().addNewNotification(message: message);
    // Get.to(() => HostProfile());
  });
}
