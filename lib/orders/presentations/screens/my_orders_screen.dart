// import 'package:animation_wrappers/Animations/faded_scale_animation.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Locale/locales.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/Themes/style.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';
import 'package:renterii/routes/app_router.gr.dart';

import '../../../authentication/business_logic/cubit/user/user_cubit.dart';
import '../../data/models/order.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    String userId = context.read<UserCubit>().state.user.id;
    context.read<OrderCubit>().getOrdersByUser(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.orderText!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.3,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<OrderCubit>().getOrdersByUser(
                context.read<UserCubit>().state.user.id,
              );
        },
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state.status == OrderStatus.newOrderSuccess) {
              context.read<OrderCubit>().getOrdersByUser(
                    context.read<UserCubit>().state.user.id,
                  );
              return Container();
            }

            if (state.status == OrderStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == OrderStatus.ordersFetchSuccess) {
              final List<Order> orders = state.orders;
              List<Order> completedOrders = state.orders;
              List<Order> pendingOrders = state.orders;

              pendingOrders = orders
                  .where(
                    (element) => element.status?.toLowerCase() == 'pending',
                  )
                  .toList();
              completedOrders = orders
                  .where(
                    (element) => element.status?.toLowerCase() == 'completed',
                  )
                  .toList();
              return _buildOrdersSection(
                  context, pendingOrders, completedOrders);
            } else if (state.status == OrderStatus.newOrderFailure ||
                state.status == OrderStatus.ordersFetchFailure) {
              return Center(
                child: Row(
                  children: [
                    const Text('An error occured! '),
                    TextButton(
                      onPressed: () {
                        context.read<OrderCubit>().getOrdersByUser(
                              context.read<UserCubit>().state.user.id,
                            );
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            } else {
              context.read<OrderCubit>().getOrdersByUser(
                    context.read<UserCubit>().state.user.id,
                  );
              return Container();
            }
          },
        ),
      ),
    );
  }
}

List<Widget> _buildOrderBoxe(Order order, BuildContext context) {
  List<Padding> productsElements = [];
  for (dynamic product in order.products) {
    print("========================");
    print(product);
    // productsElements.add(_buildProductBoxWidget(
    //   context,
    //   product,
    // ));
  }
  return [
    InkWell(
      onTap: () {
        context.router.push(OrderMapScreenRoute(order: order));
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: FadedScaleAnimation(
              child: Image.network(
                order.shop['imageUrl']!, // scale: 6,
                width: 50,
              ),
              fadeDuration: const Duration(milliseconds: 200),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                order.shop['name'] ?? '',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.products[0]['dateStart']}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 11.7, color: Colors.black
                            // color: const Color(0xffc1c1c1)
                            ),
                  ),
                  const SizedBox(
                    height: 1.0,
                  ),
                  Text(
                    '${order.products[0]['timeStart']}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 11.7, color: Colors.black
                            // color: const Color(0xffc1c1c1)
                            ),
                  )
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Rental ' + order.status.toString(),
                    style: orderMapAppBarTextStyle.copyWith(
                        color: kMainColor, fontSize: 13),
                  ),
                  const SizedBox(height: 7.0),
                  Text(
                    '\$ ${order.total} | Credit Card',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 11.7,
                        letterSpacing: 0.06,
                        color: const Color(0xffc1c1c1)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    Divider(
      color: Theme.of(context).cardColor,
      thickness: 1.0,
    ),
    Row(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...productsElements,
        order.status == 'Completed'
            ? TextButton(
                child: const Text('Rate Now'),
                onPressed: () {
                  //print('shopReference: ${order.shopReference}');
                  context.router.push(
                    RatingScreenRoute(
                      shop: order.shop,
                      shopId: order.shopId!,
                    ),
                  );
                },
              )
            : Container(),
      ],
    )
  ];
}

// Padding _buildProductBoxWidget(
//   BuildContext context,
//   dynamic product,
// ) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 80.0),
//     child: Text(
//       product['product']['listingName']! + '  x' + product['nbrPersons'],
//       style: Theme.of(context).textTheme.caption!.copyWith(
//             fontSize: 12.0,
//             letterSpacing: 0.05,
//           ),
//     ),
//   );
// }

Container _buildSectionTitle(BuildContext context, String title) {
  return Container(
    height: 51.0,
    padding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 20,
    ),
    color: Theme.of(context).cardColor,
    child: Text(
      title,
      style: Theme.of(context).textTheme.headline6!.copyWith(
          color: const Color(0xff99a596),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.67),
    ),
  );
}

Widget _buildOrdersSection(BuildContext context, List<Order> pendingOrders,
    List<Order> completedOrders) {
  List<Widget> pendingOrdersElements = [];
  List<Widget> completedOrdersElements = [];
  for (Order order in pendingOrders) {
    pendingOrdersElements.addAll(_buildOrderBoxe(order, context));
  }

  for (Order order in completedOrders) {
    completedOrdersElements.addAll(_buildOrderBoxe(order, context));
  }

  return GestureDetector(
    // onTap: () => context.router.push(OrderMapPage()),
    child: ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        pendingOrdersElements.isNotEmpty
            ? _buildSectionTitle(
                context, AppLocalizations.of(context)!.process!)
            : Container(),
        ...pendingOrdersElements,
        const SizedBox(
          height: 8.0,
        ),
        completedOrders.isNotEmpty
            ? _buildSectionTitle(context, AppLocalizations.of(context)!.past!)
            : Container(),
        ...completedOrdersElements,
        const SizedBox(
          height: 5.0,
        ),
        Divider(
          color: Theme.of(context).cardColor,
          thickness: 1,
        ),
      ],
    ),
  );
}
