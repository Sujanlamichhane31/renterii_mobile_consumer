import 'dart:async';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/authentication/business_logic/cubit/signup/signup_cubit.dart';
// import 'package:renterii/authentication/business_logic/cubit/order_bloc.dart';
// import 'package:renterii/authentication/business_logic/cubit/order_state.dart';
import 'package:renterii/authentication/presentation/widgets/address_type_button.dart';
import 'package:renterii/authentication/presentation/widgets/bottom_bar.dart';
import 'package:renterii/authentication/presentation/widgets/entry_field.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';

import '../../../rentals/presentation/screens/shops_map_screen.dart';
import '../../../shared/map/business_logic/map_bloc.dart';
import '../../../shared/utils/geolocator.dart';
import '../../business_logic/cubit/user/user_cubit.dart';

AddressType selectedAddressType = AddressType.Other;

class LocationScreen extends StatelessWidget implements AutoRouteWrapper {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        shopCubit: context.read<ShopCubit>(),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return BlocProvider<OrderMapBloc>(
    //   create: (context) => OrderMapBloc()..loadMap(),
    //   child: SetLocation(),
    // );
    return const SetLocation();
  }
}

class SetLocation extends StatefulWidget {
  const SetLocation({Key? key}) : super(key: key);

  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  HttpClient httpClient = HttpClient();
  bool isCard = false;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  Set<Marker> _markers = {};
  String address = '';
  late LatLng latLng;

  @override
  void initState() {
    super.initState();
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
        titleSpacing: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.setLocation!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupLocationSuccess) {
            context.router.replaceNamed('app');
          } else if (state is SignupLocationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text('An error occurred!'),
              ),
            );
          }
        },
        builder: (context, state) {
          return FadedSlideAnimation(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
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
                        GoogleMap(
                          // polylines: state.polylines,
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          onCameraMove: (cameraPosition) {
                            latLng = cameraPosition.target;
                            context.read<MapBloc>().add(
                                  FetchAddressFromLatLng(
                                    latitude: latLng.latitude,
                                    longitude: latLng.longitude,
                                  ),
                                );
                          },
                          initialCameraPosition: kGooglePlex,
                          // markers: _markers,
                          onMapCreated: (GoogleMapController controller) async {
                            // _mapController.complete(controller);
                            mapController = controller;
                            mapController!.setMapStyle(mapStyle);

                            final Position userPosition =
                                await getUserCurrentPosition();
                            final double latitude;
                            final double longitude;

                            print('STATE $state');

                            if (state is! UpdatingLocation) {
                              latitude = userPosition.latitude;
                              longitude = userPosition.longitude;
                            } else {
                              latitude = state.latitude;
                              longitude = state.longitude;
                              selectedAddressType =
                                  AddressType.values.firstWhere(
                                (element) =>
                                    element.name.toLowerCase() ==
                                    state.addressType.toLowerCase(),
                              );
                            }

                            await mapController!.moveCamera(
                              CameraUpdate.newLatLng(
                                LatLng(
                                  latitude,
                                  longitude,
                                ),
                              ),
                            );

                            context.read<MapBloc>().add(
                                  FetchAddressFromLatLng(
                                    latitude: latitude,
                                    longitude: longitude,
                                  ),
                                );
                          },
                        ),
                        // );
                        // }),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 36.0),
                            child: FadedScaleAnimation(
                              child: Image.asset(
                                'images/user_map_pin.png',
                                height: 36,
                              ),
                              fadeDuration: const Duration(milliseconds: 800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        FadedScaleAnimation(
                          child: Image.asset(
                            'images/user_map_pin.png',
                            scale: 15,
                          ),
                          fadeDuration: const Duration(milliseconds: 800),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: BlocBuilder<MapBloc, MapState>(
                            builder: (context, state) {
                              address = state is MapAddressFetchedFromLatLng
                                  ? state.address
                                  : '';

                              return Text(
                                address,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SaveAddressCard(),
                  BottomBar(
                    text: state is! UpdatingLocation
                        ? AppLocalizations.of(context)!.continueText
                        : 'Submit',
                    onTap: () {
                      context.read<SignupCubit>().updateUserLocation(
                            address: address,
                            addressType: selectedAddressType.name,
                            latitude: latLng.latitude,
                            longitude: latLng.longitude,
                            userId: context.read<UserCubit>().state.user.id,
                          );
                    },
                  ),
                ],
              ),
            ),
            beginOffset: const Offset(0.0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

class SaveAddressCard extends StatefulWidget {
  const SaveAddressCard({Key? key}) : super(key: key);

  @override
  _SaveAddressCardState createState() => _SaveAddressCardState();
}

class _SaveAddressCardState extends State<SaveAddressCard> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FadedSlideAnimation(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                if (state is MapAddressFetchedFromLatLng) {
                  _addressController.text = state.address;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: EntryField(
                    controller: _addressController,
                    textInputAction: TextInputAction.done,
                    label: AppLocalizations.of(context)!.addressLabel,
                  ),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.saveAddress!.toUpperCase(),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AddressTypeButton(
                    label: AppLocalizations.of(context)!.homeText,
                    image: 'images/address/icon_home.png',
                    onPressed: () {
                      setState(() {
                        selectedAddressType = AddressType.Home;
                      });
                    },
                    isSelected: selectedAddressType == AddressType.Home,
                  ),
                  AddressTypeButton(
                    label: AppLocalizations.of(context)!.office,
                    image: 'images/address/icon_work.png',
                    onPressed: () {
                      setState(() {
                        selectedAddressType = AddressType.Office;
                      });
                    },
                    isSelected: selectedAddressType == AddressType.Office,
                  ),
                  AddressTypeButton(
                    label: AppLocalizations.of(context)!.other,
                    image: 'images/address/icon_other_location.png',
                    onPressed: () {
                      setState(() {
                        selectedAddressType = AddressType.Other;
                      });
                    },
                    isSelected: selectedAddressType == AddressType.Other,
                  ),
                ],
              ),
            )
          ],
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
