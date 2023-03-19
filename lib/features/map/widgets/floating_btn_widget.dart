import 'package:flutter/material.dart';
import 'package:holiday_fair/constants/themes/colors.dart';

Widget floatingBtnWidget(IconData icons, onPressed) {
  return FloatingActionButton.small(
    heroTag: null,
    backgroundColor: kColorsWhite,
    // elevation: 0,
    shape: RoundedRectangleBorder(
      side: const BorderSide(width: 1, color: kColorsDarkGrey),
      borderRadius: BorderRadius.circular(100)
    ),
    onPressed: onPressed,
    child: Icon(icons, color: kColorsBlack),
  );
}