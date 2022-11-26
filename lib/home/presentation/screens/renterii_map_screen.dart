import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/presentation/widgets/bottom_bar.dart';
import 'package:renterii/home/presentation/widgets/categories_list_view.dart';
import 'package:renterii/home/presentation/widgets/shop_box.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/rentals/business_logic/cubit/shops/shops_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/shops/data/models/shop.dart';

import '../../../Themes/colors.dart';
import '../../../routes/app_router.gr.dart';
import '../../../shared/map/business_logic/map_bloc.dart';

class RenteriiMapScreen extends StatelessWidget implements AutoRouteWrapper {
  const RenteriiMapScreen({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    final userState = context.read<UserCubit>().state;

    return BlocProvider(
      create: (context) => MapBloc(
        shopCubit: context.read<ShopCubit>(),
      )..add(const FetchMapMarkers()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const RenteriiMap();
  }
}

class RenteriiMap extends StatefulWidget {
  const RenteriiMap({Key? key}) : super(key: key);

  @override
  _RenteriiMapState createState() => _RenteriiMapState();
}

class _RenteriiMapState extends State<RenteriiMap> {
  HttpClient httpClient = HttpClient();
  bool isCard = false;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  double distanceBetween = 200.0;
  dynamic user;

  double getDistance(double lat2, double lon2) {
    if (user != null && user.latitude != null && user.longitude != null) {
      return Geolocator.distanceBetween(
              user.latitude!, user.longitude!, lat2, lon2) /
          1000;
    } else {
      return Geolocator.distanceBetween(32, 5, lat2, lon2) / 1000;
    }
  }

  List<Marker> markerList = [];

  addMarker(List<Shop> result) {
    markerList.clear();
    for (var index = 0; index < result.length; index++) {
      log("result: ${result[index].title},${result[index].address}");
      if (result[index].lat != 0.0 && result[index].lng != 0.0) {
        markerList.add(Marker(
            markerId: MarkerId(result[index].id.toString()),
            position: LatLng(
              result[index].lat,
              result[index].lng,
            ),
            infoWindow: InfoWindow(
                title: "${result[index].title}, ${result[index].address}")));
        log("latitude: ${result[index].lat}");
      }
    }
    for (var i in markerList) {
      log('marker: ${i.position.latitude}}');
    }
    return markerList;
  }

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state.user;
    context.read<MapBloc>().add(
          FetchMapMarkers(
            userLatitude: user.latitude,
            userLongitude: user.longitude,
          ),
        );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _mapController.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//          extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: FadedScaleAnimation(
            child: Icon(Icons.location_on, color: kMainColor),
            fadeDuration: const Duration(milliseconds: 200),
          ),
        ),
        title: Row(
          children: [
            BlocBuilder<UserCubit, UserState>(
              buildWhen: (prevState, currState) =>
                  prevState.user.address != currState.user.address,
              builder: (context, state) {
                return Expanded(
                  child: Text(
                    state.user.address ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 15, color: Colors.grey[500]),
                  ),
                );
              },
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: FadedScaleAnimation(
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  context.router.push(SearchScreenRoute());
                },
              ),
              fadeDuration: const Duration(milliseconds: 200),
            ),
          ),
        ],
      ),
      body: FadedSlideAnimation(
        child: Column(
          children: [
            CategoriesListView(
              onTapCategory: () {
                context.read<MapBloc>().add(const FetchMapMarkers());
              },
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    const Size.fromHeight(126).height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          // BlocBuilder<OrderMapBloc, OrderMapState>(
                          //     builder: (context, state) {
                          //   print('polyyyy' + state.polylines.toString());
                          //   return
                          // BlocBuilder<MapBloc, MapState>(
                          //   buildWhen:
                          //       (MapState prevState, MapState currState) =>
                          //           currState is MapMarkersLoading ||
                          //           currState is MapMarkersFetched,
                          //   builder: (context, state) {
                          //     if (state is MapMarkersFetched) {
                          //       final marker = state.markers;
                          //       return BlocBuilder<ShopCubit, ShopState>(
                          //           builder: (context, state) {
                          //         if (state is ShopLoaded) {
                          //           addMarker(state.shops);

                          //           return GoogleMap(
                          //             // polylines: state.polylines,
                          //             markers: Set<Marker>.of(markerList),
                          //             mapType: MapType.normal,
                          //             myLocationEnabled: true,
                          //             myLocationButtonEnabled: true,
                          //             onCameraMove: (cameraPosition) {},
                          //             initialCameraPosition: kGooglePlex,
                          //             // markers: _markers,
                          //             onMapCreated: (GoogleMapController
                          //                 controller) async {
                          //               _mapController.complete(controller);
                          //               // mapController = controller;
                          //             },
                          //           );
                          //         }
                          //         return Container();
                          //       });
                          //     } else {
                          //       return const Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     }
                          //   },
                          // ),
                          BlocBuilder<ShopCubit, ShopState>(
                              builder: (context, state) {
                            if (state is ShopLoaded) {
                              addMarker(state.shops);
                              return GoogleMap(
                                // polylines: state.polylines,
                                markers: Set<Marker>.of(markerList),
                                mapType: MapType.normal,
                                // myLocationEnabled: true,
                                // myLocationButtonEnabled: true,
                                onCameraMove: (cameraPosition) {},
                                initialCameraPosition: kGooglePlex,
                                // markers: _markers,
                                onMapCreated:
                                    (GoogleMapController controller) async {
                                  _mapController.complete(controller);
                                  // mapController = controller;
                                },
                              );
                            } else if (state is ShopsByCategoryLoaded) {
                              addMarker(state.shops);
                              return GoogleMap(
                                // polylines: state.polylines,
                                markers: Set<Marker>.of(markerList),
                                mapType: MapType.normal,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                onCameraMove: (cameraPosition) {},
                                initialCameraPosition: kGooglePlex,
                                // markers: _markers,
                                onMapCreated:
                                    (GoogleMapController controller) async {
                                  _mapController.complete(controller);
                                  // mapController = controller;
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      color: Theme.of(context).cardColor,
                                      margin: const EdgeInsets.only(
                                        bottom: 60.0,
                                      ),
                                      child: BlocBuilder<MapBloc, MapState>(
                                        builder: (ctx, state) {
                                          if (state is! MapMarkerSelected) {
                                            return Container();
                                          }

                                          final user = context
                                              .read<UserCubit>()
                                              .state
                                              .user;

                                          LatLng? userLatLng;

                                          if (user.longitude == null ||
                                              user.latitude == null) {
                                            userLatLng = null;
                                          } else {
                                            userLatLng = LatLng(user.latitude!,
                                                user.longitude!);
                                          }

                                          return ShopBox(
                                            shop: state.selectedShop,
                                            userLatLng: userLatLng,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<ShopCubit, ShopState>(
                      builder: (context, state) {
                        if (state is ShopLoaded) {
                          return BottomBar(
                            text: 'Shops around you',
                            color: kCardBackgroundColor,
                            textColor: Colors.black,
                            onTap: () {
                              print("HEELLOOO");
                              // context.router.pop();
                              print(state.shops);
                              List<Shop> aroundShops = state.shops
                                  .where((shop) =>
                                      getDistance(shop.lat, shop.lng) <=
                                      distanceBetween)
                                  .toList();
                              print(aroundShops);
                              context.router.push(
                                ShopsArroundPopularScreenRoute(
                                  pageTitle: 'Shops Around You',
                                  isBooking: true,
                                  shops: aroundShops,
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
