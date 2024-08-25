import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/constants/app_sizes.dart';
import 'package:soical_media_app/constants/app_styling.dart';
import 'package:soical_media_app/view/widget/bar.dart';
import 'package:soical_media_app/view/widget/custom_textfield.dart';
import 'package:soical_media_app/view/widget/my_button.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';
import 'package:soical_media_app/view/widget/simple_appbar_with_back_button.dart';

class RequestVerification extends StatefulWidget {
  const RequestVerification({super.key});

  @override
  State<RequestVerification> createState() => _RequestVerificationState();
}

class _RequestVerificationState extends State<RequestVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simple_appbar_with_back_button(title: "Request Verification"),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            // text

            MyText(
              text:
                  """Verified accounts have blue check mark next to their names to show that Instagram has confirmed they’re real presence of the public figures, celebrities and brand they represent.""",
              size: 12,
              weight: FontWeight.w400,
              color: kBlackColor1.withOpacity(0.5),
              lineHeight: 2,
            ),
            MyText(
              paddingTop: 36,
              text: "Step 1: Confirm authenticity",
              size: 12,
              weight: FontWeight.w500,
            ),
            MyText(
              paddingTop: 8,
              paddingBottom: 14,
              text:
                  "Add 1-4 identification documents for yourself or your business",
              size: 12,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
            ),

            CustomTextField(
              labelText: "Username",
              hintText: 'Username',
            ),
            SizedBox(height: 12),
            CustomTextField(
              labelText: "Full name",
              hintText: 'Robin sharma',
            ),
            SizedBox(height: 30),

            _SimpleTile(
              onTap: () {
                // Bottom Sheet
                //------------------------------------------------
                //------------------------------------------------
                Get.bottomSheet(Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: AppStyling().decorationForBottomSheet(),
                  child: _bottomSheetContent(),
                ));
                // Bottom Sheet
                //------------------------------------------------
                //------------------------------------------------
              },
              title: "Document type",
              haveAction: true,
              mTop: 0,
            ),
            SizedBox(height: 10),

            SizedBox(height: 15),

            _FileAddress(
              fileAdress: "///storage/emulat...",
              onTap: () {},
            ),
            SizedBox(height: 15),
            MyButton(
              height: 40,
              onTap: () {},
              buttonText: "Add file",
            ),

            // text

            MyText(
              paddingTop: 20,
              text: "Step 2: Confirm notability",
              size: 12,
              weight: FontWeight.w500,
            ),
            MyText(
              paddingTop: 8,
              paddingBottom: 14,
              text:
                  "Show that public figure, celebrity or brand your account represents is in the public interest",
              size: 12,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
            ),

            CustomTextField(
              labelText: "Category",
              hintText: 'Username',
            ),
            SizedBox(height: 12),
            CustomTextField(
              labelText: "Country/Region",
              hintText: '',
            ),
            SizedBox(height: 12),
            CustomTextField(
              labelText: "Audience (optional)",
              hintText: '',
            ),

            // SizedBox(height: 15),

            MyText(
              paddingTop: 20,
              text: "Step 3: Peer Review",
              size: 12,
              weight: FontWeight.w500,
            ),
            MyText(
              paddingTop: 8,
              paddingBottom: 14,
              text:
                  "Mention some references who can recommend or verify you as an authenticated public figure, celebrity or brand identity",
              size: 12,
              weight: FontWeight.w500,
              color: kBlackColor1.withOpacity(0.5),
            ),

            CustomTextField(
              labelText: "Reference 1",
              hintText: '',
            ),
            SizedBox(height: 12),
            CustomTextField(
              labelText: "Reference 2",
              hintText: '',
            ),
            SizedBox(height: 27),
            MyButton(
              height: 40,
              onTap: () {},
              buttonText: "Submit",
            ),
            SizedBox(height: 27),
          ],
        ),
      ),
    );
  }

  _bottomSheetContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BarWith60Width(),
        MyText(
          paddingTop: 10,
          text: "Select a document type",
          size: 16,
          weight: FontWeight.w600,
        ),
        _SimpleTile(
          title: "Driver’s license",
        ),
        _SimpleTile(
          title: "Passport",
        ),
        _SimpleTile(
          title: "National identity card",
        ),
        _SimpleTile(
          title: "Tax filing",
        ),
        _SimpleTile(
          title: "Recent utility bills",
        ),
        _SimpleTile(
          title: "Articles of incorporation",
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class _SimpleTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final double mTop;
  final bool haveAction;
  const _SimpleTile(
      {super.key,
      this.onTap,
      this.title,
      this.mTop = 15,
      this.haveAction = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: mTop),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: '$title',
              size: 14,
              color: kBlackColor1,
              weight: FontWeight.w500,
            ),
            haveAction == true
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: kGreyColor1,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class _FileAddress extends StatelessWidget {
  final String? fileAdress;
  final VoidCallback? onTap;
  const _FileAddress({
    super.key,
    this.fileAdress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: "file:$fileAdress",
          size: 12,
          weight: FontWeight.w500,
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.close,
            size: 13,
          ),
        )
      ],
    );
  }
}
