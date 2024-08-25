import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

import '../../constants/app_colors.dart';



class IntlPhoneFieldWidget extends StatelessWidget {
  final String? lebel;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final Function(dynamic)? onSubmitted;
  TextEditingController? controller = TextEditingController();
  IntlPhoneFieldWidget({
    super.key,
    this.lebel,
    this.controller,
    this.onSubmitted,
    this.initialValue,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingTop: 7,
          paddingBottom: 7,
          text: "Phone number",
          size: 12,
          weight: FontWeight.w500,
          color: kBlackColor1,
        ),
        Container(
          height: 60,
          //color: Colors.amber,
          child: Center(
            child: IntlPhoneField(
              //
              //
              validator: (PhoneNumber? phoneNumber){
                if(validator!=null){
                  print("$phoneNumber phoneNumber phoneNumber");
                  return validator!(phoneNumber?.number.toString());
                }
                else{
                  return null;
                }
              },
              onChanged: onSubmitted,
              controller: controller,
              autovalidateMode: AutovalidateMode.disabled,
              style: TextStyle(color: kBlackColor1),
              showCountryFlag: false,
              flagsButtonPadding: EdgeInsets.symmetric(horizontal: 5),
              flagsButtonMargin:
              EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
              showDropdownIcon: true,
              dropdownIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: kWhiteColor,
                size: 15,
              ),
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: kPrimaryColor,
              ),
              dropdownTextStyle: TextStyle(
                  fontSize: 12,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w500),
              dropdownIconPosition: IconPosition.trailing,
              dropdownDecoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(24)),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 3,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: kGreyColor3)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: kSecondaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: kGreyColor3)),
              ),
              initialCountryCode: 'PK',
            ),
          ),
        ),
      ],
    );
  }
}
