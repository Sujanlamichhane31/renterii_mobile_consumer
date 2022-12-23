import 'dart:developer';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/home/business_logic/cubit/category_cubit.dart';
import 'package:renterii/home/data/models/category.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/business_logic/cubit/shop_cubit.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/shops/presentation/screens/deals_screen.dart';
import 'package:renterii/utils/constant.dart';
import '../widgets/booking_row.dart';

// import 'booking_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<CategoryCubit>(context).getAllCategories();
    return const Home();
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController locationController = TextEditingController();
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

  List<Shop> shops = <Shop>[];
  List<Shop> aroundShops = <Shop>[];
  double distanceBetween = 300.0;
  @override
  void initState() {
    // BlocProvider.of<ShopCubit>(context).getAllShops();
    user = context.read<UserCubit>().state.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final banner = [
      'images/Banners/Banner2.jpg',
      'images/Banners/Banner1.jpg',
    ];

    return Scaffold(
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
                locationController.text = state.user.address ?? '';
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      context.router.push(
                        LocationScreenRoute(
                            textEditingController: locationController,
                            lat: state.user.latitude,
                            long: state.user.longitude),
                      );
                    },
                    child: Text(
                      state.user.address ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 15, color: Colors.grey[500]),
                    ),
                  ),
                );
              },
              // icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
            )
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ShopCubit>().getAllShops();
        },
        child: ListView(
          children: <Widget>[
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 10),
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    state.categories.first.name == nearMe
                        ? state.categories
                        : state.categories.insert(
                            0,
                            ShopCategory(
                                name: nearMe, id: state.categories[0].id));
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...state.categories.map((e) {
                            return InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  // height: 5,
                                  // width: double.infinity,
                                  color: Theme.of(context).cardColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          e.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.router.push(ShopsScreenRoute(
                                    pageTitle: e.name,
                                    isBooking: false,
                                    categoryId: e.id!));
                              },
                            );
                          })
                          // ListView.builder(
                          // shrinkWrap: true,
                          // physics: const BouncingScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          // itemCount: state.categories.length,
                          // itemBuilder: (context, index) {
                          //   return InkWell(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(left: 10),
                          //       child: Container(
                          //         // height: 5,
                          //         // width: double.infinity,
                          //         color: Theme.of(context).cardColor,
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: 20),
                          //               child: Text(
                          //                 state.categories[index].name,
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .caption!
                          //                     .copyWith(
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: 10.0),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     onTap: () {
                          //       context.router.push(ShopsScreenRoute(
                          //           pageTitle: state.categories[index].name,
                          //           isBooking: false,
                          //           categoryId: state.categories[index].id!));
                          //     },
                          //   );
                          // })
                        ],
                      ),
                    );
                  } else {
                    return const Text('No categories found. Try again');
                  }
                },
              ),
            ),
            // const CategoriesListView(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.homeText2!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DealsScreen())),
                    child: Text(
                      AppLocalizations.of(context)!.seeAll!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: kMainColor),
                    ),
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth <= 480) {
                  return SizedBox(
                    height: 136,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: banner.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: FadedScaleAnimation(
                              child: Image.asset(
                                banner[index],
                                fit: BoxFit.contain,
                              ),
                              fadeDuration: const Duration(milliseconds: 200),
                            ),
                          );
                        }),
                  );
                }
                if (constraints.maxWidth >= 480) {
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: banner.length,
                        itemBuilder: (context, index) {
                          return FadedScaleAnimation(
                            child: Image.asset(
                              banner[index],
                              width: MediaQuery.of(context).size.width * 0.7,
                              fit: BoxFit.contain,
                            ),
                            fadeDuration: const Duration(milliseconds: 200),
                          );
                        }),
                  );
                } else {
                  return SizedBox(
                    height: 136,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: banner.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: FadedScaleAnimation(
                              child: Image.asset(
                                banner[index],
                                fit: BoxFit.contain,
                              ),
                              fadeDuration: const Duration(milliseconds: 200),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
            const SizedBox(
              height: 18,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: BookingRow(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 15, right: 20),
              child: Row(
                children: [
                  Text(
                    'Around You',
                    //AppLocalizations.of(context)!.nearyou!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const Spacer(),
                  BlocBuilder<ShopCubit, ShopState>(
                    builder: (context, state) {
                      return GestureDetector(
                        child: InkWell(
                          onTap: () {
                            if (state is ShopLoaded) {
                              aroundShops = state.shops
                                  .where((shop) =>
                                      getDistance(shop.lat, shop.lng) <=
                                      distanceBetween)
                                  .toList();
                              context.router.push(
                                ShopsArroundPopularScreenRoute(
                                  pageTitle: 'Shops Around You',
                                  isBooking: true,
                                  shops: aroundShops,
                                ),
                              );
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.seeAll!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: kMainColor),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<ShopCubit, ShopState>(
              builder: (context, state) {
                if (state is ShopLoaded) {
                  // log(state.shops[0]);
                  aroundShops = state.shops
                      .where((shop) =>
                          getDistance(shop.lat, shop.lng) <= distanceBetween)
                      .toList();
                  return Container(
                    height: 160,
                    margin: const EdgeInsets.only(left: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.36,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: aroundShops.map((shop) {
                        log('Size: ${state.shops.length}');
                        return FadedScaleAnimation(
                          child: quickGrid(
                            context: context,
                            shop: shop,
                          ),
                          fadeDuration: const Duration(milliseconds: 200),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 15, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'Local Legends',
                        //AppLocalizations.of(context)!.nearyou1!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const Spacer(),
                      BlocBuilder<ShopCubit, ShopState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              if (state is ShopLoaded) {
                                List<Shop> popularShops = [];

                                for (Shop shop in state.shops) {
                                  bool shopAccepted = false;
                                  if (shop.rating.isNotEmpty) {
                                    for (dynamic rating in shop.rating) {
                                      if (rating['start'] > 4) {
                                        shopAccepted = true;
                                        break;
                                      }
                                    }

                                    if (shopAccepted) {
                                      popularShops.add(shop);
                                    }
                                  }
                                }
                                shops = state.shops
                                    .where((shop) =>
                                        getDistance(shop.lat, shop.lng) <=
                                        distanceBetween)
                                    .toList();
                                context.router.push(
                                    ShopsArroundPopularScreenRoute(
                                        pageTitle: 'Local Legends',
                                        isBooking: true,
                                        shops: shops));
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.seeAll!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: kMainColor),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<ShopCubit, ShopState>(
              builder: (context, state) {
                if (state is ShopLoaded) {
                  List<Shop> popularShops = [];
                  for (Shop shop in state.shops) {
                    bool shopAccepted = false;
                    if (shop.rating.isNotEmpty) {
                      for (dynamic rating in shop.rating) {
                        if (rating['start'] > 4) {
                          shopAccepted = true;
                          break;
                        }
                      }

                      if (shopAccepted) {
                        popularShops.add(shop);
                      }
                    }
                  }
                  // log(state.shops[0]);
                  shops = state.shops
                      .where((shop) =>
                          getDistance(shop.lat, shop.lng) <= distanceBetween)
                      .toList();
                  return Container(
                    height: 160,
                    margin: const EdgeInsets.only(left: 20),
                    child: shops.isEmpty
                        ? const Text('No Shops around 300 KM from you')
                        : GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.36,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: shops.map((shop) {
                              return FadedScaleAnimation(
                                child: quickGrid(context: context, shop: shop),
                                fadeDuration: const Duration(milliseconds: 200),
                              );
                            }).toList(),
                          ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget quickGrid({required BuildContext context, required Shop shop}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: GestureDetector(
        onTap: () {
          dynamic ratingTotal = 0;
          if (shop.rating.isNotEmpty) {
            for (dynamic rating in shop.rating) {
              ratingTotal += rating['start'];
            }
          }
          context.router.push(ShopScreenRoute(
              rating: ratingTotal != 0
                  // ? (ratingTotal / shop.rating.length).toDouble() ?? 0
                  ? (ratingTotal / shop.rating.length).toStringAsFixed(1) ?? '0'
                  : '0',
              ratingNumber: shop.rating.length ?? 0,
              id: shop.id,
              name: shop.title,
              //isBooking: true,
              lat: shop.lat,
              long: shop.lng,
              shop: shop,
              address: shop.address,
              description: shop.description,
              reference: shop.reference,
              ratingArray: shop.rating));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image(
              image: NetworkImage(shop.imageUrl),
              height: 62.5,
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(shop.title,
                    maxLines: 2,
                    //AppLocalizations.of(context)!.store!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 17)),
                const SizedBox(height: 8.0),
                // Replace this text with the category
                Text(
                  shop.categoryName.isNotEmpty ? shop.categoryName : '',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10.3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: kMainColor,
                      size: 13,
                    ),
                    // const SizedBox(width: 4.0),
                    Text('${getDistance(shop.lat, shop.lng).round()} km',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: kLightTextColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold)),

                    //doesn't look good with grid view
                    // FutureBuilder(
                    //     future: getAddressDataFromLatLng(
                    //         latitude: shop.lat, longitude: shop.lng),
                    //     builder: (context, snapshot) {
                    //       final address = snapshot.data;
                    //       if (address == null) {
                    //         return const SizedBox();
                    //       }

                    //       return SizedBox(
                    //         width: MediaQuery.of(context).size.width * 0.2,
                    //         child: Text(
                    //           (address as Map<String, dynamic>)[
                    //                   'address_components']
                    //               .toList()[0]['short_name']
                    //               .toString(),
                    //           // 'Hello',
                    //           maxLines: 1,
                    //           softWrap: false,
                    //           overflow: TextOverflow.ellipsis,
                    //           //AppLocalizations.of(context)!.storeAddress!,
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .caption!
                    //               .copyWith(
                    //                 color:
                    //                     Theme.of(context).secondaryHeaderColor,
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 10.0,
                    //               ),
                    //         ),
                    //       );
                    //     }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
