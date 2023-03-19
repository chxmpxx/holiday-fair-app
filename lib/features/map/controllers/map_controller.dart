import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holiday_fair/features/shop/models/shop_model.dart';
import 'package:location/location.dart';

class MapController with ChangeNotifier {
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  ShopModel? selectedShop;

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor shopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;

  setCurrentLocation(LocationData data) {
    currentLocation = data;
    notifyListeners();
  }

  setPolylineCoordinates(PointLatLng point) {
    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    notifyListeners();
  }

  removePolylineCoordinates() {
    polylineCoordinates = [];
    // notifyListeners();
  }

  setSelectedShop(shop) {
    selectedShop = shop;
    notifyListeners();
  }
}