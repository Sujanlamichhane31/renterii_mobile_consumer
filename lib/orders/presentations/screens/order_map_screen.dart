import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/Themes/style.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/map_utils.dart';
import 'package:renterii/orders/data/models/order.dart';
import 'package:renterii/rentals/business_logic/cubit/order_bloc.dart';
import 'package:renterii/rentals/business_logic/cubit/order_state.dart';

class OrderMapScreen extends StatelessWidget {
  final Order order;
  const OrderMapScreen({required this.order, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: OrderMap(
        order: order,
      ),
    );
  }
}

class OrderMap extends StatefulWidget {
  final Order order;

  OrderMap({required this.order});

  @override
  _OrderMapState createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  bool sliderOpen = false;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;
  final Set<Marker> _markers = {};

  Map<MarkerId, Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late double _userLatitude, _userLongitude, _shopLatitude, _shopLongitude;

  @override
  void initState() {
    super.initState();

    print('ORDER ${widget.order}');
    print('ORDER SHOP ${widget.order.shop}');
    final user = context.read<UserCubit>().state.user;

    if (user.latitude == null || user.longitude == null) {
      return;
    }

    _userLatitude = user.latitude!;
    _userLongitude = user.longitude!;
    _shopLatitude = widget.order.shop['latitude'];
    _shopLongitude = widget.order.shop['longitude'];

    _addMarker(
      LatLng(
        _userLatitude,
        _userLongitude,
      ),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    _addMarker(
      LatLng(_shopLatitude, _shopLongitude),
      "destination",
      markerss.first,
    );
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          titleSpacing: 0.0,
          title: null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.3),
                  child: FadedScaleAnimation(
                    child: Image.network(
                      widget.order.shop['imageUrl'],
                      height: 42.3,
                      width: 33.7,
                    ),
                    fadeDuration: const Duration(milliseconds: 800),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      widget.order.shop['name'],
                      //AppLocalizations.of(context)!.store!,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          letterSpacing: 0.07, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      //'20 June, 11:35am',
                      widget.order.createdAt!.toDate().toLocal().toString(),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 11.7,
                          letterSpacing: 0.06,
                          color: const Color(0xffc1c1c1)),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        FadedScaleAnimation(
                          child: Text(
                            AppLocalizations.of(context)!.pickup!,
                            style: orderMapAppBarTextStyle.copyWith(
                              color: kMainColor,
                            ),
                          ),
                          fadeDuration: const Duration(milliseconds: 800),
                        ),
                        const SizedBox(height: 7.0),
                        Text(
                          '\$ ${widget.order.total}',
                          //'\$ 21.00 | ${AppLocalizations.of(context)!.paypal}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontSize: 11.7,
                                  color: const Color(0xffc1c1c1)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                BlocBuilder<OrderMapBloc, OrderMapState>(
                    builder: (context, state) {
                  print('polyyyy' + state.polylines.toString());
                  return GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _userLatitude,
                        _userLongitude,
                      ),
                      zoom: 15.5,
                    ),
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) async {
                      _mapController.complete(controller);
                      mapStyleController = controller;
                      mapStyleController!.setMapStyle(mapStyle);
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _addMarker(LatLng position, String id, descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.amber,
        width: 3,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB8HZG30Vs2l7AyxnjvNKh1t0sMZFhuKio',
      PointLatLng(_userLatitude, _userLongitude),
      PointLatLng(_shopLatitude, _shopLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
