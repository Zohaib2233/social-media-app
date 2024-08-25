import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';
import 'package:soical_media_app/services/chatting_service.dart';
import 'package:soical_media_app/view/screens/chat/new_message.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

import '../../../models/user_model/user_model.dart';

class CreateNewGroup extends StatefulWidget {
  final List<UserModel> userModels;
  const CreateNewGroup({super.key, required this.userModels});

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  TextEditingController groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print(widget.userModels);
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Create Group"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kSecondaryColor.withOpacity(0.4),
                ),
                child: Center(
                  child: CommonImageView(
                    svgPath: Assets.imagesCameraFillWhiteIcon,
                  ),
                ),
              ),
            ),
            _TextFieldAndEmojiButton(
              controller: groupNameController,
            ),
            MyText(
              paddingTop: 24,
              paddingBottom: 10,
              text: "Member",
              size: 14,
              weight: FontWeight.w500,
              color: kBlackColor1,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.userModels.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => TextToNewUserCard(
                  title: "${widget.userModels[index].name}",
                  img: '${widget.userModels[index].profilePicture}',
                ),
              ),
            ),
            Spacer(),
            MyButton(
              onTap: () async {
                List<String> groupUsers =<String>[];
                widget.userModels.forEach((element) {
                  groupUsers.add(element.uid);
                });
                groupUsers.add(userModelGlobal.value.uid);
                Get.close(3);
                await ChattingService.instance.createGroupChatThread(groupName: groupNameController.text, participants: groupUsers);
                CustomSnackBars.instance.showSuccessSnackbar(title: "Success", message: "Group Created Successfully");
                //Get.to()
              },
              buttonText: "Create",
              backgroundColor: kSecondaryColor,
            )
          ],
        ),
      ),
    );
  }
}


class _TextFieldAndEmojiButton extends StatelessWidget {
  final VoidCallback? onTap;
  TextEditingController controller = TextEditingController();
  _TextFieldAndEmojiButton({super.key, this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 230,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Group name (optional)',
                hintStyle: TextStyle(
                    fontSize: 13, color: kGreyColor1.withOpacity(0.5)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
              ),
            )),
        InkWell(
          onTap: onTap,
          child: Container(
            //width: 50,
            child: Center(
              child: CommonImageView(
                svgPath: Assets.imagesEmojiGreyColorIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
