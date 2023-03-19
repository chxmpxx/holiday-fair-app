  import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holiday_fair/features/map/controllers/map_controller.dart';
import 'package:location/location.dart';

void getCurrentLocation(controller, MapController mapProvider) async {
    Location location = Location();

    location.getLocation().then((location) {
      mapProvider.setCurrentLocation(location);
    });

    GoogleMapController googleMapController = await controller.future;

    location.onLocationChanged.listen((newLoc) {
      mapProvider.setCurrentLocation(newLoc);

      // update camera to new position
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 18,
            target: LatLng(newLoc.latitude!, newLoc.longitude!)
          )
        )
      );
    });
  }