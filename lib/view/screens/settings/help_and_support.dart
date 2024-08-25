import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Help And Support"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            MyText(
                paddingBottom: 28,
                text: 'Hi, how can we help you?',
                size: 15,
                weight: FontWeight.w500,
                color: kBlackColor1),
            CustomSearchFields(),
            MyText(
                paddingTop: 19,
                text:
                    'In-case of any inconvenience or problem, feel free to reac us out on the following address.',
                size: 12,
                weight: FontWeight.w500,
                color: kBlackColor1.withOpacity(0.5)),
            MyText(
                paddingTop: 19,
                text: 'Call at our help line number',
                size: 13,
                weight: FontWeight.w500,
                color: kBlackColor1),
            MyText(
                onTap: () {},
                paddingTop: 19,
                text: '+42-122-431',
                size: 15,
                weight: FontWeight.w500,
                color: kSecondaryColor),
            MyText(
                paddingTop: 19,
                text: 'Email us at',
                size: 13,
                weight: FontWeight.w500,
                color: kBlackColor1),
            MyText(
                onTap: () {},
                paddingTop: 19,
                text: 'duseca@gmail.com',
                size: 15,
                weight: FontWeight.w500,
                color: kSecondaryColor),
          ],
        ),
      ),
    );
  }
}

class CustomSearchFields extends StatelessWidget {
  const CustomSearchFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      radius: 20,
      isUseLebelText: false,
      hintText: 'Search here....',
      filled: true,
      backgroundColor: kGreyColor2,
      outlineBorderColor: kTransperentColor,
      haveSuffixIcon: true,
      suffixWidget: Container(
        width: 50,
        child: Center(
          child: CommonImageView(svgPath: Assets.imagesSearchIcon),
        ),
      ),
    );
  }
}
