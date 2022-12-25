import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/authentication/presentation/widgets/bottom_bar.dart';
import 'package:renterii/authentication/presentation/widgets/custom_appbar.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/rentals/business_logic/cubit/order_bloc.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/utils/location_access.dart';
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
    return SetLocation();
  }
}

class SetLocation extends StatefulWidget {
  SetLocation(
      {this.textEditingController,
      this.isFromStoreProfile = false,
      this.lat,
      this.long});
  final bool? isFromStoreProfile;
  double? lat;
  double? long;
  final TextEditingController? textEditingController;
  @override
  _SetLocationState createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  HttpClient httpClient = HttpClient();
  bool isCard = false;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapController;
  String address = '';
  late LatLng latLng;
  LatLng _currentCoordinate = LocationAccess().currentCoordinate;

  @override
  void initState() {
    super.initState();
    customMarker();
    currentLocation();
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

  List<Shop> shopList = [];

  List<Marker> markerList = [];

  currentLocation() async {
    await LocationAccess().requestLocationPermission();
    final status = await Permission.locationWhenInUse.request();
    address = await LocationAccess().getCurrentLocation();
    widget.textEditingController!.text = address;
    _currentCoordinate = await LocationAccess().getCurrentLatLng();
    widget.lat = _currentCoordinate.latitude;
    widget.long = _currentCoordinate.longitude;
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
    widget.lat = _currentCoordinate.latitude;
    widget.long = _currentCoordinate.longitude;
    markerList.add(Marker(
        markerId: const MarkerId("current address"),
        icon: BitmapDescriptor.fromBytes(markerbitmap),
        position:
            LatLng(_currentCoordinate.latitude, _currentCoordinate.longitude)));
  }

  addMarker(List<Shop> result) {
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
    customMarker();
    return markerList;
  }

  final TextEditingController _messageController = TextEditingController();
  String googleApikey = "AIzaSyB8HZG30Vs2l7AyxnjvNKh1t0sMZFhuKio";
  GoogleMapController? mapStyleController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(27.6602292, 85.308027);
  String location = "";
  double? _lat;
  double? _lang;

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
              _lat = geometry.location.lat;
              _lang = geometry.location.lng;
              var newlatlang = LatLng(_lat!, _lang!);
              //move map camera to selected place with animation
              mapStyleController?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: newlatlang, zoom: 15)));
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
                BlocBuilder<ShopCubit, ShopState>(builder: (context, state) {
                  if (state is ShopLoaded) {
                    addMarker(state.shops);
                    return GoogleMap(
                      //Map widget from google_maps_flutter package
                      mapType: MapType.normal,
                      markers: Set<Marker>.of(markerList),
                      initialCameraPosition: widget.lat == null
                          ? kGooglePlex
                          : CameraPosition(
                              target: LatLng(widget.lat!, widget.long!),
                              zoom: 15),
                      zoomControlsEnabled: false,
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
                          cameraPosition!.target.longitude,
                        );
                        setState(() {
                          //get place name from lat and lang
                          _lat = cameraPosition!.target.latitude;
                          _lang = cameraPosition!.target.longitude;
                          widget.textEditingController!.text = location;
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
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
                Container(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      currentLocation();
                      mapStyleController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(_currentCoordinate.latitude,
                                  _currentCoordinate.longitude),
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
                Map latLongMap = {"lat": _lat, "long": _lang};
                Navigator.pop(context, latLongMap);
                widget.textEditingController!.text = location;
                context.read<UserCubit>().emitUpdatedUserInfos(
                    address: location, latitude: _lat, longitude: _lang);
              }),
        ],
      ),
    );
  }
}
