import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/Themes/style.dart';
import 'package:renterii/authentication/business_logic/cubit/user/user_cubit.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';

import '../../../authentication/data/models/transaction.dart';
import '../../../orders/business_logic/cubit/order_cubit.dart';
import '../../../routes/app_router.gr.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

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
            Navigator.pop(context);
          },
        ),
        title: Text(AppLocalizations.of(context)!.wallet!,
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {/*......*/},
          ),
        ],
      ),
      body: FadedSlideAnimation(
        child: Wallet(),
        beginOffset: const Offset(0.0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

// class Transaction {
//   final String type;
//   final String name;
//   final dynamic sum;
//   final dynamic itemOrDescription;
//   final Timestamp date;
//   Transaction({
//     required this.type,
//     required this.name,
//     required this.sum,
//     required this.itemOrDescription,
//     required this.date,
//   });
// }

class Wallet extends StatelessWidget {
  Wallet({Key? key}) : super(key: key);
  final transactions = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
          ),
          child: ListTile(
            title: Text(
              AppLocalizations.of(context)!.availableBalance!.toUpperCase(),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  letterSpacing: 0.67,
                  color: kHintColor,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: BlocBuilder<UserCubit, UserState>(
              buildWhen: (prevState, currState) =>
                  prevState.user.walletBalance != currState.user.walletBalance,
              builder: (context, state) {
                print('WALLET SCREEN USER ${state.user}');
                if (state.user.transactions != null &&
                    state.user.transactions!.isNotEmpty) {
                  for (int i = 0; i < state.user.transactions!.length; i++) {
                    transactions.add(UserTransaction(
                        type: 'payment',
                        name: state.user.transactions![i].name,
                        sum: state.user.transactions![i].sum,
                        date: state.user.transactions![i].date));
                  }
                  transactions.sort((a, b) => b.date.compareTo(a.date));
                }
                return Text(
                  '\$ ${state.user.walletBalance?.toStringAsFixed(1) ?? 0.0}',
                  style: listTitleTextStyle.copyWith(
                      fontSize: 35.0,
                      color: kMainTextColor,
                      letterSpacing: 0.18),
                );
              },
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              alignment: Alignment.bottomLeft,
              height: 50.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: Theme.of(context).cardColor,
              child: Text(
                AppLocalizations.of(context)!.recent!,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: kTextColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.08),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                // height: 46.0,
                // width: 134.0,
                decoration: BoxDecoration(
                    color: kMainColor, borderRadius: BorderRadius.circular(3)),
                child: FadedScaleAnimation(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kMainColor,
                    ),
                    onPressed: () {
                      context.router.push(const AddFundsScreenRoute());
                    },
                    child: Text(
                      AppLocalizations.of(context)!.addMoney!,
                      style: bottomBarTextStyle.copyWith(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  fadeDuration: const Duration(milliseconds: 800),
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<OrderCubit, OrderState>(
          builder: (BuildContext context, OrderState state) {
            if (state.status == OrderStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == OrderStatus.initial) {
              final userId = context.read<UserCubit>().state.user.id;
              context.read<OrderCubit>().getOrdersByUser(userId);
              return Container();
            }

            print('ORDEEEEERRRRSSS ${state.orders}');

            for (int i = 0; i < state.orders.length; i++) {
              transactions.add(
                UserTransaction(
                  type: 'order',
                  name: state.orders[i].shop['title'],
                  sum: state.orders[i].total!,
                  date: DateTime.fromMillisecondsSinceEpoch(
                    state.orders[i].createdAt!.millisecondsSinceEpoch,
                  ),
                ),
              );
            }
            transactions.sort((a, b) => b.date.compareTo(a.date));

            if (transactions.isEmpty) {
              return const Center(
                child: Text('Nothing to show!'),
              );
            }
            //TODO:REPLACE SIZED BOX
            return SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: transactions.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  transactions[index].name.toString() !=
                                          'wallet reloaded'
                                      ? transactions[index].name.toString()
                                      : 'Add money to wallet',
                                  //AppLocalizations.of(context)!.store!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10.0),
                              Text(
                                  '${DateTime.fromMillisecondsSinceEpoch(
                                    transactions[index]
                                        .date
                                        .millisecondsSinceEpoch,
                                  )}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: kTextColor, fontSize: 11.7)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '\$ ${(transactions[index].sum as double).toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: transactions[index].type == 'order'
                                          ? const Color(0xffe32a2a)
                                          // : kTextColor,
                                          : Colors.green,
                                    ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                  transactions[index].type == 'order'
                                      ? 'Order'
                                      : 'Wallet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: kTextColor, fontSize: 11.7)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        Divider(
          color: Theme.of(context).cardColor,
          thickness: 3.0,
        ),
      ],
    );
  }
}
// Positioned.directional(
//           textDirection: Directionality.of(context),
//           top: 70.0,
//           end: 20.0,
//           child: Container(
//             height: 46.0,
//             width: 134.0,
//             decoration: BoxDecoration(
//                 color: kMainColor, borderRadius: BorderRadius.circular(3)),
//             child: FlatButton(
//               color: kMainColor,
//               onPressed: () =>
//                   Navigator.pushNamed(context, PageRoutes.addToWallet),
//               child: Text(
//                 AppLocalizations.of(context).addMoney,
//                 style: bottomBarTextStyle.copyWith(fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ),
