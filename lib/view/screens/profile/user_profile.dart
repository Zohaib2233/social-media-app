import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      children: [
        // App Bar
        //-------------------------
        _ProfilePageAppBar(
          backgroundImg: Assets.imagesMountainImg,
          profileImg: Assets.imagesProfileImg4,
          onBackTap: () {
            Get.back();
          },
          onCameraTap: () {},
          onHomeTap: () {},
          posts: '142',
          followers: '200',
          following: '100',
        ),

        Padding(
          padding: AppSizes.HORIZONTAL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserProfileInfo(
                title: "James J Call",
                subTitle: "@jamesjcall",
              ),
              MyText(
                paddingTop: 17,
                text:
                    "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis ajodjmdokf.",
                size: 13,
                weight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              _MoreInfoButton(
                onTap: () {},
              ),
              SizedBox(height: 32),
              _FollowAndMessageBtn(
                onFollowTap: () {},
                onMessageTap: () {},
              ),
              SizedBox(height: 32),
              TabBar.secondary(
                  controller: _tabController,
                  labelColor: kSecondaryColor,
                  dividerColor: kGreyColor1.withOpacity(0.5),
                  tabs: [
                    Tab(text: '335 POSTS'),
                    Tab(text: '1212 MEDIA'),
                  ]),
              SizedBox(
                height: Get.height * 0.7,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    _TabBarContent(),
                    _TabBarContent(),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}

class _TabBarContent extends StatelessWidget {
  const _TabBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.2,
      child: MasonryGridView.builder(
        padding: EdgeInsets.only(top: 15),
        physics: BouncingScrollPhysics(),
        itemCount: 11,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        mainAxisSpacing: 2,
        crossAxisSpacing: 5,
        itemBuilder: (context, index) {
          return CommonImageView(
            imagePath: 'assets/images/p-${index + 1}.png',
          );
        },
      ),
    );
  }
}

class _FollowAndMessageBtn extends StatelessWidget {
  final bool haveFollowAndMessageBtn;
  final VoidCallback onFollowTap, onMessageTap;
  const _FollowAndMessageBtn(
      {super.key,
      this.haveFollowAndMessageBtn = true,
      required this.onFollowTap,
      required this.onMessageTap});

  @override
  Widget build(BuildContext context) {
    return (haveFollowAndMessageBtn == true)
        ? Row(
            children: [
              Expanded(
                child: MyButton(
                  radius: 7,
                  onTap: onFollowTap,
                  buttonText: 'Follow',
                  height: 40,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: MyButton(
                  radius: 7,
                  onTap: onMessageTap,
                  buttonText: 'Message',
                  height: 40,
                ),
              ),
            ],
          )
        : SizedBox();
  }
}

class _MoreInfoButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _MoreInfoButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          MyText(
            paddingRight: 15,
            text: 'More info',
            size: 13,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
          CommonImageView(
            svgPath: Assets.imagesEditIconSvg,
          )
        ],
      ),
    );
  }
}

class _UserProfileInfo extends StatelessWidget {
  final String? title, subTitle;
  final bool haveUserVerified, haveUserOnline;
  const _UserProfileInfo({
    super.key,
    this.haveUserOnline = true,
    this.haveUserVerified = true,
    this.subTitle,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            MyText(
              paddingRight: 10,
              text: "$title",
              size: 16,
              weight: FontWeight.w500,
            ),
            (haveUserVerified == true)
                ? CommonImageView(
                    svgPath: Assets.imagesUserVerifiedBlueIcon,
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            MyText(
              paddingRight: 10,
              text: "$subTitle",
              size: 14,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
            ),
            Icon(
              Icons.circle,
              color: (haveUserOnline == true) ? kGreenColor : kGreyColor1,
              size: 10,
            )
          ],
        ),
      ],
    );
  }
}

// Home App Bar Widgets
//--------------------------------

class _ProfilePageAppBar extends StatelessWidget {
  final String? backgroundImg, profileImg, posts, followers, following;
  final VoidCallback? onCameraTap, onVerticalPopupTap, onBackTap, onHomeTap;

  const _ProfilePageAppBar({
    super.key,
    this.backgroundImg,
    this.profileImg,
    this.posts,
    this.followers,
    this.following,
    this.onBackTap,
    this.onCameraTap,
    this.onHomeTap,
    this.onVerticalPopupTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      // color: Colors.amber,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 189,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("$backgroundImg"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 52,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        _RoundButtons(
                          onTap: onBackTap,
                          svgIcon: Assets.imagesBackWhiteIcon,
                        ),
                        Spacer(),
                        _RoundButtons(
                          onTap: onHomeTap,
                          svgIcon: Assets.imagesHomeWhiteIcon,
                        ),

                        // Popoup menu button
                        //-----------------------------
                        PopupMenuButton<String>(
                            iconColor: kWhiteColor,
                            color: kWhiteColor,
                            shadowColor: kWhiteColor,
                            elevation: 0,
                            onSelected: (value) {
                              // Handle menu item selection
                              print('Selected: $value');
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'option1',
                                  child: Text('Message'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'option2',
                                  child: Text('Report'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'option3',
                                  child: Text('Block'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'option3',
                                  child: Text('Copy Profile URL'),
                                )
                              ];
                            }),

                        SizedBox(width: 10),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _RoundButtons(
                          onTap: onCameraTap,
                          svgIcon: Assets.imagesCameraWhiteIcon,
                        ),
                        SizedBox(width: 15),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child:
                // Profile Image
                // -------------------------
                Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: kWhiteColor),
                  image: DecorationImage(image: AssetImage("$profileImg"))),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                _DisplayInfo(
                  title: "$posts",
                  subTitle: "Posts",
                ),
                SizedBox(width: 18),
                _DisplayInfo(
                  title: "$followers",
                  subTitle: "Followers",
                ),
                SizedBox(width: 18),
                _DisplayInfo(
                  title: "$following",
                  subTitle: "Following",
                ),
                SizedBox(width: 18),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _DisplayInfo extends StatelessWidget {
  final String? title, subTitle;
  const _DisplayInfo({super.key, this.subTitle, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyText(
          text: "$title",
          size: 15.36,
          weight: FontWeight.w500,
        ),
        MyText(
          paddingTop: 5.56,
          text: "$subTitle",
          size: 11.52,
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}

class _RoundButtons extends StatelessWidget {
  final String? svgIcon;
  final VoidCallback? onTap;
  const _RoundButtons({
    super.key,
    this.onTap,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // color: Colors.amber,
        width: 40,
        height: 30,
        child: Center(
          child: CommonImageView(
            svgPath: svgIcon,
          ),
        ),
      ),
    );
  }
}
