import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/data/models/user.dart';
import 'package:renterii/rentals/presentation/widgets/booking_row.dart';
import 'package:renterii/rentals/presentation/widgets/bottom_bar.dart';
import 'package:renterii/rentals/presentation/widgets/choose_ordering_method.dart';
import 'package:renterii/rentals/presentation/widgets/custom_appbar.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/routes/routes.dart';
import 'package:renterii/shops/business_logic/cubit/product/product_cubit.dart';
import 'package:renterii/shops/data/models/product.dart';

import '../../../authentication/business_logic/cubit/user/user_cubit.dart';

List<String> list = ['Extra Cheese', 'Extra Mayonnaise', 'Extra Veggies'];
List<String> list1 = ['\$ 3.00', '\$ 2.00', '\$ 1.50'];

class ShopScreen extends StatefulWidget {
  final String? name;
  final String id;
  final String? address;
  final double? lat;
  final double? long;
  final String? description;
  final bool isBooking;
  dynamic? reference;
  final String rating;
  final int ratingNumber;
  final dynamic ratingArray;

  ShopScreen({
    required this.id,
    Key? key,
    this.name,
    this.address,
    this.lat,
    this.long,
    this.description,
    this.reference,
    this.ratingArray,
    required this.rating,
    required this.ratingNumber,
    this.isBooking = false,
  }) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool itemAdded = false;
  int itemCount = 0;
  int itemCount1 = 0;
  int itemCount2 = 0;
  Product product = Product(
      title: '',
      price: 0,
      imageUrl: '',
      description: '',
      id: '',
      category: '',
      rentalDuration: '');
  double distanceInMeters = 0;
  String rentDuration = '';

  @override
  initState() {
    print('initState');

    BlocProvider.of<ProductCubit>(context).getAllProducts(widget.id);
    CurrentUser user = context.read<UserCubit>().state.user;
    if (user != null && user.latitude != null && user.longitude != null) {
      distanceInMeters = Geolocator.distanceBetween(
              user.latitude!, user.longitude!, widget.lat!, widget.long!) /
          1000;
    } else {
      distanceInMeters = Geolocator.distanceBetween(
              32.2165157, -5.9437819, widget.lat!, widget.long!) /
          1000;
    }

    super.initState();
  }

  List<Product> itemList = [];
  List<Product> spacesList = [];
  List<Product> lodgingList = [];
  List<Product> experienceList = [];
  List<Product> packagesList = [];

  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    final List<Tab> tabs = <Tab>[
      // const Tab(text: 'Jordan Shop'),
      const Tab(text: 'Items'),
      const Tab(text: 'Spaces'),
      const Tab(text: 'Lodging'),
      const Tab(text: 'Experience'),
      const Tab(text: 'Packages'),
    ];

