import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holiday_fair/constants/data/api_key.dart';
import 'package:holiday_fair/constants/themes/colors.dart';
import 'package:holiday_fair/features/map/controllers/map_controller.dart';
import 'package:holiday_fair/features/map/widgets/floating_btn_widget.dart';
import 'package:holiday_fair/features/map/widgets/panel_widget.dart';
import 'package:holiday_fair/features/shop/controllers/shop_controller.dart';
import 'package:holiday_fair/features/shop/models/shop_model.dart';
import 'package:holiday_fair/utils/get_current_location.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String arg = ModalRoute.of(context)!.settings.arguments as String;

    var mapProvider = Provider.of<MapController>(context, listen: false);
    final Completer<GoogleMapController> controller = Completer();

    getCurrentLocation(controller, mapProvider);
    setCustomMarkerIcon(mapProvider);

    return Scaffold(
      backgroundColor: kColorsWhite,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        title: Text('Map', style: Theme.of(context).textTheme.headline1),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: kColorsBlue,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/btn_back.svg', color: kColorsWhite),
          onPressed: (){
            Navigator.pushNamed(context, arg);
          },
        ),
      ),
      body: FutureBuilder(
        future: ShopController().getAllShops(context),
        builder: (BuildContext context, AsyncSnapshot<List<ShopModel>> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          else if(snapshot.connectionState == ConnectionState.done) {
            List<ShopModel> shopList = snapshot.data!;
            return mapBody(shopList, mapProvider, controller, context, arg);
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget mapBody(List<ShopModel> shopList, MapController mapProvider, controller, context, arg) {
    final PanelController panelController = PanelController();

    if (mapProvider.selectedShop != null && mapProvider.currentLocation != null) {
      mapProvider.removePolylineCoordinates();
      getPolyPoints(mapProvider);
    }

    return Consumer<MapController>(
      builder: (_, value, __) {
        Map<MarkerId, Marker> markers = {};
        if (mapProvider.currentLocation == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          markers = getMarker(shopList, mapProvider);
        
          return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(mapProvider.currentLocation!.latitude!, mapProvider.currentLocation!.longitude!), zoom: 18),
              markers: Set<Marker>.of(markers.values),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: mapProvider.polylineCoordinates,
                  color: kColorsBlue,
                  width: 6
                )
              },
              onMapCreated: (mapController) {
                if (!controller.isCompleted) {
                  controller.complete(mapController);
                }
              },
              onTap: (LatLng latLng) {
                // hide the sliding panel when the map is tapped
                mapProvider.setSelectedShop(null);
                mapProvider.removePolylineCoordinates();
              },
              zoomControlsEnabled: false,
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  floatingBtnWidget(Icons.add, () async {
                    GoogleMapController googleMapController = await controller.future;
                    googleMapController.animateCamera(CameraUpdate.zoomIn());
                  }),
                  const SizedBox(height: 6),
                  floatingBtnWidget(Icons.remove, () async {
                    GoogleMapController googleMapController = await controller.future;
                    googleMapController.animateCamera(CameraUpdate.zoomOut());
                  }),
                ],
              ),
            ),
            mapProvider.selectedShop != null ? SlidingUpPanel(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              controller: panelController,
              minHeight: MediaQuery.of(context).size.width * 0.32,
              maxHeight: MediaQuery.of(context).size.width * 0.32,
              panelBuilder: (scrollController) {
                return panelWidget(context, mapProvider.selectedShop!);
                },
              ) : Container()
            ],
          );
        }
      }
    );
  }

  // void getCurrentLocation(controller, MapController mapProvider) async {
  //   Location location = Location();

  //   location.getLocation().then((location) {
  //     mapProvider.setCurrentLocation(location);
  //   });

  //   GoogleMapController googleMapController = await controller.future;

  //   location.onLocationChanged.listen((newLoc) {
  //     mapProvider.setCurrentLocation(newLoc);

  //     // update camera to new position
  //     googleMapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           zoom: 18,
  //           target: LatLng(newLoc.latitude!, newLoc.longitude!)
  //         )
  //       )
  //     );
  //   });
  // }

  void setCustomMarkerIcon(MapController mapProvider) {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/pin_shop_1.png").then(
      (icon) => mapProvider.destinationIcon = icon
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/pin_shop_2.png").then(
      (icon) => mapProvider.shopIcon = icon
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/pin_user.png").then(
      (icon) => mapProvider.userIcon = icon
    );
  }

  void getPolyPoints(MapController mapProvider) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(mapProvider.currentLocation!.latitude!, mapProvider.currentLocation!.longitude!),
      PointLatLng(mapProvider.selectedShop!.latitude, mapProvider.selectedShop!.longitude)
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        mapProvider.setPolylineCoordinates(point);
      }
    }
  }

  Map<MarkerId, Marker> getMarker(List<ShopModel> shopList, MapController mapProvider) {
    // create shop marker
    Map<MarkerId, Marker> markers = {};
    for (int i = 0; i < shopList.length; i++) {
      ShopModel shop = shopList[i];
      Marker marker = Marker(
        markerId: MarkerId(shop.name),
        position: LatLng(shop.latitude, shop.longitude),
        infoWindow: InfoWindow(title: shop.name),
        icon: (mapProvider.selectedShop != null && mapProvider.selectedShop!.id == shop.id) ? mapProvider.destinationIcon : mapProvider.shopIcon,
        onTap: () {
          mapProvider.setSelectedShop(shop);
          mapProvider.removePolylineCoordinates();
          getPolyPoints(mapProvider);
        },
      );
      markers[marker.markerId] = marker;
    }

    // create user marker
    Marker marker = Marker(
      markerId: const MarkerId("currentLocation"),
      position: LatLng(mapProvider.currentLocation!.latitude!, mapProvider.currentLocation!.longitude!),
      icon: mapProvider.userIcon,
    );
    markers[marker.markerId] = marker;

    return markers;
  }
}