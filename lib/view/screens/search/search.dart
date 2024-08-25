import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/controllers/home_controllers/search_controller.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/core/utils/app_strings.dart';
import 'package:soical_media_app/models/user_model/follow_user_model.dart';
import 'package:soical_media_app/models/user_model/user_model.dart';
import 'package:soical_media_app/services/firebaseServices/firebase_crud_services.dart';
import 'package:soical_media_app/view/screens/profile/profile.dart';
import 'package:soical_media_app/view/widget/appbar_widget.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // var controller = Get.find<SearchScreenController>();
  SearchScreenController controller = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    log("Print build search screen");

    return Scaffold(
      appBar:
          appbar_widget(haveTitle: true, haveBackIcon: false, title: "Search"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchField(
              controller: controller.searchController.value,
              onChanged: (value) {
                controller.searchController.value.text = value;
                controller.searchUsers();
              },
            ),
            Obx(() => controller.showSearchResults.isFalse
                ? MyText(
                    paddingTop: 22,
                    text: "People near you",
                    size: 14,
                    weight: FontWeight.w500,
                  )
                : Container()),
            Obx(() => controller.followUserModels.isNotEmpty
                ? controller.showSearchResults.isTrue
                    ? Expanded(child: searchWidget(controller: controller))
                    : Expanded(child: originalWidget(controller: controller))
                : Container()),
            SizedBox(
              height: 15,
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: SizedBox(
            //     width: 120,
            //     child: MyButton(
            //       onTap: () {},
            //       height: 32,
            //       backgroundColor: kTransperentColor,
            //       outlineColor: kSecondaryColor,
            //       buttonText: 'Load more',
            //       fontColor: kBlackColor1,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class NearByUsers extends StatefulWidget {
  final UserModel followedUserModel;

  const NearByUsers({super.key, required this.followedUserModel});

  @override
  State<NearByUsers> createState() => _NearByUsersState();
}

class _NearByUsersState extends State<NearByUsers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseCRUDServices.instance
          .isUserFollowed(otherUserId: widget.followedUserModel.uid),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _SearchScreenCard(
            isFollowed: true,
            onCardTap: () {
              Get.to(() => ProfilePage(userId: widget.followedUserModel.uid));
            },
            profileImg: widget.followedUserModel.profilePicture,
            name: "${widget.followedUserModel.name}",
            email: widget.followedUserModel.email,
            profession: widget.followedUserModel.bio,
            onFollowTap: () {
              // controller.updateList.value=false;
              FirebaseCRUDServices.instance
                  .connectToFriend(otherUserId: widget.followedUserModel.uid);
            },
          );
        } else if (!snapshot.hasData) {
          return _SearchScreenCard(
            isFollowed: true,
            onCardTap: () {
              Get.to(() => ProfilePage(userId: widget.followedUserModel.uid));
            },
            profileImg: widget.followedUserModel.profilePicture,
            name: "${widget.followedUserModel.name}",
            email: widget.followedUserModel.username,
            profession: widget.followedUserModel.bio,
            onFollowTap: () {
              FirebaseCRUDServices.instance
                  .connectToFriend(otherUserId: widget.followedUserModel.uid);
            },
          );
        } else {
          return _SearchScreenCard(
            isFollowed: snapshot.data ?? false,
            onCardTap: () {
              Get.to(() => ProfilePage(userId: widget.followedUserModel.uid));
            },
            profileImg: widget.followedUserModel.profilePicture,
            name: "${widget.followedUserModel.name}",
            email: widget.followedUserModel.username,
            profession: widget.followedUserModel.bio,
            onFollowTap: () {
              FirebaseCRUDServices.instance
                  .connectToFriend(otherUserId: widget.followedUserModel.uid);
            },
          );
        }
      },
    );
  }
}

Widget originalWidget({required SearchScreenController controller}) {
  return ListView.builder(
    itemCount: nearbyUsers.length,
    itemBuilder: (context, index) {
      UserModel followedUserModel = nearbyUsers[index];
      return NearByUsers(followedUserModel: followedUserModel);
    },
  );
}

Widget searchWidget({required SearchScreenController controller}) {
  return ListView.builder(
    itemCount: controller.searchResultList.length,
    itemBuilder: (context, index) {
      FollowedUserModel followedUserModel = controller.searchResultList[index];
      return _SearchScreenCard(
        isFollowed: followedUserModel.isFollowed,
        onCardTap: () {
          Get.to(() => ProfilePage(userId: followedUserModel.user.uid));
        },
        profileImg: followedUserModel.user.profilePicture,
        name: "${followedUserModel.user.name}",
        email: followedUserModel.user.email,
        profession: followedUserModel.user.bio,
        onFollowTap: () {
          controller.updateList.value = false;
          FirebaseCRUDServices.instance
              .connectToFriend(otherUserId: followedUserModel.user.uid);
        },
      );
    },
  );
}

