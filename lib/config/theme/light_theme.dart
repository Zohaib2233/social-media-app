import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  fontFamily: AppFonts.Poppins,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: kPrimaryColor,
  ),
  splashColor: kPrimaryColor.withOpacity(0.10),
  highlightColor: kPrimaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.1),
  ),

  // textSelectionTheme: TextSelectionThemeData(
  //   cursorColor: kBlackColor2,
  // ),
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey.withOpacity(0.8),
  fontFamily: AppFonts.Poppins,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.grey.withOpacity(0.1),
  ),
  splashColor: Colors.grey.withOpacity(0.8),
  highlightColor: Colors.grey.withOpacity(0.8),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.1),
  ),

  // textSelectionTheme: TextSelectionThemeData(
  //   cursorColor: kBlackColor2,
  // ),
);
