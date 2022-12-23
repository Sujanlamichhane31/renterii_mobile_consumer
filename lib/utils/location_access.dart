import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationAccess {
  String currentAddress = '';
  LatLng currentCoordinate = LatLng(43.635310, -79.402080);

  Future<String> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      List<Placemark> p =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      currentCoordinate = LatLng(position.latitude, position.longitude);
      Placemark place = p[1];
      currentAddress =
          "${place.name},${place.subAdministrativeArea},${place.administrativeArea}";

      // ref.read(userLocation.state).state = currentAddress;
      debugPrint('address $currentAddress');
      return currentAddress;
    }).catchError((e) {
      debugPrint('Location error $e');
    });
    return currentAddress;
  }

  Future<LatLng> getCurrentLatLng() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      List<Placemark> p =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      currentCoordinate = LatLng(position.latitude, position.longitude);

      return currentCoordinate;
    }).catchError((e) {
      debugPrint('Location error $e');
    });
    return currentCoordinate;
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      debugPrint('Permission Granted');
      getCurrentLocation();
      getCurrentLatLng();
    } else if (status == PermissionStatus.denied) {
      debugPrint('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      debugPrint('Permission Permanently Denied');
      await openAppSettings();
    }
  }
}
