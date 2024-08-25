import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_images.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/view/screens/home/status_settings.dart';
import 'package:soical_media_app/view/screens/home/text_status.dart';
import 'package:soical_media_app/view/widget/common_image_view_widget.dart';

class UploadStatusPage extends StatefulWidget {
  const UploadStatusPage({super.key});

  @override
  State<UploadStatusPage> createState() => _UploadStatusPageState();
}

class _UploadStatusPageState extends State<UploadStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor1,
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                SvgButton(
                  onTap: () {
                    Get.to(TextStatusPage());
                  },
                  svgIcon: Assets.imagesTypeStatusIcon,
                ),
                SizedBox(width: 20),
                SvgButton(
                  onTap: () {
                    Get.to(StatusSettings());
                  },
                  svgIcon: Assets.imagesSettingCameraIcon,
                ),
              ],
            ),
          ),
          Container(
            padding: AppSizes.HORIZONTAL,
            margin: EdgeInsets.only(top: 10),
            height: Get.height * 0.85,
            width: Get.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.imagesCameraOpen),
                    fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgButton(
                    onTap: () {},
                    svgIcon: Assets.imagesFlashLightOn,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return _Pictures();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgButton(
                      onTap: () {},
                      svgIcon: Assets.imagesGalleryIconCameraPage,
                    ),
                    SvgButton(
                      onTap: () {},
                      svgIcon: Assets.imagesTakePhotoIcon,
                    ),
                    SvgButton(
                      onTap: () {},
                      svgIcon: Assets.imagesChangeCameraIcon,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pictures extends StatelessWidget {
  const _Pictures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      child: CommonImageView(
        imagePath: Assets.imagesMountainImg,
        height: 77,
        width: 77,
      ),
    );
  }
}

class SvgButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? svgIcon;
  const SvgButton({super.key, required this.onTap, this.svgIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CommonImageView(
        svgPath: svgIcon,
      ),
    );
  }
}
