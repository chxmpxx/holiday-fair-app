import 'package:flutter/material.dart';
import 'package:holiday_fair/constants/themes/colors.dart';
import 'package:holiday_fair/features/shop/models/shop_model.dart';

Widget panelWidget(context, ShopModel shop) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: AssetImage(shop.image),
              fit: BoxFit.cover
            )
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shop.name, style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 5),
            Text('${shop.zone} zone', style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: kColorsRed, size: 16),
                Text('${shop.distance.toStringAsFixed(2)} km', style: Theme.of(context).textTheme.bodyText2),
                const SizedBox(width: 10),
                const Icon(Icons.star, color: kColorsYellow, size: 16),
                Text(shop.rating.toString(), style: Theme.of(context).textTheme.bodyText2),
              ],
            )
          ],
        )
      ],
    ),
  );
}