import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:holiday_fair/constants/themes/colors.dart';

Widget menuBtnWidget(context, text, img, ontap) {
  return InkWell(
    onTap: ontap,
    child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: kColorsWhite,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: kColorsDarkGrey, width: 1),
            image: DecorationImage(
              image: Svg('assets/icons/$img'),
              alignment: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 13, top: 13),
            child: Text(text, style: Theme.of(context).textTheme.headline2),
          ),
        )
      ],
    ),
  );
}