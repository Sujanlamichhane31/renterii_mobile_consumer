import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renterii/Themes/colors.dart';
import 'package:renterii/orders/business_logic/cubit/order_cubit.dart';
import 'package:renterii/orders/data/models/order.dart';
import 'package:renterii/rentals/presentation/widgets/choose_ordering_method.dart';
import 'package:renterii/shops/business_logic/cubit/cubit/quantity_cubit/quantity_cubit.dart';
import 'package:renterii/shops/data/models/product.dart';
import 'package:intl/intl.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/shops/presentation/widgets/product_widget.dart';

class RentalScreen extends StatefulWidget {
  RentalScreen({
    Key? key,
    required this.product,
    required this.ref,
    required this.shop,
    this.quantity = 0,
  }) : super(key: key);
  final Product product;
  final Shop shop;
  final dynamic ref;
  int? quantity;
  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  late OrderProduct newOrder;
  final DateTime _dateTime = DateTime.now();
  final List<Reach> dateReach = [];
  final List<Reach> timeReach = [];
  double subTotal = 0;
  List<Product> orderList = [];
  int count = 0;
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
    count = widget.quantity ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: FadedScaleAnimation(
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                      fadeDuration: const Duration(milliseconds: 800),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: kMainColor,
                            radius: 12.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            widget.product.rentalDuration,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "\$ ${widget.product.price.toString()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 12.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Rental For ${widget.product.rentalFor}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 12.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                widget.product.pickup == 1
                                    ? "Waiver Required At Pickup"
                                    : 'Waiver Not Required At Pickup',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          QuantityToggle(
                            quantity: widget.quantity!,
                            product: widget.product,
                            ref: widget.ref,
                            count: (value) {
                              if (value > 0) {
                                context.read<QuantityCubit>().makeVisible(true);
                                widget.quantity = value;
                              } else if (value == 0) {
                                context
                                    .read<QuantityCubit>()
                                    .makeVisible(false);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      widget.product.rentingRules != null &&
                              widget.product.rentingRules!.trim().isNotEmpty
                          ? Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 12.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  widget.product.rentingRules ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
