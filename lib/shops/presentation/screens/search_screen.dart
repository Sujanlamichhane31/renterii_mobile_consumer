import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/rentals/business_logic/cubit/shops/shops_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/business_logic/cubit/product/product_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';

import '../../data/models/shop.dart';

class SearchScreen extends StatefulWidget {
  final bool? isBooking;
  const SearchScreen({
    Key? key,
    this.isBooking
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isSearching = false;
  final _searchTextController = TextEditingController();
  final int noOfStores = 28;
  late List<Shop> allShops;
  late List<Shop> filteredShops;
  // @override
  // void initstate() {
    
  //   super.initState();
  //   print("Helellelelo");
  //   BlocProvider.of<ShopCubit>(context)
  //       .getShopsByCategory(super.widget.categoryId);
    
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("HEEELLLOOO");
    // print(super.widget.categoryId);
    BlocProvider.of<ShopCubit>(context)
         .getShopsWithProducts();
  }

  double getDistance(double lat2, double lon2) {
    return Geolocator
        .distanceBetween(
        32.2165157,
        -5.9437819,
        lat2,
        lon2)/1000;
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
            BlocProvider.of<ShopCubit>(context)
              .getShopsWithProducts();
            Navigator.pop(context);
          },
        ),
        title: _isSearching? _buildSearchField(): _buildAppBarTitle(),
        // title: Text(
        //   widget.pageTitle,
        //   // widget.categoryId!,
        //   style: Theme.of(context).textTheme.bodyText1,
        // ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     onPressed: () {
              
        //     },
        //   ),
        // ],
        actions: _buildAppBarActions(),
      ),
      body: FadedSlideAnimation(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state is ShopLoaded) {
              allShops = state.shops;
              return _buildShopsList(_searchTextController.text.isEmpty? allShops: filteredShops);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }


  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(onPressed: (){
          _clearSearch();
          Navigator.pop(context);
        }, icon: Icon(Icons.clear)),
      ];
    }else {
      return [
        IconButton(onPressed: _startSearching, icon: const Icon(Icons.search,))
      ];
    }
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }


  void _startSearching() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
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

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      controller: _searchTextController,
      // cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        hintText: 'Find a shop...',
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 18)
      ),
      style: const TextStyle(fontSize: 18),
      onChanged: (searchedShop) {
        print(searchedShop);
        addSearchedForItemsToSearchedList(searchedShop);
      },
    );
  }

  void addSearchedForItemsToSearchedList(searchedShop) {
    this.filteredShops = [];
    allShops.forEach((shop) {
      var termFound = false;
      if(shop.products != null) {
        for(var product in shop.products) {
          if(product['title'].startsWith(searchedShop)) {
            termFound = true;
            break;
          }
        }
      }
      if(shop.title.toLowerCase().startsWith(searchedShop.toString().toLowerCase()) || termFound) {
        filteredShops.add(shop);
      }
    });
    // print(filteredShops);
    // filteredShops = allShops
    // .where((shop) => shop.title.toLowerCase().startsWith(searchedShop.toString().toLowerCase()))
    // .toList();
    setState(() {
      
    });
  }

  Widget _buildAppBarTitle() {
    return Text(
      'Shops',
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  ListView _buildShopsList(List<Shop> allShops){
    return ListView(
                physics: const BouncingScrollPhysics(),
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 20.0),
                    child: Text(
                      '${allShops.length} ' +
                          AppLocalizations.of(context)!.storeFound!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: kHintColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: allShops.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      double ratingTotal = 0;
                          if (allShops[index].rating.isNotEmpty) {
                            for (dynamic rating in allShops[index].rating) {
                              ratingTotal += rating['start'];
                            }
                          }
                      
                      ratingTotal = !(ratingTotal / allShops[index].rating.length).floorToDouble().isNaN? (ratingTotal / allShops[index].rating.length).floorToDouble(): 0;

                      return InkWell(
                        onTap: () {
                          dynamic ratingTotal = 0;
                          print(allShops[index].rating.isNotEmpty);
                          if(allShops[index].rating.isNotEmpty) {
                            for(dynamic rating in allShops[index].rating) {
                              ratingTotal += rating['start'];
                            }
                          }
                          // BlocProvider.of<ProductCubit>(context)
                          //     .getAllProducts(allShops[index].id);
                          context.router.push(
                            ShopScreenRoute(
                              rating: ratingTotal != 0
                              // ? (ratingTotal / shop.rating.length).toDouble() ?? 0
                              ? (ratingTotal / allShops[index].rating.length).toStringAsFixed(1) ?? '0'
                              : '0', 
                              ratingNumber: allShops[index].rating.length,
                              name: allShops[index].title,
                              address: allShops[index].address,
                              description: allShops[index].categoryName,
                              lat: allShops[index].lat,
                              long: allShops[index].lng,
                              reference: allShops[index].reference,
                              id: allShops[index].id,
                              ratingArray: allShops[index].rating
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              FadedScaleAnimation(
                                child: Image(
                                  image:
                                      NetworkImage(allShops[index].imageUrl),
                                  height: 93.3,
                                ),
                                fadeDuration: const Duration(milliseconds: 800),
                              ),
                              const SizedBox(width: 13.3),
                              Column(
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
                                      .copyWith(color: Theme.of(context).secondaryHeaderColor, fontSize: 10.0, fontWeight: FontWeight.bold,)),
                                  const SizedBox(height: 10.3),
                                  Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xfff4cec9),
                                        size: 15,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text('$ratingTotal',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color:
                                                      Color(0xfff4cec9),
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
                                      Text('${getDistance(allShops[index].lat, allShops[index].lng).round()} km',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: kHintColor,
                                                  fontSize: 10.0)),
                                      Text('| ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: kMainColor,
                                                  fontSize: 10.0)),
                                      Text(allShops[index].address,
                                          style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: Theme.of(context).secondaryHeaderColor, fontSize: 10.0, fontWeight: FontWeight.bold,)),
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
}
