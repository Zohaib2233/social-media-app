import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/widget/checkbox_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class StatusSettings extends StatefulWidget {
  const StatusSettings({super.key});

  @override
  State<StatusSettings> createState() => _StatusSettingsState();
}

class _StatusSettingsState extends State<StatusSettings> {
  List<String> title = ['My contacts', 'My contacts except', 'Only share with'];
  List<String> subTitle = [
    'All people can view your content',
    'Only your family and friends can view your content',
    '  '
  ];
  double currentIndex = 0;
  bool haveValueCheck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: 'Status Settings'),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(children: [
          MyText(
            text: "Who can view my status updated",
            size: 15,
            color: kBlackColor1,
            weight: FontWeight.w500,
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return _StatusCard(
                  mTop: (index == 0) ? 0 : 20,
                  title: title[index],
                  subTitle: subTitle[index],
                  isChecked: (index == 0) ? true : false,
                  actionTextNeed: (index == 0) ? false : true,
                  onChange: (value) {
                    haveValueCheck = value!;
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String? title, subTitle;
  Function(dynamic)? onChange;
  final bool isChecked, actionTextNeed;
  final double mTop;

  _StatusCard(
      {super.key,
      this.onChange,
      this.title,
      this.subTitle,
      this.isChecked = false,
      this.actionTextNeed = false,
      this.mTop = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckBoxWidget(
                isChecked: isChecked,
                onChanged: onChange,
              ),
              MyText(
                paddingLeft: 10,
                text: "$title",
                size: 14,
                color: kBlackColor1,
                weight: FontWeight.w500,
              ),
              Spacer(),
              (actionTextNeed == true)
                  ? MyText(
                      paddingLeft: 10,
                      text: "5 excludeded",
                      size: 12,
                      color: kSecondaryColor,
                      weight: FontWeight.w500,
                    )
                  : SizedBox(),
            ],
          ),
          MyText(
            paddingLeft: 30,
            text: "$subTitle",
            size: 14,
            color: kGreyColor1,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
