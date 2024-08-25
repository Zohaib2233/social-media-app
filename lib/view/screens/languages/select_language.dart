import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/widget/auth_appbar.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class Selectlanguages extends StatefulWidget {
  const Selectlanguages({super.key});

  @override
  State<Selectlanguages> createState() => _SelectlanguagesState();
}

class _SelectlanguagesState extends State<Selectlanguages> {
  // Country Flags
  //---------------------------

  List<String> countryFlags = [
    Assets.imagesUsFlagIcon,
    Assets.imagesUkFlagIcon,
    Assets.imagesArabFlagIcon,
    Assets.imagesFrenchFlagIcon,
    Assets.imagesGermanyFlagIcon,
    Assets.imagesPakistanFlagIcon,
    Assets.imagesRussiaFlagIcon,
    Assets.imagesPersianFlagIcon
  ];

  // Country Languages
  //-----------------------------

  List<String> countryLanguages = [
    'English (US)',
    'English (UK)',
    'Arabic',
    'French',
    'German',
    'Urdu',
    'Russian',
    'Persion',
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: auth_appbar(haveBackIcon: false),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
              text: "Choose language",
              size: 18,
              weight: FontWeight.w600,
            ),
            MyText(
              paddingBottom: 22,
              paddingTop: 7,
              text: "Please choose your language to get started",
              size: 12,
              weight: FontWeight.w600,
            ),

            // Languages Button
            //-----------------

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: countryFlags.length,
                itemBuilder: (context, index) {
                  return _Language_btn(
                    onTap: () {
                      currentIndex = index;
                      setState(() {});
                    },
                    countryFlag: countryFlags[index],
                    countryLanguage: countryLanguages[index],
                    isSelected: (index == currentIndex) ? true : false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSizes.DEFAULT,
            child: Row(
              children: [
                Expanded(
                    child: MyButton(
                        onTap: () {
                          SharedPreferenceService.instance.saveSharedPreferenceBool(
                              key: SharedPrefKeys.completeOnboarding,
                              value: true);
                          Get.to(() => Login());
                        },
                        buttonText: 'Done'))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Language_btn extends StatelessWidget {
  final VoidCallback? onTap;
  final String? countryFlag, countryLanguage;
  final bool isSelected;

  const _Language_btn(
      {super.key,
      this.onTap,
      this.countryFlag,
      this.countryLanguage,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashColor: kSecondaryColor.withOpacity(0.05),
      contentPadding: EdgeInsets.zero,
      leading: CommonImageView(
        svgPath: countryFlag,
      ),
      title: MyText(
        text: countryLanguage ?? "Country language",
        size: 14,
        weight: FontWeight.w500,
      ),
      trailing: CommonImageView(
        svgPath: (isSelected == true)
            ? Assets.imagesCheckFillIcon
            : Assets.imagesCheckOutlineIcon,
      ),
    );
  }
}