//ignore: must_be_immutable
class SearchField extends StatelessWidget {
  TextEditingController? controller = TextEditingController();
  final ValueChanged<String>? onChanged;
  final double radius;

  SearchField({super.key, this.controller, this.radius = 10, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            onChanged: onChanged,
            radius: radius,
            controller: controller,
            isUseLebelText: false,
            havePrefixIcon: true,
            preffixWidget: CommonImageView(
              svgPath: Assets.imagesSearchIcon,
            ),
            filled: true,
            backgroundColor: kGreyColor2,
            hintText: "Search here....",
            hintTextFontColor: kBlackColor1,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

/// Search Card

// class _SearchScreenCard extends StatefulWidget {
//   final String? name, emial, profession, profileImg;
//   final VoidCallback onFollowTap, onCardTap;
//   final bool isFollowed;
//   const _SearchScreenCard(
//       {super.key,
//       this.emial,
//       this.name,
//       required this.onFollowTap,
//       this.profession,
//       this.profileImg,
//       required this.onCardTap,
//       required this.isFollowed});
//
//   @override
//   State<_SearchScreenCard> createState() => _SearchScreenCardState();
// }
//
// class _SearchScreenCardState extends State<_SearchScreenCard> {
//
//   @override
//   Widget build(BuildContext context) {
//     // bool isFollow = widget.isFollowed;
//     return Container(
//       margin: EdgeInsets.only(top: 13),
//       padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
//       // fillColorAndRadius
//       decoration: AppStyling().fillColorAndRadius(),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: widget.onCardTap,
//             child: Row(
//               children: [
//                 CommonImageView(
//                   radius: 100,
//                   width: 55,
//                   height: 55,
//                   url: widget.profileImg ?? dummyProfile,
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     MyText(
//                       text: "${widget.name}",
//                       size: 12,
//                       weight: FontWeight.w500,
//                     ),
//                     MyText(
//                       text: "${widget.emial}",
//                       size: 10,
//                       weight: FontWeight.w400,
//                       color: kGreyColor1,
//                     ),
//                     MyText(
//                       text: "${widget.profession}",
//                       size: 11,
//                       weight: FontWeight.w500,
//                       color: kGreyColor1,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: Get.width * 0.04),
//           Expanded(
//             flex: 1,
//               child: MyButton(
//             backgroundColor: widget.isFollowed ? Colors.green : kSecondaryColor,
//             onTap: () {
//               print("---------Tapped---------");
//               // widget.isFollowed = !widget.isFollowed;
//
//               setState(() {});
//             },
//             height: 32,
//             buttonText: widget.isFollowed ? 'Followed' : 'Follow',
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//           )),
//         ],
//       ),
//     );
//   }
// }
///
///
//ignore: must_be_immutable
class _SearchScreenCard extends StatefulWidget {
  final String? name, email, profession, profileImg;
  final VoidCallback onFollowTap, onCardTap;
  bool isFollowed;

  _SearchScreenCard({
    Key? key,
    this.email,
    this.name,
    required this.onFollowTap,
    this.profession,
    this.profileImg,
    required this.onCardTap,
    required this.isFollowed,
  }) : super(key: key);

  @override
  State<_SearchScreenCard> createState() => _SearchScreenCardState();
}

class _SearchScreenCardState extends State<_SearchScreenCard> {
  late bool isFollowed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollowed = widget.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 13),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: AppStyling().fillColorAndRadius(),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onCardTap,
            child: Row(
              children: [
                CommonImageView(
                  radius: 100,
                  width: 55,
                  height: 55,
                  url: widget.profileImg ?? dummyProfile,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "${widget.name}",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: "${widget.email}",
                      size: 10,
                      weight: FontWeight.w400,
                      color: kGreyColor1,
                    ),
                    MyText(
                      text: "${widget.profession}",
                      size: 11,
                      weight: FontWeight.w500,
                      color: kGreyColor1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: Get.width * 0.04),
          Expanded(
            child: MyButton(
              backgroundColor: isFollowed ? Colors.green : kSecondaryColor,
              onTap: () {
                setState(() {
                  isFollowed = !isFollowed;
                });
                widget.onFollowTap();
              },
              height: 32,
              buttonText: isFollowed ? 'Followed' : 'Follow',
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
