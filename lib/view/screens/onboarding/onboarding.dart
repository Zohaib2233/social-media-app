import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/core/constants/shared_pref_keys.dart';
import 'package:soical_media_app/services/shared_preferences_services.dart';
import 'package:soical_media_app/view/screens/auth/login/login.dart';
import 'package:soical_media_app/view/screens/languages/select_language.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: currentIndex);
    super.initState();
  }

  List<String> title = ['', 'Videos', 'Hashtags', 'Chat'];
  List<String> subTitle = [
    '',
    'Discover the best videos by millions of people',
    'Search the famous hashtags and explore',
    'Connect with millions of people on internet'
  ];
  // List<Widget> screens = [];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: title.length,
      onPageChanged: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      itemBuilder: (context, index) {
        return Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            image: AppStyling().onBoardingBkImg(
                bk: (index == 0)
                    ? Assets.imagesOnboardingBkImg1
                    : Assets.imagesOnBoardingBkImg),
          ),
          child: Scaffold(
            backgroundColor: kTransperentColor,
            body: (index == 0)
                ? Padding(
                    padding: AppSizes.DEFAULT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CommonImageView(
                                        svgPath: Assets
                                            .imagesOnboardingFirstScreenLogo,
                                      ),
                                      MyText(
                                          paddingLeft: 14,
                                          text: "Welcome to\nSocial Media\nApp",
                                          size: 22,
                                          weight: FontWeight.w500,
                                          color: kWhiteColor),
                                    ],
                                  ),
                                  MyText(
                                      paddingTop: 14.51,
                                      paddingLeft: 14,
                                      text:
                                          "es simplemente el texto de relleno de \nlas imprentas y archivos de texto. \nLorem Ipsum ha sido el texto de relleno..",
                                      size: 12,
                                      weight: FontWeight.w400,
                                      color: kWhiteColor),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                              onTap: () {
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.linear);
                              },
                              child: CommonImageView(
                                svgPath: Assets.imagesOnboardingFirstScreenBtn,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : Padding(
                    padding: AppSizes.DEFAULT,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 74,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        _OnBoadingImgWidget(
                            title: title[index],
                            bkImg: (index == 2)
                                ? Assets.imagesGlobeHoriPngImg
                                : Assets.imagesGlobeVerticalPngImg

                            // title: title[index],
                            ),
                        Spacer(
                          flex: 4,
                        ),
                        MyText(
                          textAlign: TextAlign.center,
                          text: subTitle[index],
                          size: 28,
                          weight: FontWeight.w600,
                          color: kWhiteColor,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        SizedBox(
                          height: 8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, i) => _Indecator(
                              clr: (i == currentIndex - 1)
                                  ? kWhiteColor
                                  : kGreyColor1,
                              isIndexCorrect:
                                  (i == currentIndex - 1) ? true : false,
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.linear);

                            if (index == 3) {
                              //Todo: Add SElect Language Here
                              SharedPreferenceService.instance.saveSharedPreferenceBool(key: SharedPrefKeys.completeOnboarding, value: true);
                              Get.to(()=>Login());
                              // Get.to(() => Selectlanguages());
                            } else {}
                          },
                          child: CommonImageView(
                            svgPath: Assets.imagesOnbordingNextIcon,
                          ),
                        ),
                        // SizedBox(height: 43),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _OnBoadingImgWidget extends StatelessWidget {
  final String bkImg, title;

  const _OnBoadingImgWidget(
      {super.key,
      this.bkImg = Assets.imagesGlobeVerticalPngImg,
      this.title = 'here'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      width: 252,
      decoration:
          BoxDecoration(image: AppStyling().onBoardingContentImg(bk: bkImg)),
      child: Center(
        child: MyText(
          text: title,
          size: 38,
          weight: FontWeight.w700,
          color: kWhiteColor,
        ),
      ),
    );
  }
}

class _Indecator extends StatelessWidget {
  final Color clr;
  final bool isIndexCorrect;
  const _Indecator(
      {super.key, this.clr = kPrimaryColor, this.isIndexCorrect = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      width: (isIndexCorrect == true) ? 34 : 13,
      height: 6,
      decoration: BoxDecoration(
        color: clr,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
