import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/controllers/messages_controllers/inbox_controller.dart';
import 'package:soical_media_app/core/global/instance_variables.dart';
import 'package:soical_media_app/view/screens/chat/messages.dart';
import 'package:soical_media_app/view/screens/create_post.dart/create_post.dart';
import 'package:soical_media_app/view/screens/home/home.dart';
import 'package:soical_media_app/view/screens/profile/profile.dart';
import 'package:soical_media_app/view/screens/search/search.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';

class BNavBar extends StatefulWidget {
  int index;
  BNavBar({super.key, this.index = 0});

  @override
  State<BNavBar> createState() => _BNavBarState();
}

class _BNavBarState extends State<BNavBar> {
  var controller = Get.put(InboxController());



  List<Widget> screensWidgetsList = <Widget>[
    HomePage(),
    Search(),
    CreatePost(),
    MessagesPage(),
    ProfilePage(
      userId: userModelGlobal.value.uid,
    ),
  ];

  @override
  void initState() {
    print("------------------------- Nav Bar Init ----------------");
    print(userModelGlobal.value.toJson());
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensWidgetsList[widget.index],
      bottomNavigationBar: Container(
        //height: 100,
        color: Colors.amber,
        child: BottomNavigationBar(
          elevation: 2,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: kPrimaryColor,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            widget.index = value;
            setState(() {});
          },
          currentIndex: widget.index,
          items: [
            BottomNavigationBarItem(
              icon: CommonImageView(
                svgPath: (widget.index == 0)
                    ? Assets.imagesHomeBlueIcon
                    : Assets.imagesHomeBlackIcon,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                svgPath: (widget.index == 1)
                    ? Assets.imagesSearchBlueIcon
                    : Assets.imagesSearchBlackIcon,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                svgPath: (widget.index == 2)
                    ? Assets.imagesCreatePostBlueIcon
                    : Assets.imagesCreatePostBlackIcon,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                height: 22,
                width: 22,
                svgPath: (widget.index == 3)
                    ? Assets.imagesChatBlueIcon
                    : Assets.imagesChatBlackIcon,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CommonImageView(
                svgPath: (widget.index == 4)
                    ? Assets.imagesUserProfileBlueIcon
                    : Assets.imagesUserProfileBlackIcon,
              ),
              label: 'Home',
            ),
          ],
        ),
      ),
    );
  }
}
