import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/messages_controllers/inbox_controller.dart';
import 'package:soical_media_app/view/screens/chat/new_group.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

import '../../../core/bindings/bindings.dart';
import '../../../core/global/instance_variables.dart';
import 'chat_page.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  bool haveCheckBoxTrue = false;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InboxController>();

    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "New Message"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              paddingBottom: 10,
              text: "Create Group",
              size: 14,
              weight: FontWeight.w500,
              color: kGreyColor1,
            ),
            Row(
              children: [
                _GroupIcon(
                  onTap: () {
                    Get.to(NewGroup());
                  },
                ),
                MyText(
                  paddingLeft: 10,
                  text: "New Group",
                  size: 14,
                  weight: FontWeight.w600,
                  color: kGreyColor1,
                ),
              ],
            ),
            MyText(
              paddingTop: 10,
              paddingBottom: 10,
              text: "Direct Message",
              size: 14,
              weight: FontWeight.w500,
              color: kGreyColor1,
            ),
            Expanded(
              child: Obx(()=>
                  ListView.builder(
                  itemCount: controller.chatThreadModels.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => TextToNewUserCard(
                    onTap: () {
                      Get.to(
                              () => ChatPage(
                            chatThreadModel: controller.chatThreadModels[index],
                          ),
                          binding: ChatBinding(controller.chatThreadModels[index]));
                    },
                    title: controller.chatThreadModels[index].senderID ==
                        userModelGlobal.value.uid
                        ? controller.chatThreadModels[index].receiverName ?? ''
                        : controller.chatThreadModels[index].senderName ?? '',
                    img: controller.chatThreadModels[index].senderID ==
                        userModelGlobal.value.uid
                        ? controller.chatThreadModels[index].receiverProfileImage
                        : controller.chatThreadModels[index].senderProfileImage,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextToNewUserCard extends StatelessWidget {
  final String? img, title;
  final VoidCallback? onTap;
  final Function(dynamic)? onChanged;
  final bool isChecked;
  final bool haveCheckBox;
  final double mTop;
  const TextToNewUserCard(
      {super.key,
      this.img,
      this.onTap,
      this.title,
      this.onChanged,
      this.isChecked = false,
      this.haveCheckBox = false,
      this.mTop = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                CommonImageView(
                  url: img,

                  height: 51,
                  width: 51,
                  radius: 100,
                ),
                MyText(
                  paddingLeft: 10,
                  text: "$title",
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Spacer(),
          (haveCheckBox == true)
              ? CheckBoxWidget(isChecked: isChecked, onChanged: onChanged)
              : SizedBox(),
        ],
      ),
    );
  }
}

class _GroupIcon extends StatelessWidget {
  final VoidCallback onTap;
  const _GroupIcon({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 51,
          width: 51,
          decoration:
              BoxDecoration(color: kSecondaryColor, shape: BoxShape.circle),
          child: Center(
              child: CommonImageView(
            svgPath: Assets.imagesGroupMsgIcon,
          )),
        ),
      ),
    );
  }
}
