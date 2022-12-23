import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/utils/constant.dart';

import '../../../routes/app_router.gr.dart';
import '../../data/models/shop.dart';

class ShopsScreen extends StatefulWidget {
  final String pageTitle;
  final bool? isBooking;
  final DocumentReference categoryId;

  const ShopsScreen(
      {Key? key,
      required this.pageTitle,
      this.isBooking,
      required this.categoryId})
      : super(key: key);

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final int noOfStores = 28;
  late List<Shop> allShops = [];
  late List<Shop> filteredShops = [];
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pageTitle == nearMe) {
        allShop();
      } else {
        shopByCategory();
      }
    });

    super.initState();
  }

  allShop() {
    BlocProvider.of<ShopCubit>(context).getAllShops();
  }

  shopByCategory() {
    BlocProvider.of<ShopCubit>(context).getShopsByCategory(widget.categoryId);
  }

  double getDistance(double lat2, double lon2) {
    return Geolocator.distanceBetween(32.2165157, -5.9437819, lat2, lon2) /
        1000;
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
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: FadedSlideAnimation(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state is ShopLoaded) {
              allShops = state.shops;
              return _buildShopsList(_searchTextController.text.isEmpty
                  ? allShops
                  : filteredShops);
            } else if (state is ShopsByCategoryLoaded) {
              allShops = state.shops;
              return _buildShopsList(_searchTextController.text.isEmpty
                  ? allShops
                  : filteredShops);
            } else if (state is ShopsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _buildShopsList(_searchTextController.text.isEmpty
                  ? allShops
                  : filteredShops);
            }
          },
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void addSearchedForItemsToSearchedList(searchedShop) {
    // filteredShops = allShops
    //     .where((shop) => shop.title
    //         .toLowerCase()
    //         .startsWith(searchedShop.toString().toLowerCase()))
    //     .toList();
    this.filteredShops = [];
    allShops.forEach((shop) {
      var termFound = false;
      if (shop.products != null) {
        for (var product in shop.products) {
          if (product['title']
              .toString()
              .toLowerCase()
              .startsWith(searchedShop.toString().toLowerCase())) {
            termFound = true;
            break;
          }
        }
      }
      if (shop.title
              .toLowerCase()
              .startsWith(searchedShop.toString().toLowerCase()) ||
          termFound) {
        filteredShops.add(shop);
      }
    });
    setState(() {});
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

  Widget _buildAppBarTitle() {
    return Text(
      widget.pageTitle,
      style: const TextStyle(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      controller: _searchTextController,
      // cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
          hintText: 'Find a shop...',
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 18)),
      style: const TextStyle(fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  ListView _buildShopsList(List<Shop> allShops) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
          child: Text(
            '${allShops.length} ' + AppLocalizations.of(context)!.storeFound!,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: kHintColor, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: allShops.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            double ratingTotal = 0;
            print('shops: ${allShops[0]}');
            if (allShops[index].rating.isNotEmpty) {
              for (dynamic rating in allShops[index].rating) {
                ratingTotal += rating['start'];
              }
            }

            ratingTotal = !(ratingTotal / allShops[index].rating.length)
                    .floorToDouble()
                    .isNaN
                ? (ratingTotal / allShops[index].rating.length).floorToDouble()
                : 0;

            return InkWell(
              onTap: () {
                dynamic ratingTotal = 0;
                print(allShops[index].rating.isNotEmpty);
                if (allShops[index].rating.isNotEmpty) {
                  print(ratingTotal);
                  for (dynamic rating in allShops[index].rating) {
                    ratingTotal += rating['start'];
                  }
                }
                // BlocProvider.of<ProductCubit>(context)
                //     .getAllProducts(allShops[index].id);
                context.router.push(
                  ShopScreenRoute(
                      shop: allShops[index],
                      rating: ratingTotal != 0
                          ? (ratingTotal / allShops[index].rating.length)
                                  .toStringAsFixed(1) ??
                              '0'
                          : '0',
                      ratingNumber: allShops[index].rating.length ?? 0,
                      name: allShops[index].title,
                      address: allShops[index].address,
                      description: allShops[index].categoryName,
                      lat: allShops[index].lat,
                      long: allShops[index].lng,
                      reference: allShops[index].reference,
                      id: allShops[index].id,
                      ratingArray: allShops[index].rating),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: FadedScaleAnimation(
                        child: Image(
                          image: NetworkImage(allShops[index].imageUrl),
                          height: MediaQuery.of(context).size.width * 0.25,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        fadeDuration: const Duration(milliseconds: 800),
                      ),
                    ),
                    const SizedBox(width: 13.3),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(allShops[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          Text(allShops[index].categoryName,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                          const SizedBox(height: 10.3),
                          Row(
                            children: <Widget>[
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
                          const SizedBox(height: 10.3),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: kMainColor,
                                size: 15,
                              ),
                              const SizedBox(width: 10.0),
                              Flexible(
                                child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                        text:
                                            '${getDistance(allShops[index].lat, allShops[index].lng).round()} km',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: kHintColor,
                                                fontSize: 10.0),
                                        children: [
                                          TextSpan(
                                              text: '| ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                      color: kMainColor,
                                                      fontSize: 10.0)),
                                          TextSpan(
                                              text: allShops[index].address,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                  ))
                                        ])),
                              ),
                              // Text(
                              //     '${getDistance(allShops[index].lat, allShops[index].lng).round()} km',
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .caption!
                              //         .copyWith(
                              //             color: kHintColor, fontSize: 10.0)),
                              // Text('| ',
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .caption!
                              //         .copyWith(
                              //             color: kMainColor, fontSize: 10.0)),
                              // Text(allShops[index].address,
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .caption!
                              //         .copyWith(
                              //             color: Theme.of(context)
                              //                 .secondaryHeaderColor,
                              //             fontSize: 10.0,
                              //             fontWeight: FontWeight.bold,
                              //             overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
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
}
