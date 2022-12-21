import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
// import 'package:renterii/authentication/business_logic/cubit/order_bloc.dart';
// import 'package:renterii/authentication/business_logic/cubit/order_state.dart';
import 'package:renterii/authentication/presentation/widgets/bottom_bar.dart';
import 'package:renterii/authentication/presentation/widgets/custom_appbar.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/rentals/business_logic/cubit/order_bloc.dart';
import 'package:renterii/rentals/business_logic/cubit/order_state.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import '../../../shared/map/business_logic/map_bloc.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class LocationScreen extends StatelessWidget implements AutoRouteWrapper {
  const LocationScreen(
      {Key? key, this.textEditingController, this.lat, this.long})
      : super(key: key);
  final TextEditingController? textEditingController;
  final double? lat;
  final double? long;
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
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: SetLocation(
        textEditingController: textEditingController,
        lat: lat,
        long: long,
      ),
    );
    return const SetLocation();
  }
}

class SetLocation extends StatefulWidget {
  const SetLocation(
      {this.textEditingController,
      this.isFromStoreProfile = false,
      this.lat,
      this.long});
  final bool? isFromStoreProfile;
  final double? lat;
  final double? long;
  final TextEditingController? textEditingController;
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

  final TextEditingController _messageController = TextEditingController();
  String googleApikey = "AIzaSyB8HZG30Vs2l7AyxnjvNKh1t0sMZFhuKio";
  GoogleMapController? mapStyleController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(27.6602292, 85.308027);
  String location = "Set Address";
  double? lat;
  double? lang;

  @override
  void dispose() {
    super.dispose();
    mapStyleController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//          extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(126.0),
        child: CustomAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleWidget: Text(
            AppLocalizations.of(context)!.setLocation!,
            style: const TextStyle(
                fontSize: 16.7,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          onTap: () async {
            var place = await PlacesAutocomplete.show(
                context: context,
                apiKey: googleApikey,
                mode: Mode.overlay,
                types: [],
                strictbounds: false,
                components: [Component(Component.country, 'ca')],
                //google_map_webservice package
                onError: (err) {
                  print(err);
                });

            if (place != null) {
              setState(() {
                location = place.description.toString();
              });

              //form google_maps_webservice package
              final plist = GoogleMapsPlaces(
                apiKey: googleApikey,
                apiHeaders: await GoogleApiHeaders().getHeaders(),
                //from google_api_headers package
              );
              String placeid = place.placeId ?? "0";
              final detail = await plist.getDetailsByPlaceId(placeid);
              final geometry = detail.result.geometry!;
              lat = geometry.location.lat;
              lang = geometry.location.lng;
              var newlatlang = LatLng(lat!, lang!);
              //move map camera to selected place with animation
              mapStyleController?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: newlatlang, zoom: 17)));
            }
          },
          hint: AppLocalizations.of(context)!.enterLocation,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                BlocBuilder<OrderMapBloc, OrderMapState>(
                    builder: (context, state) {
                  log('polyyyy${state.polylines}');

                  return GoogleMap(
                    //Map widget from google_maps_flutter package
                    mapType: MapType.normal,
                    initialCameraPosition: kGooglePlex,
                    onMapCreated: (controller) {
                      //method called when map is created
                      setState(() {
                        mapStyleController = controller;
                      });
                    },
                    onCameraMove: (CameraPosition cameraPositiona) {
                      cameraPosition = cameraPositiona; //when map is dragging
                    },
                    onCameraIdle: () async {
                      //when map drag stops
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              cameraPosition!.target.latitude,
                              cameraPosition!.target.longitude);
                      setState(() {
                        //get place name from lat and lang
                        lat = cameraPosition!.target.latitude;
                        lang = cameraPosition!.target.latitude;
                        location =
                            "${placemarks.first.street.toString()},${placemarks.first.subLocality.toString()},${placemarks.first.subAdministrativeArea.toString()},${placemarks.first.administrativeArea.toString()}";
                        log(location);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          // Do something

                          widget.textEditingController!.text = location;
                        });
                      });
                    },
                  );
                }),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: kCardBackgroundColor,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/map_pin.png',
                  scale: 2.5,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Text(
                    widget.textEditingController!.text.isNotEmpty
                        ? widget.textEditingController!.text
                        : location,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
          BottomBar(
              text: AppLocalizations.of(context)!.continueText,
              onTap: () async {
                Map latLongMap = {"lat": lat, "long": lang};
                Navigator.pop(context, latLongMap);
              }),
        ],
      ),
    );
  }
}
