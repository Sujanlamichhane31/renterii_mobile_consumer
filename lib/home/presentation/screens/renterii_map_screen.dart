import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/home/presentation/widgets/categories_list_view.dart';
import 'package:renterii/home/presentation/widgets/shop_box.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/utils/constant.dart';
import 'package:renterii/utils/location_access.dart';

import '../../../Themes/colors.dart';
import '../../../authentication/presentation/widgets/bottom_bar.dart';
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
  double distanceBetween = 300.0;
  CameraPosition? cameraPosition;

  dynamic user;
  LatLng _currentCoordinate = LocationAccess().currentCoordinate;

  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state.user;
    currentLocation();
    context.read<MapBloc>().add(
          FetchMapMarkers(
            userLatitude: user.latitude,
            userLongitude: user.longitude,
          ),
        );
  }

  double getDistance(double lat2, double lon2) {
    if (user != null && user.latitude != null && user.longitude != null) {
      return Geolocator.distanceBetween(
              user.latitude!, user.longitude!, lat2, lon2) /
          1000;
    } else {
      return Geolocator.distanceBetween(32, 5, lat2, lon2) / 1000;
    }
  }

  List<Shop> shopList = [];

  List<Marker> markerList = [];
  List<Marker> categoryMarkerList = [];

  currentLocation() async {
    await LocationAccess().requestLocationPermission();
    final status = await Permission.locationWhenInUse.request();
    address = await LocationAccess().getCurrentLocation();
    _currentCoordinate = await LocationAccess().getCurrentLatLng();
    setState(() {});
    customMarker();
  }

  customMarker() async {
    Future<Uint8List> getBytesFromAsset(String path, int width) async {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    }

    final Uint8List markerbitmap =
        await getBytesFromAsset('images/logo_marker.png', 90);
    markerList.add(Marker(
        markerId: const MarkerId(currentAddress),
        icon: BitmapDescriptor.fromBytes(markerbitmap),
        position:
            LatLng(_currentCoordinate.latitude, _currentCoordinate.longitude)));
    categoryMarkerList.add(Marker(
        markerId: const MarkerId(currentAddress),
        icon: BitmapDescriptor.fromBytes(markerbitmap),
        position:
            LatLng(_currentCoordinate.latitude, _currentCoordinate.longitude)));
  }

  addMarker({required List<Shop> result, required bool isCategory}) {
    markerList
        .removeWhere((element) => element.markerId.value != currentAddress);
    categoryMarkerList
        .removeWhere((element) => element.markerId.value != currentAddress);

    for (var index = 0; index < result.length; index++) {
      log("result: ${result[index].title},${result[index].address}");
      if (result[index].lat != 0.0 && result[index].lng != 0.0) {
        if (isCategory) {
          categoryMarkerList.add(Marker(
              markerId: MarkerId(result[index].id.toString()),
              position: LatLng(
                result[index].lat,
                result[index].lng,
              ),
              infoWindow: InfoWindow(
                  title: "${result[index].title}, ${result[index].address}")));
        }
        markerList.add(Marker(
            markerId: MarkerId(result[index].id.toString()),
            position: LatLng(
              result[index].lat,
              result[index].lng,
            ),
            infoWindow: InfoWindow(
                title: "${result[index].title}, ${result[index].address}")));
      }
    }
    customMarker();
    return isCategory ? categoryMarkerList : markerList;
  }

  shopAround({required List<Shop> shops, required BuildContext context}) {
    shopList.clear();
    shopList =
        shops.where((shop) => getDistance(shop.lat, shop.lng) <= 300).toList();
    if (shopList.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Searching shops?"),
              content: const Text("No shops Near 300KM from you!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Okay"))
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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
                user = state.user;
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
                          BlocBuilder<ShopCubit, ShopState>(
                              builder: (context, state) {
                            if (state is ShopLoaded) {
                              addMarker(result: state.shops, isCategory: false);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                shopAround(
                                    shops: state.shops, context: context);
                              });
                              return Stack(
                                children: [
                                  GoogleMap(
                                    markers: Set<Marker>.of(markerList),
                                    mapType: MapType.normal,
                                    zoomControlsEnabled: false,
                                    onCameraMove: (cameraPositiona) {
                                      cameraPosition = cameraPositiona;
                                    },
                                    initialCameraPosition:
                                        _currentCoordinate.latitude == null
                                            ? kGooglePlex
                                            : CameraPosition(
                                                target: LatLng(
                                                    _currentCoordinate.latitude,
                                                    _currentCoordinate
                                                        .longitude),
                                                zoom: 15),
                                    onMapCreated: (controller) {
                                      //method called when map is created
                                      setState(() {
                                        mapController = controller;
                                      });
                                    },
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        currentLocation();
                                        mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        _currentCoordinate
                                                            .latitude,
                                                        _currentCoordinate
                                                            .longitude),
                                                    zoom: 15)));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.gps_fixed_rounded,
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else if (state is ShopsByCategoryLoaded) {
                              addMarker(result: state.shops, isCategory: true);

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                shopAround(
                                    shops: state.shops, context: context);
                              });
                              return Stack(
                                children: [
                                  GoogleMap(
                                    markers: Set<Marker>.of(categoryMarkerList),
                                    mapType: MapType.normal,
                                    zoomControlsEnabled: false,
                                    onCameraMove: (cameraPositiona) {
                                      cameraPosition = cameraPositiona;
                                    },
                                    initialCameraPosition:
                                        _currentCoordinate.latitude == null
                                            ? kGooglePlex
                                            : CameraPosition(
                                                target: LatLng(
                                                    _currentCoordinate.latitude,
                                                    _currentCoordinate
                                                        .longitude),
                                                zoom: 15),
                                    onMapCreated: (controller) {
                                      //method called when map is created
                                      setState(() {
                                        mapController = controller;
                                      });
                                    },
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        currentLocation();
                                        mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        _currentCoordinate
                                                            .latitude,
                                                        _currentCoordinate
                                                            .longitude),
                                                    zoom: 15)));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.gps_fixed_rounded,
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
                          List<Shop> aroundShops = state.shops
                              .where((shop) =>
                                  getDistance(shop.lat, shop.lng) <=
                                  distanceBetween)
                              .toList();
                          return Column(
                            children: [
                              aroundShops.isNotEmpty
                                  ? const Text(
                                      "Shops around 300 KM from you",
                                      style: TextStyle(fontSize: 8.0),
                                    )
                                  : Column(
                                      children: [
                                        const Text(
                                          "No Shops around 300 KM from you",
                                          style: TextStyle(fontSize: 8.0),
                                        ),
                                        BottomBar(
                                            text: "Go to Home Screen",
                                            onTap: () {
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                              aroundShops.isNotEmpty
                                  ? const SizedBox(
                                      height: 5.0,
                                    )
                                  : const SizedBox(),
                              aroundShops.isNotEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          ...aroundShops.map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: ShopBox(shop: e)))
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          );
                        } else if (state is ShopsByCategoryLoaded) {
                          List<Shop> aroundShops = state.shops
                              .where((shop) =>
                                  getDistance(shop.lat, shop.lng) <=
                                  distanceBetween)
                              .toList();
                          return Column(
                            children: [
                              aroundShops.isNotEmpty
                                  ? const Text(
                                      "Shops around 300 KM from you",
                                      style: TextStyle(fontSize: 8.0),
                                    )
                                  : Column(
                                      children: [
                                        const Text(
                                          " around 300 KM from you",
                                          style: TextStyle(fontSize: 8.0),
                                        ),
                                        BottomBar(
                                            text: "Go to Home Screen",
                                            onTap: () {
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                              aroundShops.isNotEmpty
                                  ? const SizedBox(
                                      height: 5.0,
                                    )
                                  : const SizedBox(),
                              aroundShops.isNotEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          ...aroundShops.map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: ShopBox(shop: e)))
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                            ],
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
