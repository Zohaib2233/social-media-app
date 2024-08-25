import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/settings/settings.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class MentionsAndTags extends StatefulWidget {
  const MentionsAndTags({super.key});

  @override
  State<MentionsAndTags> createState() => _MentionsAndTagsState();
}

class _MentionsAndTagsState extends State<MentionsAndTags> {
  List<String> name = [
    'Everyone',
    'People you follow',
    'Family and Friends',
    'No one'
  ];

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Mentions and Tags"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyContainer(
                mTop: 0,
                widget: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        itemCount: 4,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return RadioTile(
                            onTap: () {
                              currentIndex = index;
                              setState(() {});
                            },
                            haveRadioFill:
                                (currentIndex == index) ? true : false,
                            mTop: (index == 0) ? 0 : 15,
                            title: name[index],
                          );
                        },
                      ),
                    ),

                    // text

                    MyText(
                      text:
                          """Choose who can mention you to link your account in their stories, comments, live videos and captions. When people try to @mention you, they’ll see if you don’t allow @mentions.""",
                      size: 12,
                      weight: FontWeight.w400,
                      color: kBlackColor1.withOpacity(0.5),
                      lineHeight: 2,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class RadioTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final double mTop;
  final bool haveRadioFill;
  const RadioTile(
      {super.key,
      this.onTap,
      this.title,
      this.mTop = 20,
      this.haveRadioFill = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: mTop),
        child: Row(
          children: [
            Expanded(
              child: MyText(
                text: "$title",
                size: 14,
                weight: FontWeight.w400,
                color: kBlackColor1,
              ),
            ),
            CommonImageView(
              svgPath: (haveRadioFill == true)
                  ? Assets.imagesRadioBtnFillIcon
                  : Assets.imagesRadioBtnOutlineIcon,
            ),
          ],
        ),
      ),
    );
  }
}
