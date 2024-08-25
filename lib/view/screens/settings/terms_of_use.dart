import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class TearmOfUse extends StatefulWidget {
  const TearmOfUse({super.key});

  @override
  State<TearmOfUse> createState() => _TearmOfUseState();
}

class _TearmOfUseState extends State<TearmOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Tearm Of Use"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text:
                  """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\nUt enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.""",
              size: 12,
              weight: FontWeight.w500,
              color: kGreyColor1,
              lineHeight: 2,
            ),
            MyText(
              paddingTop: 15,
              text:
                  """•  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.""",
              size: 12,
              weight: FontWeight.w500,
              color: kGreyColor1,
              lineHeight: 2,
            ),
            MyText(
              paddingTop: 15,
              text:
                  """•  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.""",
              size: 12,
              weight: FontWeight.w500,
              color: kGreyColor1,
              lineHeight: 2,
            ),
            MyText(
              paddingTop: 15,
              text:
                  """•  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.""",
              size: 12,
              weight: FontWeight.w500,
              color: kGreyColor1,
              lineHeight: 2,
            ),
          ],
        ),
      ),
    );
  }
}
