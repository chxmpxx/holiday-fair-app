import 'package:holiday_fair/constants/themes/colors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Inter',
    
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: kColorsWhite),
      headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: kColorsBlack),

      subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: kColorsBlack),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: kColorsBlack),

      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: kColorsBlack),
      bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: kColorsBlack),
    )

  );
}