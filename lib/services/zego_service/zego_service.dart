import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soical_media_app/core/utils/zego_strings.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../core/global/instance_variables.dart';
import '../../core/utils/snackbar.dart';
import '../../view/widget/common_image_view_widget.dart';



/// https://www.zegocloud.com/docs/uikit/callkit-flutter/quick-start-(with-call-invitation)

class ZegoService{

  /// on user login
  static void onUserLogin() {
    print("On User Login Called Zego Method");
    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoStrings.appId /*input your AppID*/,
      appSign: ZegoStrings.appSign /*input your AppSign*/,
      userID: userModelGlobal.value.uid,
      userName: userModelGlobal.value.name,
      plugins: [ZegoUIKitSignalingPlugin()],

      requireConfig: (ZegoCallInvitationData data) {
        print("ZegoCallInvitationData data = ${data}");
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        /// custom avatar
        config.avatarBuilder = customAvatarBuilder;


        /// support minimizing, show minimizing button
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons
            .insert(0, ZegoCallMenuBarButtonName.minimizingButton);
        config.topMenuBar.buttons
            .insert(1, ZegoCallMenuBarButtonName.soundEffectButton);
        print("Zego Init $config");
        return config;
      },
    );
  }

  /// on user logout
  static void onUserLogout() {
    /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  Widget zegoCallButton({required targetUserID,required targetUserName}){
    return ZegoSendCallInvitationButton(
      isVideoCall: true,
      resourceID: "zohaib_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
      invitees: [
        ZegoUIKitUser(
          id: targetUserID,
          name: targetUserName,
        ),
      ],
    );

  }

  static Widget customAvatarBuilder(
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo,
      ) {
    return CachedNetworkImage(
      imageUrl: '${userModelGlobal.value.profilePicture}',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        ZegoLoggerService.logInfo(
          '$user avatar url is invalid',
          tag: 'live audio',
          subTag: 'live page',
        );
        return ZegoAvatar(user: user, avatarSize: size);
      },
    );
  }


  Widget sendCallButton({
    required bool isVideoCall,
    required String otherUsername,
    required String id,
    required String buttonIcon,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    print("Send Button Pressed");
    return ZegoSendCallInvitationButton(

      isVideoCall: isVideoCall,
      invitees: [
        ZegoUIKitUser(id: id, name: otherUsername),
      ],
      borderRadius: 0,

      resourceID: 'zohaib_call', /// Change This Resource Id
      iconSize: const Size(20,20),
      buttonSize: const Size(40, 40),
      onPressed: onCallFinished,
      icon: ButtonIcon(
          icon: CommonImageView(
            radius: 0,
            fit: BoxFit.scaleDown,
            svgPath: buttonIcon,
            height: 18,
            width: 18,

          )
      ),
    );
  }

  void onSendCallInvitationFinished(
      String code,
      String message,
      List<String> errorInvitees,
      ) {
    print("onSendCallInvitationFinished Called");
    print("Code $code message= $message");
    if (errorInvitees.isNotEmpty) {
      print("Error Invitess = ${errorInvitees}");
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {

        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }

      print('Error zego call = $message');

      CustomSnackBars.instance
          .customSnackBar(message: '$message', color: Colors.redAccent);
    } else if (code.isNotEmpty) {
      print("Error 2 = 'code: $code, message:$message'");
      CustomSnackBars.instance.customSnackBar(
          message: 'code: $code, message:$message', color: Colors.redAccent);
    }
    else if(errorInvitees.isEmpty){
      print("${errorInvitees }=errorInvitees.isEmpty");
    }
  }


}