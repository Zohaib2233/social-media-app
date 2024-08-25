import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/core/utils/utils.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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

    resourceID: 'zohaib_call',
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
