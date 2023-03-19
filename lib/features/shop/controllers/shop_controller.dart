import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:holiday_fair/features/shop/models/shop_model.dart';
import 'package:holiday_fair/utils/calculate_distance.dart';

class ShopController {
  Future<List<ShopModel>> getAllShops(context) async {
    String data = await DefaultAssetBundle.of(context).loadString('assets/data/data.json');
    List<ShopModel> stores = shopListModelFromJson(data);

    Position currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // get distance between current location and shop location
    final List<ShopModel> shopsWithDistance = [];
    for (final store in stores) {
      final distance = calculateDistance(currentLocation.latitude, currentLocation.longitude, store.latitude, store.longitude);
      store.distance = distance;
      shopsWithDistance.add(store);
    }

    // sort stores by distance from current location
    shopsWithDistance.sort((storeA, storeB) => storeA.distance.compareTo(storeB.distance));

    return shopsWithDistance;
  }
}