    return Material(
      child: Stack(
        children: <Widget>[
          DefaultTabController(
            length: tabs.length,
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(185.0),
                  child: CustomAppBar(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // actions: [
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //     child: FadedScaleAnimation(
                    //       child: const Icon(
                    //         Icons.favorite_border,
                    //         size: 19.5,
                    //       ),
                    //       fadeDuration: const Duration(milliseconds: 800),
                    //     ),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //     child: FadedScaleAnimation(
                    //       child: const Icon(Icons.search),
                    //       fadeDuration: const Duration(milliseconds: 800),
                    //     ),
                    //   )
                    // ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(0.0),
                      child: InkWell(
                        onTap: () {
                          if (!widget.ratingNumber.isNaN &&
                              widget.ratingNumber != 0) {
                            final user = context.read<UserCubit>().state.user;
                            context.router.push(ReviewsScreenRoute(
                                shopName: widget.name,
                                ratings: widget.ratingArray,
                                ratingNumber: widget.rating,
                                username: user.name,
                                numberOfReviews: widget.ratingNumber));
                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //       content: Text('No Reviews found for this shop'),
                            //       // backgroundColor: Colors.green,
                            //       behavior: SnackBarBehavior.floating,
                            //     ),
                            //   );
                            // final user = context.read<UserCubit>().state.user;
                            context.router.push(ReviewsScreenRoute(
                                shopName: widget.name,
                                ratings: [],
                                ratingNumber: widget.rating,
                                username: '',
                                numberOfReviews: 0));
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor)),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text('${widget.description ?? ''}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.overline),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: kIconColor,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text('${distanceInMeters.round()} km ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline),
                                      Text('| ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline!
                                              .copyWith(color: kMainColor)),
                                      Text('${widget.address ?? 'No address'}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline),
                                      const Spacer(),
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xff7ac81e),
                                        size: 13,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text('${widget.rating}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline!
                                              .copyWith(
                                                  color:
                                                      const Color(0xff7ac81e))),
                                      const SizedBox(width: 8.0),
                                      Text('${widget.ratingNumber} reviews',
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: kIconColor,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 18,
                            ),
                            // BookingRow(),
                            TabBar(
                              tabs: tabs,
                              isScrollable: true,
                              labelColor: kMainColor,
                              unselectedLabelColor: kLightTextColor,
                              indicatorPadding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                  if (state is ProductLoaded) {
                    widget.reference = state.products.first.shop;
                    for (var items in state.products) {
                      if (items.category.toLowerCase() == 'item' ||
                          items.category.toLowerCase() == 'items') {
                        itemList.add(items);
                      } else if (items.category.toLowerCase() == 'spaces') {
                        spacesList.add(items);
                      } else if (items.category.toLowerCase() == 'lodging') {
                        lodgingList.add(items);
                      } else if (items.category.toLowerCase() == 'experience') {
                        experienceList.add(items);
                      } else if (items.category.toLowerCase() == 'packages') {
                        packagesList.add(items);
                      } else {}
                    }
                  }
                  return TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ProductItemWidget(
                          productList: itemList, reference: widget.reference),
                      ProductItemWidget(
                          productList: spacesList, reference: widget.reference),
                      ProductItemWidget(
                          productList: lodgingList,
                          reference: widget.reference),
                      ProductItemWidget(
                          productList: experienceList,
                          reference: widget.reference),
                      ProductItemWidget(
                          productList: packagesList,
                          reference: widget.reference),
                    ],
                  );
                })

                // TabBarView(
                //   physics: const BouncingScrollPhysics(),
                //   children: tabs.map((Tab tab) {
                //     return BlocBuilder<ProductCubit, ProductState>(
                //       builder: (context, state) {
                //         if (state is ProductLoaded) {

                //           return ListView.builder(
                //             padding: const EdgeInsets.only(bottom: 60),
                //             physics: const BouncingScrollPhysics(),
                //             itemCount: state.products.length,
                //             itemBuilder: (context, int index) {
                //               print(state.products[index].category);
                //               print(tab.text);
                //               if (state.products[index].rentDuration > 1) {
                //                 rentDuration =
                //                     '${state.products[index].rentDuration} hours';
                //               } else {
                //                 rentDuration =
                //                     '${state.products[index].rentDuration} hour';
                //               }
                //               if (state.products[index].category == tab.text) {
                //                 return ListTile(
                //                   leading: FadedScaleAnimation(
                //                     //child: Image.asset('images/Food images/2.png', scale: 3,),
                //                     child: Image.network(
                //                       state.products[index].imageUrl,
                //                       scale: 3,
                //                     ),
                //                     fadeDuration:
                //                         const Duration(milliseconds: 800),
                //                   ),
                //                   title: Text(
                //                       '${state.products[index].title} ($rentDuration)',
                //                       //AppLocalizations.of(context)!.sandwich!,
                //                       style: Theme.of(context)
                //                           .textTheme
                //                           .headline2!
                //                           .copyWith(
                //                               fontSize: 15,
                //                               fontWeight: FontWeight.w600)),
                //                   subtitle: Padding(
                //                     padding: const EdgeInsets.only(top: 10.0),
                //                     child: Row(
                //                       children: [
                //                         FadedScaleAnimation(
                //                           child: Image.asset(
                //                             'images/ic_pink.png',
                //                             height: 16.0,
                //                             width: 16.7,
                //                           ),
                //                           fadeDuration:
                //                               const Duration(milliseconds: 800),
                //                         ),
                //                         const SizedBox(
                //                           width: 8.0,
                //                         ),
                //                         Text('\$ ${state.products[index].price}',
                //                             style: Theme.of(context)
                //                                 .textTheme
                //                                 .caption!
                //                                 .copyWith(fontSize: 15)),
                //                       ],
                //                     ),
                //                   ),
                //                   trailing: product == state.products[index]
                //                       ? const SizedBox.shrink()
                //                       : SizedBox(
                //                           height: 33.0,
                //                           child: TextButton(
                //                             child: Text(
                //                               'Select',
                //                               style: Theme.of(context)
                //                                   .textTheme
                //                                   .caption!
                //                                   .copyWith(
                //                                       color: kMainColor,
                //                                       fontWeight:
                //                                           FontWeight.bold),
                //                             ),
                //                             onPressed: () {
                //                               setState(() {
                //                                 itemCount++;
                //                                 itemAdded = true;
                //                                 product = state.products[index];
                //                                 showModalBottomSheet(
                //                                   isScrollControlled: true,
                //                                   context: context,
                //                                   builder: (context) {
                //                                     return Container(
                //                                       color:
                //                                           const Color(0xfff8f9fd),
                //                                       child: Bottom(
                //                                           product: product,
                //                                           ref: widget.reference),
                //                                     );
                //                                   },
                //                                 );
                //                               });
                //                             },
                //                           ),
                //                         ),
                //                 );
                //               } else {
                //                 return Container();
                //               }
                //             },
                //           );
                //         } else {
                //           return const Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         }
                //       },
                //     );
                //   }).toList(),
                // ),
                ),
          ),
          if (itemAdded)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    FadedScaleAnimation(
                      child: Image.asset(
                        'images/icons/ic_cart wt.png',
                        height: 19.0,
                        width: 18.3,
                      ),
                      fadeDuration: const Duration(milliseconds: 800),
                    ),
                    const SizedBox(width: 20.7),
                    Expanded(
                      child: Text(
                        '${product.title} | \$ ${product.price}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.router.push(const ConfirmOrderScreenRoute());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Continue',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              color: kMainColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                color: kMainColor,
                height: 60.0,
              ),
            )
          else
            const SizedBox.shrink(),
          widget.isBooking
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomBar(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: BottomWidget(),
                          );
                        },
                      );
                    },
                    text: "Book A Table",
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

