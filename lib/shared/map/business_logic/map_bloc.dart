import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../shops/data/models/shop.dart';
import '../../utils/geolocator.dart';
import '../../utils/image_utils.dart';

part 'map_event.dart';
part 'map_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final ShopCubit _shopCubit;

  MapBloc({
    required ShopCubit shopCubit,
    LatLng? userAddressLatLng,
  })  : _shopCubit = shopCubit,
        super(MapInitial()) {
    on<FetchAddressFromLatLng>(
      _onFetchAddressFromLatLng,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchMapMarkers>(_onFetchMapMarkers);
    on<SelectMarker>(_onSelectMarker);
  }

  Future<void> _onFetchAddressFromLatLng(
      FetchAddressFromLatLng event, emit) async {
    emit(MapAddressLoading());
    final addressData = await getAddressDataFromLatLng(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    final String address = addressData["formatted_address"];

    emit(
      MapAddressFetchedFromLatLng(address: address),
    );
  }

  Future<void> _onFetchMapMarkers(FetchMapMarkers event, emit) async {
    Future<void> emitMarkers() async {
      Set<Marker> markers = {};
      final List<Shop> shops = (_shopCubit.state as dynamic).shops;

      for (Shop shop in shops) {
        final imageBitMap = await getImageBitMapFromCategory(shop.categoryName);

        final marker = Marker(
            markerId: MarkerId(shop.id),
            position: LatLng(shop.lat, shop.lng),
            icon: imageBitMap,
            onTap: () {
              final selectedShop = shops.firstWhere((s) => s.id == shop.id);

              add(
                SelectMarker(
                  markers: (state as dynamic).markers,
                  selectedShop: selectedShop,
                ),
              );
            });

        markers.add(marker);
      }

      if (event.userLatitude != null && event.userLongitude != null) {
        final userAddressMarkerImage =
            await getImageBitMapFromPath('images/logo_marker.png', 96);
        final userAddressMarker = Marker(
          markerId: const MarkerId('userAddress'),
          position: LatLng(
            event.userLatitude!,
            event.userLongitude!,
          ),
          icon: userAddressMarkerImage,
        );

        markers.add(userAddressMarker);
      }

      emit(
        MapMarkersFetched(
          markers: markers,
        ),
      );
    }

    emit(const MapMarkersLoading());

    if (_shopCubit.state is! ShopLoaded ||
        _shopCubit.state is! ShopsByCategoryLoaded) {
      // await _shopCubit.getAllShops();
      await emitMarkers();
    } else {
      await emitMarkers();
    }
  }

  Future<void> _onSelectMarker(SelectMarker event, emit) async {
    emit(
      MapMarkerSelected(
        markers: event.markers,
        selectedShop: event.selectedShop,
      ),
    );
  }

  @override
  void onTransition(Transition<MapEvent, MapState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
