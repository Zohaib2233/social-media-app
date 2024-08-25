import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/controllers/messages_controllers/inbox_controller.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/view/screens/chat/create_new_group.dart';
import 'package:soical_media_app/view/screens/search/search.dart';
import 'package:soical_media_app/view/widget/Horizantall_divider.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

import '../../../controllers/home_controllers/search_controller.dart';

class NewGroup extends StatefulWidget {

  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  @override
  Widget build(BuildContext context) {
    bool haveCheckBoxTrue = false;
    var controller = Get.find<InboxController>();
    var searchController = Get.find<SearchScreenController>();
    List<String> selectedUsers = <String>[];
    return Scaffold(
      appBar: simple_appbar_with_back_button(
          title: "New Group", subTitle: "2 of 91 members", haveSubTitle: true),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              radius: 20,
              //controller: ,
            ),
            MyText(
              paddingTop: 20,
              paddingBottom: 10,
              text: "Members",
              size: 14,
              weight: FontWeight.w500,
              color: kGreyColor1,
            ),
            HorizantalDivider(
              thickness: 1,
              color: kGreyColor1.withOpacity(0.2),
            ),
            Expanded(
              child: Obx(()=>ListView.builder(
                  itemCount: searchController.userModels.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    UserModel userModel = searchController.userModels[index];
                    return TextToNewUserCard(
                        title: "${userModel.name}",
                        img: userModel.profilePicture,
                        haveCheckBox: true,
                        isChecked: controller.selectedUsers.contains(userModel.uid),
                        onChanged: (value) {

                          if(controller.selectedUsers.contains(userModel.uid)){
                            controller.selectedUserModels.remove(userModel);
                            controller.selectedUsers.remove(userModel.uid);
                          }
                          else{
                            controller.selectedUserModels.add(userModel);
                            controller.selectedUsers.add(userModel.uid);
                          }
                          print(controller.selectedUserModels);
                          setState(() {

                          });



                        },
                      );
                  }
                ),
              ),
            ),
            Spacer(),
            MyButton(
              onTap: () {
                Get.to(CreateNewGroup(
                  userModels: controller.selectedUserModels,
                ));
              },
              buttonText: "Done",
              backgroundColor: kSecondaryColor,
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
      onTap: () {},
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