class ProductItemWidget extends StatefulWidget {
  ProductItemWidget({
    Key? key,
    required this.productList,
    this.reference,
  }) : super(key: key);
  final List<Product> productList;
  final dynamic reference;

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool itemAdded = false;

  int itemCount = 0;

  int itemCount1 = 0;

  int itemCount2 = 0;

  Product product = Product(
      title: '',
      price: 0,
      imageUrl: '',
      description: '',
      id: '',
      category: '',
      rentalDuration: '');

  double distanceInMeters = 0;

  String rentDuration = '';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 60),
      physics: const BouncingScrollPhysics(),
      itemCount: widget.productList.length,
      itemBuilder: (context, int index) {
        return ListTile(
          leading: Container(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            child: FadedScaleAnimation(
              child: Image.network(
                widget.productList[index].imageUrl,
                scale: 3,
              ),
              fadeDuration: const Duration(milliseconds: 800),
            ),
          ),
          title: Text(widget.productList[index].title,
              //AppLocalizations.of(context)!.sandwich!,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FadedScaleAnimation(
                      child: Image.asset(
                        'images/ic_pink.png',
                        height: 16.0,
                        width: 16.7,
                      ),
                      fadeDuration: const Duration(milliseconds: 800),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(widget.productList[index].rentalDuration,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 14)),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text('\$ ${widget.productList[index].price}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14)),
              ],
            ),
          ),
          trailing: product == widget.productList[index]
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 33.0,
                  child: TextButton(
                    child: Text(
                      'Select',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: kMainColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        itemCount++;
                        itemAdded = true;
                        product = widget.productList[index];
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              color: const Color(0xfff8f9fd),
                              child: Bottom(
                                  product: widget.productList[index],
                                  ref: widget.reference),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
        );
      },
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  List<String> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 100.7,
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.sandwich!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  FadedScaleAnimation(
                    child: Image.asset(
                      'images/ic_veg.png',
                      //'images/Group 473.png',
                      height: 16.0,
                      width: 16.7,
                    ),
                    fadeDuration: const Duration(milliseconds: 800),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text('\$ 5.00',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 15)),
                ],
              ),
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.add!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: kMainColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) => CheckboxListTile(
            title: Text(list[index]),
            value: _selectedList.contains(list[index]),
            onChanged: (value) {
              if (value!) {
                _selectedList.add(list[index]);
              } else {
                _selectedList.remove(list[index]);
              }
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
