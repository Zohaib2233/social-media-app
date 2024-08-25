import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/settings/help_and_support.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/widget/Horizantall_divider.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class FamilyAndFriendsPage extends StatefulWidget {
  const FamilyAndFriendsPage({super.key});

  @override
  State<FamilyAndFriendsPage> createState() => _FamilyAndFriendsPageState();
}

class _FamilyAndFriendsPageState extends State<FamilyAndFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Family and Friends"),
      body: Column(children: [
        SizedBox(height: 10),
        Padding(
          padding: AppSizes.HORIZONTAL,
          child: Column(
            children: [
              MyText(
                paddingBottom: 20,
                text:
                    "Following is the list of people who are connected to you on this app as a family or friends connection",
                size: 12,
                weight: FontWeight.w500,
                color: kBlackColor1.withOpacity(0.5),
              ),
              CustomSearchFields(),
              SizedBox(height: 20),
            ],
          ),
        ),
        HorizantalDivider(),
        Padding(
          padding: AppSizes.HORIZONTAL,
          child: MyContainer(
              widget: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "21 People",
                    size: 16,
                    weight: FontWeight.w500,
                  ),
                  MyText(
                    onTap: () {},
                    text: "Clear All",
                    size: 13,
                    color: kSecondaryColor,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.37,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _PeopleCard(
                      mTop: 20,
                      title: "capturesbyhannia",
                      subTitle: "Hania Ikram Raja",
                    );
                  },
                ),
              )
            ],
          )),
        ),
        Spacer(),
        Column(
          children: [
            Padding(
                padding: AppSizes.HORIZONTAL,
                child: MyButton(onTap: () {}, buttonText: "Done")),
          ],
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}

class _PeopleCard extends StatelessWidget {
  final String? title, subTitle;
  final bool? isChecked;
  final Function(dynamic)? onChange;
  final double mTop;
  const _PeopleCard({
    super.key,
    this.isChecked = true,
    this.subTitle,
    this.title,
    this.onChange,
    this.mTop = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonImageView(
            imagePath: Assets.imagesProfileImg4,
            height: 48,
            width: 48,
            radius: 100,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                paddingTop: 5,
                text: "$title",
                size: 13,
                weight: FontWeight.w500,
              ),
              MyText(
                paddingTop: 2,
                text: "$subTitle",
                size: 12,
                weight: FontWeight.w400,
                color: kGreyColor1,
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              SizedBox(height: 15),
              CheckBoxWidget(isChecked: true, onChanged: onChange),
            ],
          ),
        ],
      ),
    );
  }
}
