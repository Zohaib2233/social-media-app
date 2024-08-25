import 'package:flutter/cupertino.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/zego_strings.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';


class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID, required this.targetUserID, required this.targetUsername, required this.imageUrl}) : super(key: key);
  final String callID,targetUserID, targetUsername,imageUrl;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoStrings.appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: ZegoStrings.appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: targetUserID,
      userName: targetUsername,

      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()..avatarBuilder=(BuildContext context,Size size,ZegoUIKitUser? user,Map extraInfo){
        return user!=null?CommonImageView(
          radius: 30,
          url: imageUrl,
        ):Container();
      }
    );
  }
}
