import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';
import 'package:renterii/orders/data/models/order.dart';
import 'package:renterii/shared/enums.dart';
import 'package:renterii/shops/business_logic/cubit/cubit/deals_cubit.dart';

import '../../../authentication/presentation/widgets/bottom_bar.dart';
import '../../../routes/app_router.gr.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({Key? key}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrderScreen> {
  final TextEditingController _controller = TextEditingController();
  double taxDecimalPercentage = 0.13;
  double tax = 0;
  double subTotal = 0;
  double total = 0;
  double serviceFee = 1.50;
  String rentDuration = '';

  double discountDecimalPercentage = 0.0;
  double discountAmount = 0.0;
  double walletBalance = 0.0;
  double get totalAmount {
    if (discountDecimalPercentage == 0.0) {
      return double.parse(total.toStringAsFixed(1));
    }

    return double.parse((total - discountAmount).toStringAsFixed(1));
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    walletBalance = context.read<UserCubit>().state.user.walletBalance ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context)!.confirm!,
            style: Theme.of(context).textTheme.bodyText1),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.paymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(state.errorMessage!),
              ),
            );
          } else if (state.status == UserStatus.paymentSuccess) {
            context.read<OrderCubit>().confirmOrder(
                  totalAmount: totalAmount,
                  userId: context.read<UserCubit>().state.user.id,
                );
            context.router.pushAndPopUntil(const ThankYouScreenRoute(),
                predicate: (route) => route.isFirst);
          }
        },
        child: FadedSlideAnimation(
          child: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
            final userAddress = context.read<UserCubit>().state.user.address;
            if (state.orderInProgress != null) {
              subTotal = 0;

              for (OrderProduct product in state.orderInProgress!.products) {
                subTotal += (product.product.price * product.quantity);
              }

              tax = double.parse(
                  (subTotal * taxDecimalPercentage).toStringAsFixed(1));

              total = double.parse(
                  (subTotal + serviceFee + tax).toStringAsFixed(1));

              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        color: Theme.of(context).cardColor,
                        child: Text(
                          AppLocalizations.of(context)!.store!.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: const Color(0xff616161),
                                    letterSpacing: 0.67,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      state.orderInProgress != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.orderInProgress!.products.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                log('PRODUCTS ${state.orderInProgress!.products}');
                                return Column(
                                  children: [
                                    cartOrderItemListTile(
                                      state.orderInProgress!.products[index],
                                      context,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 36.0,
                                          ),
                                          Text(
                                            '${state.orderInProgress!.products[index].nbrPersons}',
                                            //AppLocalizations.of(context)!.cheese!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(fontSize: 13.3),
                                          ),
                                          Divider(
                                            color: Theme.of(context).cardColor,
                                            thickness: 1.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Container(),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.7,
                      ),
                      Container(
                        height: 53.3,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: BlocConsumer<DealsCubit, DealsState>(
                          listener: (context, state) {
                            if (state is DealFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('An error has occurred!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            if (state is DealLoading) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     backgroundColor: Colors.white70,
                              //     content: Center(
                              //       child: CircularProgressIndicator(),
                              //     ),
                              //   ),
                              // );
                            }
                            if (state is DealLoaded) {
                              log('deal loaded: ${state.deal.percentage}');
                              if (state.deal.percentage != 0) {
                                discountDecimalPercentage =
                                    (state.deal.percentage / 100);
                                discountAmount = double.parse(
                                  (discountDecimalPercentage * total)
                                      .toStringAsFixed(1),
                                );

                                log('total amound: $discountDecimalPercentage');
                              } else {
                                discountAmount = 0.0;
                              }
                              setState(() {});
                            }
                          },
                          builder: (context, state) {
                            return Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/ic_promocode.png',
                                  height: 16.0,
                                  width: 16.7,
                                ),
                                const SizedBox(
                                  width: 17.3,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .instruction!,
                                    ),
                                  ),
                                ),
                                state is DealLoading
                                    ? const CircularProgressIndicator()
                                    : TextButton(
                                        child: Text(
                                          AppLocalizations.of(context)!.apply!,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<DealsCubit>()
                                              .getDeal(_controller.text);
                                        }),
                              ],
                            );
                          },
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 6.7,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .paymentInfo!
                                .toUpperCase(),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: kDisabledColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.67,
                                    )),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.sub!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                '\$ $subTotal',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ]),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Tax (${taxDecimalPercentage * 100}%)',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                '\$ $tax',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ]),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.service!,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '\$ $serviceFee',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '(${discountDecimalPercentage * 100}%) Discount',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '\$ $discountAmount',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).cardColor,
                        thickness: 1.0,
                      ),
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.amount!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '\$ $totalAmount',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 132.0,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 13.0,
                              bottom: 13.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.location_on,
                                      color: Color(0xffc4c8c1),
                                      size: 13.3,
                                    ),
                                    const SizedBox(
                                      width: 11.0,
                                    ),
                                    Text(AppLocalizations.of(context)!.deliver!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                color: kDisabledColor,
                                                fontWeight: FontWeight.bold)),
                                    // Text(
                                    //     AppLocalizations.of(context)!.homeText!,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .caption!
                                    //         .copyWith(
                                    //             color: kMainColor,
                                    //             fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 13.0,
                                ),
                                Text(
                                  userAddress ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        fontSize: 11.7,
                                        color: const Color(0xffb7b7b7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BottomBar(
                          text: AppLocalizations.of(context)!.pay! +
                              " \$ $totalAmount",
                          onTap: () async {
                            if (state.orderInProgress == null) {
                              return;
                            }

                            await showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return BottomSheet(
                                      onClosing: () {},
                                      builder: (ctx) {
                                        log("k vayo: $walletBalance");
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 16.0,
                                            ),
                                            Text(
                                              'Payment Method',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                              ),
                                              child: ListBody(
                                                children: [
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.wallet),
                                                    title: const Text('Wallet'),
                                                    trailing: Text(
                                                      '${walletBalance?.toStringAsFixed(1) ?? 0.0} \$CAD',
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      context
                                                          .read<UserCubit>()
                                                          .makePayment(
                                                            totalAmount
                                                                .toString(),
                                                            PossiblePaymentMethods
                                                                .wallet,
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.credit_card),
                                                    title: const Text(
                                                        'Credit/Debit card'),
                                                    onTap: () {
                                                      context
                                                          .read<UserCubit>()
                                                          .makePayment(
                                                            totalAmount
                                                                .toString(),
                                                            PossiblePaymentMethods
                                                                .creditCard,
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
          beginOffset: const Offset(0.0, 0.3),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }

  Column cartOrderItemListTile(
    OrderProduct orderProduct,
    BuildContext context,
  ) {
    if (orderProduct.product.rentalDuration.isNotEmpty) {
      rentDuration = '${orderProduct.product.rentalDuration}';
    } else {
      rentDuration = '${orderProduct.product.rentalDuration}';
    }
    log('order product: ${orderProduct.product.toString()}');
    return Column(
      children: <Widget>[
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.network(
                    orderProduct.product.imageUrl,
                    scale: 2.5,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Text(
                          orderProduct.product.title.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('($rentDuration)')
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(
                        () => {
                          context.read<OrderCubit>().removeProduct(orderProduct)
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      color: kMainColor,
                    ),
                  ),
                  Container(
                    height: 33.0,
                    //width: 76.7,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: kMainColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (orderProduct.quantity > 1) {
                              context.read<OrderCubit>().updateProductQuantity(
                                    orderProduct,
                                    (orderProduct.quantity - 1),
                                  );
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            color: kMainColor,
                            size: 20.0,
                            //size: 23.3,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(orderProduct.quantity.toString(),
                            style: Theme.of(context).textTheme.caption),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: () {
                            context.read<OrderCubit>().updateProductQuantity(
                                  orderProduct,
                                  (orderProduct.quantity + 1),
                                );
                          },
                          child: Icon(
                            Icons.add,
                            color: kMainColor,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  SizedBox(
                    width: 44,
                    child: Center(
                      child: Text(
                        '\$ ${orderProduct.product.price}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ]),
          ),
        )
      ],
    );
  }

  _onPressed() {
    log('pressed:');
  }
}
