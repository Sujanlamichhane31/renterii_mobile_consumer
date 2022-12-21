import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );
}

Future<Map<String, dynamic>> getAddressDataFromLatLng({
  required double latitude,
  required double longitude,
}) async {
  print(latitude);
  print(longitude);
  final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
    'latlng': '$latitude,$longitude',
    'key': 'AIzaSyB8HZG30Vs2l7AyxnjvNKh1t0sMZFhuKio',
  });

  HttpClientRequest request = await HttpClient().getUrl(uri);

  HttpClientResponse response = await request.close();
  // Process the response
  final String stringData = await response.transform(utf8.decoder).join();
  final Map<String, dynamic> mapData =
      json.decode(stringData) as Map<String, dynamic>;

  return mapData["results"][0];
}

Future<Position> getUserCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print('MAP SERVICE ENABLED: $serviceEnabled');

  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
