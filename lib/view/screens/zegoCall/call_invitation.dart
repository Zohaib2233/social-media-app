import 'package:flutter/material.dart';
import 'package:soical_media_app/core/utils/zego_strings.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage(
      {super.key, required this.child, required this.username, required this.callID});

  final Widget child;
  final String username, callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(appID: ZegoStrings.appId,
      appSign: ZegoStrings.appSign,
      callID: callID,
      userID: username,
      userName: username,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
