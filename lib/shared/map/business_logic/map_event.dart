part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class FetchAddressFromLatLng extends MapEvent {
  final double latitude;
  final double longitude;

  const FetchAddressFromLatLng({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [];
}

class FetchMapMarkers extends MapEvent {
  final double? userLatitude;
  final double? userLongitude;

  const FetchMapMarkers({
    this.userLatitude,
    this.userLongitude,
  });

  @override
  List<Object> get props => [];
}

class SelectMarker extends MapEvent {
  final Set<Marker> markers;
  final Shop selectedShop;

  const SelectMarker({
    required this.markers,
    required this.selectedShop,
  });

  @override
  List<Object> get props => [];
}
