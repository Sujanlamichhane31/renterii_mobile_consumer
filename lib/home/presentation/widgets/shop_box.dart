import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Locale/locales.dart';
import '../../../Themes/colors.dart';
import '../../../routes/app_router.gr.dart';
import '../../../shops/data/models/shop.dart';

class ShopBox extends StatelessWidget {
  final Shop shop;
  final LatLng? userLatLng;

  const ShopBox({
    Key? key,
    required this.shop,
    this.userLatLng,
  }) : super(key: key);

  double getDistance(double lat2, double lon2) {
    if (userLatLng == null) {
      return -1;
    }

    return Geolocator.distanceBetween(
            userLatLng!.latitude, userLatLng!.longitude, lat2, lon2) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    final distance = getDistance(shop.lat, shop.lng).round();
    return GestureDetector(
      onTap: () {
        dynamic totalRating = 0;
        for (dynamic rating in shop.rating) {
          totalRating += rating['start'];
        }
        context.router.push(ShopScreenRoute(
          rating: totalRating != 0
              // ? (totalRating / shop.rating.length).toDouble() ?? 0
              ? (totalRating / shop.rating.length).toStringAsFixed(1) ?? '0'
              : '0',
          ratingNumber: shop.rating.length,
          id: shop.id,
          name: shop.title,
          //isBooking: true,
          lat: shop.lat,
          long: shop.lng,
          address: shop.address,
          description: shop.description,
          reference: shop.category,
        ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            image: NetworkImage(shop.imageUrl),
            height: 62.5,
          ),
          const SizedBox(width: 13.3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                shop.title,
                //AppLocalizations.of(context)!.store!,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                // AppLocalizations.of(context)!.type!,
                shop.categoryName,

                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: kLightTextColor,
                      fontSize: 10.0,
                    ),
              ),
              const SizedBox(height: 10.3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: kIconColor,
                    size: 13,
                  ),
                  const SizedBox(width: 10.0),
                  distance > -1
                      ? Text(
                          '$distance km',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                color: kLightTextColor,
                                fontSize: 10.0,
                              ),
                        )
                      : const Text(''),
                  Text(
                    '| ',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kMainColor,
                          fontSize: 10.0,
                        ),
                  ),
                  Text(
                    shop.address,
                    //AppLocalizations.of(context)!.storeAddress!,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kLightTextColor,
                          fontSize: 10.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
