import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/business_logic/cubit/product/product_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';

import '../../data/models/shop.dart';
// import 'package:renterii/Pages/items.dart';

class ShopsArroundPopularScreen extends StatefulWidget {
  final String pageTitle;
  final bool? isBooking;
  final List<Shop> shops;

  const ShopsArroundPopularScreen(
      {Key? key, required this.pageTitle, this.isBooking, required this.shops})
      : super(key: key);

  @override
  State<ShopsArroundPopularScreen> createState() =>
      _ShopsArroundPopularScreenState();
}

class _ShopsArroundPopularScreenState extends State<ShopsArroundPopularScreen> {
  final int noOfStores = 28;
  // late List<Shop> allShops;
  late List<Shop> filteredShops;
  final _searchTextController = TextEditingController();
  bool _isSearching = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            BlocProvider.of<ShopCubit>(context).getAllShops();
            Navigator.pop(context);
          },
        ),
        actions: _buildAppBarActions(),
        // title: Text(
        //   widget.pageTitle,
        //   // widget.categoryId!,
        //   style: Theme.of(context).textTheme.bodyText1,
        // ),
        title: _isSearching
            ? _buildSearchField()
            : _buildAppBarTitle(widget.pageTitle),
      ),
      body: FadedSlideAnimation(
        child: _buildShopsList(
            _searchTextController.text.isEmpty ? widget.shops : filteredShops),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear)),
      ];
    } else {
      return [
        IconButton(onPressed: _startSearching, icon: const Icon(Icons.search))
      ];
    }
  }

  void _startSearching() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  Widget _buildShopsList(List<Shop> shops) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
          child: Text(
            '${shops.length} ' + AppLocalizations.of(context)!.storeFound!,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: kHintColor, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: shops.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            double ratingTotal = 0;
            if (shops[index].rating.isNotEmpty) {
              for (dynamic rating in shops[index].rating) {
                ratingTotal += rating['start'];
              }
            }
            ratingTotal = !(ratingTotal / shops[index].rating.length)
                    .floorToDouble()
                    .isNaN
                ? (ratingTotal / shops[index].rating.length).floorToDouble()
                : 0;

            return InkWell(
              onTap: () {
                dynamic ratingTotal = 0;
                if (shops[index].rating.isNotEmpty) {
                  for (dynamic rating in shops[index].rating) {
                    ratingTotal += rating['start'];
                  }
                }
                BlocProvider.of<ProductCubit>(context)
                    .getAllProducts(shops[index].id);
                context.router.push(
                  ShopScreenRoute(
                    shop: shops[index],
                      name: shops[index].title,
                      id: shops[index].id,
                      rating: ratingTotal != 0
                          // ? (ratingTotal / shop.rating.length).toDouble() ?? 0
                          ? (ratingTotal / shops[index].rating.length)
                                  .toStringAsFixed(1) ??
                              '0'
                          : '0',
                      ratingNumber: shops[index].rating.length ?? 0,
                      lat: shops[index].lat,
                      long: shops[index].lng,
                      address: shops[index].address,
                      description: shops[index].description,
                      reference: shops[index].reference,
                      ratingArray: shops[index].rating),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    FadedScaleAnimation(
                      child: Image(
                        image: NetworkImage(shops[index].imageUrl),
                        height: 120,
                        width: 120,
                      ),
                      fadeDuration: const Duration(milliseconds: 800),
                    ),
                    const SizedBox(width: 13.3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(shops[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10.3),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(shops[index].address,
                              maxLines: 3,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                        const SizedBox(height: 10.3),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: kMainColor,
                              size: 15,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                                '${getDistance(shops[index].lat, shops[index].lng).round()} km',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: kHintColor, fontSize: 10.0)),
                            Text('| ',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: kMainColor, fontSize: 10.0)),
                            Icon(
                              Icons.star,
                              color: kMainColor,
                              size: 15,
                            ),
                            const SizedBox(width: 10.0),
                            Text('$ratingTotal',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: kMainColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      autofocus: true,
      // cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
          hintText: 'Find a character...',
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 18)),
      style: TextStyle(fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(searchedShop) {
    filteredShops = widget.shops
        .where((shop) => shop.title
            .toLowerCase()
            .startsWith(searchedShop.toString().toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _buildAppBarTitle(pageTitle) {
    return Text(
      pageTitle,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }
}
