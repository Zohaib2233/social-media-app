import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:soical_media_app/constants/app_colors.dart';
import 'package:soical_media_app/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  final List<dynamic>? items;
  String? selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor;
  Color? hintTextColor;
  final String? label;
  final bool haveLabel;

  CustomDropDown({
    super.key,
    this.hint = '',
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.hintTextColor,
    this.label,
    this.haveLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        haveLabel
            ? MyText(
                paddingBottom: 7,
                text: label ?? "lebel Text Here",
                size: 14,
                weight: FontWeight.w400,
                color: kPrimaryColor,
              )
            : SizedBox(),
        DropdownButton2(
          underline: InputDecorator(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: kGreyColor1.withOpacity(0.5))))),
          isDense: true,
          isExpanded: true,
          buttonStyleData: ButtonStyleData(
              height: 47.12,
              padding: EdgeInsets.only(left: 0),
              decoration: BoxDecoration(
                  //border: Border.all(),

                  // Border Decoration

                  // border: Border.all(
                  //   color: kGreyColor3,
                  // ),

                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5))),
          dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(5),
          )),
          menuItemStyleData: MenuItemStyleData(
            height: 47,
          ),
          items: items!
              .map(
                (item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: MyText(
                    text: item,
                    color: kGreyColor1,
                    size: 13.44,
                  ),
                ),
              )
              .toList(),
          hint: MyText(
            text: hint,
            color: kGreyColor1,
            size: 13.44,
          ),
          value: selectedValue,
          onChanged: onChanged,
          iconStyleData: IconStyleData(
              icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kGreyColor1,
          )),
        ),
      ],
    );
  }
}
