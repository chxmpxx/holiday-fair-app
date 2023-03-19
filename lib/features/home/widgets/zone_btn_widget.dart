import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:holiday_fair/constants/themes/colors.dart';

Widget zoneBtnWidget(context, text, img) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: (){},
    child: Column(
      children: [
        Container(
          alignment: Alignment.bottomRight,
          width: MediaQuery.of(context).size.width * 0.24,
          height: MediaQuery.of(context).size.width * 0.15,
          decoration: const BoxDecoration(
            color: kColorsGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Image(
            width: 46,
            height: 46,
            image: Svg('assets/icons/$img.svg', color: kColorsBlue),
          ),
        ),
        const SizedBox(height: 8),
        Text(text, style: Theme.of(context).textTheme.subtitle2),
      ],
    ),
  );
}