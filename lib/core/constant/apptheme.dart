import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

// ThemeData themeArabic = ThemeData(
//   fontFamily: "Cairo",
//   textTheme:  TextTheme(
//       headli: TextStyle(ne1fontSize: 12, color: AppColor.PrimaryColor),
//       headline2: TextStyle(fontSize: 20, color: AppColor.PrimaryColor),
//       bodyText1: TextStyle(height: 2, color: AppColor.DeepPurple, fontSize: 12),
//       bodyText2:
//           TextStyle(height: 2, color: AppColor.PrimaryColor, fontSize: 12)),
//   primarySwatch: Colors.blue,
// );

ThemeData themeArabic = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColor.PrimaryColor, // Set your primary color here
    background: Colors.white,
    surface: Colors.white,

    onPrimary: Colors.white, // Optional: text/icon color on primary
    onBackground: Colors.black, // Optional: text color on background
  ),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Cairo',
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ), // This ensures icons in AppBar are also white
  ),
  // textTheme: TextTheme(
  //   headline1: TextStyle(fontSize: 12, color: AppColor.PrimaryColor), // Corrected the key from 'headli' to 'headline1'
  //   headline2: TextStyle(fontSize: 20, color: AppColor.PrimaryColor),
  //   bodyText1: TextStyle(height: 2, color: AppColor.DeepPurple, fontSize: 12),
  //   bodyText2: TextStyle(height: 2, color: AppColor.PrimaryColor, fontSize: 12),
  // ),
  primarySwatch: Colors
      .blue, // Optional: Keep if you need primary swatch for Material components
);
