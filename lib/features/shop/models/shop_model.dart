import 'dart:convert';

import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

List<ShopModel> shopListModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ShopModel>.from(data.map((shop) => ShopModel.fromJson(shop)));
}

class ShopModel {
  int id;
  String name;
  String zone;
  int rating;
  double latitude;
  double longitude;
  String image;
  double distance;

  ShopModel({
    required this.id,
    required this.name,
    required this.zone,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.image,
    this.distance = 0,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json["id"],
      name: json["name"],
      zone: json["zone"],
      rating: json["rating"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      image: json["image"] ?? 'assets/images/shop_image.png',
    );
  }

  double distanceTo(Position position) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      position.latitude,
      position.longitude,
    );
  }
}
