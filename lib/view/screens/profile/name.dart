import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/home/home.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: ''),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Name",
              size: 13,
              weight: FontWeight.w500,
              color: kGreyColor1,
            ),
            MyText(
              paddingTop: 5,
              text: "Selena John",
              size: 15,
              weight: FontWeight.w500,
            ),
            MyText(
              paddingTop: 10,
              text:
                  """Help people discover your account by using the name you’re known by: either full name, nickname pr business name. 
You can change your name twice within 14 days.""",
              size: 13,
              weight: FontWeight.w500,
              color: kGreyColor1.withOpacity(0.7),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                    child: MyButton(
                  onTap: () {
                    Get.to(HomePage());
                  },
                  buttonText: "Done",
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
