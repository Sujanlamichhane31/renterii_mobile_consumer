import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/data/models/user.dart';
import 'package:renterii/orders/data/models/order.dart';
import 'package:renterii/rentals/presentation/screens/rentals_screen.dart';
import 'package:renterii/rentals/presentation/widgets/booking_row.dart';
import 'package:renterii/rentals/presentation/widgets/bottom_bar.dart';
import 'package:renterii/rentals/presentation/widgets/choose_ordering_method.dart';
import 'package:renterii/rentals/presentation/widgets/custom_appbar.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/business_logic/cubit/cubit/quantity_cubit/quantity_cubit.dart';
import 'package:renterii/shops/business_logic/cubit/product/product_cubit.dart';
import 'package:renterii/shops/data/models/product.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/shops/presentation/widgets/product_widget.dart';

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
  final Shop shop;

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
    required this.shop,
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

  clearList() {
    itemList.clear();
    spacesList.clear();
    lodgingList.clear();
    experienceList.clear();
    packagesList.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                    clearList();
                    if (state.products.isNotEmpty) {
                      widget.reference = state.products.first.shop;
                    }
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
                          shop: widget.shop,
                          productList: itemList,
                          reference: widget.reference),
                      ProductItemWidget(
                          shop: widget.shop,
                          productList: spacesList,
                          reference: widget.reference),
                      ProductItemWidget(
                          shop: widget.shop,
                          productList: lodgingList,
                          reference: widget.reference),
                      ProductItemWidget(
                          shop: widget.shop,
                          productList: experienceList,
                          reference: widget.reference),
                      ProductItemWidget(
                          shop: widget.shop,
                          productList: packagesList,
                          reference: widget.reference),
                    ],
                  );
                })),
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
                        context.router
                            .push(ConfirmOrderScreenRoute(shop: widget.shop));
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
  const ProductItemWidget({
    Key? key,
    required this.productList,
    this.reference,
    required this.shop,
  }) : super(key: key);
  final List<Product> productList;
  final dynamic reference;
  final Shop shop;

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
  int quantity = 0;
  List<OrderProduct> orderProductList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          itemCount: widget.productList.length,
          itemBuilder: (context, int index) {
            for (var item in widget.productList) {
              orderProductList.add(OrderProduct(
                product: item,
                quantity: 0,
              ));
            }
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RentalScreen(
                              shop: widget.shop,
                              product: widget.productList[index],
                              ref: widget.reference,
                              quantity: orderProductList[index].quantity,
                            )));
              },
              child: ProductWidget(
                product: widget.productList[index],
                count: (value) {
                  if (value > 0) {
                    context.read<QuantityCubit>().makeVisible(true);
                    quantity = value;
                    orderProductList[index].quantity = value;
                  } else if (value == 0) {
                    context.read<QuantityCubit>().makeVisible(false);
                    orderProductList[index].quantity = value;
                  }
                },
              ),
            );
          },
        ),
        BlocBuilder<QuantityCubit, QuantityState>(
          builder: (context, state) {
            if (state is ButtonVisibility) {
              log("state: ${state.visible}");
              return Align(
                alignment: Alignment.bottomCenter,
                child: state.visible == true
                    ? BottomBar(
                        text: 'Select dates',
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                color: const Color(0xfff8f9fd),
                                child: Bottom(
                                  shop: widget.shop,
                                  product: product,
                                  ref: widget.reference,
                                  orderProductList: orderProductList,
                                ),
                              );
                            },
                          );
                        },
                      )
                    : SizedBox(),
              );
            } else {
              return SizedBox();
            }
          },
        )
      ],
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
