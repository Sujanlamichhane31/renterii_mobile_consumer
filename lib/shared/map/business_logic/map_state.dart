part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

class MapAddressLoading extends MapState {
  @override
  List<Object> get props => [];
}

class MapAddressFetchedFromLatLng extends MapState {
  final String address;

  const MapAddressFetchedFromLatLng({required this.address});

  @override
  List<Object> get props => [address];
}

class MapMarkersLoading extends MapState {
  const MapMarkersLoading();

  @override
  List<Object> get props => [];
}

class MapMarkersFetched extends MapState {
  final Set<Marker> markers;

  const MapMarkersFetched({required this.markers});

  @override
  List<Object> get props => [markers];
}

class MapMarkerSelected extends MapState {
  final Set<Marker> markers;
  final Shop selectedShop;

  const MapMarkerSelected({
    required this.markers,
    required this.selectedShop,
  });

  @override
  List<Object> get props => [
        markers,
        selectedShop,
      ];
}
