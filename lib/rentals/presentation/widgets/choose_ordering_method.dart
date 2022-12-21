// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';
import 'package:renterii/orders/data/models/order.dart';
import 'package:renterii/rentals/presentation/widgets/bottom_bar.dart';
import 'package:renterii/routes/app_router.gr.dart';
import 'package:renterii/shops/data/models/product.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/utils/constant.dart';

class Method {
  final String image;
  final String title;
  final String price;

  Method(this.image, this.title, this.price);
}

class Reach {
  final String title;

  Reach(this.title);
}

class Bottom extends StatefulWidget {
  final Product product;
  final dynamic ref;
  final Shop shop;
  final int? quantity;
  final List<OrderProduct> orderProductList;

  const Bottom({
    Key? key,
    required this.product,
    required this.ref,
    required this.shop,
    this.quantity = 0,
    required this.orderProductList,
  }) : super(key: key);
  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int methodIndex = 0;
  int timeIndex = 0;
  int dateIndex = 0;
  int personIndex = 0;
  final DateTime _dateTime = DateTime.now();
  final List<Reach> dateReach = [];
  final List<Reach> timeReach = [];

  List<OrderProduct> orderProducts = <OrderProduct>[];

  @override
  void initState() {
    for (int i = 0; i < 30; i++) {
      dateReach.add(Reach(
        DateFormat('MMMd').format(_dateTime.add(Duration(days: i))),
      ));
    }
    for (int i = 0; i < 24; i++) {
      timeReach.add(Reach(
        DateFormat('HH:mm').format(_dateTime.add(Duration(hours: i))),
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('dateReach: ${dateReach[1].title}');

    OrderProduct newOrder;

    return ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          const SizedBox(height: 30),
          Row(children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              "Choose ordering method",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),
            )
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FadedScaleAnimation(
                child: Container(
                  height: 120.0,
                  margin: const EdgeInsets.only(left: 12),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: method.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              methodIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: methodIndex == index
                                        ? kMainColor
                                        : Colors.white),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: methodIndex == index
                                    ? kMainColor
                                    : Colors.white,
                              ),
                              //width: 90,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(method[index].image, height: 48),
                                  const SizedBox(width: 10),
                                  Text(
                                    method[index].title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                fadeDuration: const Duration(milliseconds: 800),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(children: [
            const SizedBox(width: 20),
            Text(
              "Renters",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(height: 20),
          FadedScaleAnimation(
            child: Container(
              height: 38.0,
              margin: const EdgeInsets.only(left: 12),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: reach.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          personIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            height: 35,
                            width: 82,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: personIndex == index
                                      ? kMainColor
                                      : Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: personIndex == index
                                  ? kMainColor
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              reach[index].title,
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                      ),
                            )),
                      ),
                    );
                  }),
            ),
            fadeDuration: const Duration(milliseconds: 800),
          ),
          const SizedBox(height: 25),
          Row(children: [
            const SizedBox(width: 20),
            Text(
              "Date",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
            )
          ]),
          FadedScaleAnimation(
            child: Container(
              height: 38.0,
              margin: const EdgeInsets.only(left: 12),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: dateReach.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          dateIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            height: 35,
                            width: 82,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: dateIndex == index
                                      ? kMainColor
                                      : Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: dateIndex == index
                                  ? kMainColor
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dateReach[index].title,
                              style:
                                  Theme.of(context).textTheme.caption!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                      ),
                            )),
                      ),
                    );
                  }),
            ),
            fadeDuration: const Duration(milliseconds: 800),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const SizedBox(width: 20),
            Text(
              "Time",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
            )
          ]),
          FadedScaleAnimation(
            child: Container(
              height: 38.0,
              margin: const EdgeInsets.only(left: 12),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: timeReach.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          timeIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            height: 35,
                            width: 82,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: timeIndex == index
                                      ? kMainColor
                                      : Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: timeIndex == index
                                  ? kMainColor
                                  : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              timeReach[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0),
                            )),
                      ),
                    );
                  }),
            ),
            fadeDuration: const Duration(milliseconds: 800),
          ),
          const SizedBox(height: 20),
          BlocListener<OrderCubit, OrderState>(
            listenWhen: (prevState, currState) =>
                currState.status == OrderStatus.newOrderInProgress,
            listener: (context, state) {
              print('choose order: ${state.orderInProgress}');
              context.router.push(ConfirmOrderScreenRoute(shop: widget.shop));
            },
            child: BottomBar(
              text: 'Confirm',
              onTap: () {
                for (var item in widget.orderProductList) {
                  if (item.quantity > 0) {
                    newOrder = OrderProduct(
                      product: item.product,
                      nbrPersons: reach[personIndex].title,
                      dateStart: dateReach[dateIndex].title,
                      timeStart: timeReach[timeIndex].title,
                      quantity: item.quantity,
                    );

                    orderProducts
                        .where((element) => element != newOrder)
                        .toList();
                    orderProducts.add(newOrder);

                    context.read<OrderCubit>().addNewOrder(
                          orderProduct: newOrder,
                          shopReference: widget.ref,
                        );
                    context.router.pop();
                  }
                }
              },
            ),
          )
        ]);
  }
}
