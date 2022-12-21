import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:renterii/orders/data/repositories/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _ordersRepository;

  OrderCubit(
    this._ordersRepository,
  ) : super(const OrderState());

  Future<void> getOrdersByUser(String userId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString("userId") ?? '';
    emit(
      state.copyWith(
        status: OrderStatus.loading,
      ),
    );

    final orders = await _ordersRepository.getOrders(id);

    emit(
      state.copyWith(
        status: OrderStatus.ordersFetchSuccess,
        orders: orders,
      ),
    );
  }

  void addNewOrder({
    required OrderProduct orderProduct,
    required dynamic shopReference,
  }) {
    emit(
      state.copyWith(
        status: OrderStatus.loading,
      ),
    );

    final isOrderInProgress = state.orderInProgress != null ? true : false;
    final products =
        isOrderInProgress ? [...state.orderInProgress!.products] : [];

    final bool isInList = products.indexWhere(
            (element) => element.product.ref == orderProduct.product.ref) >
        -1;

    if (!isInList) {
      products.add(orderProduct);
    }

    emit(
      state.copyWith(
        status: OrderStatus.newOrderInProgress,
        orderInProgress: isOrderInProgress
            ? state.orderInProgress!.copyWith(
                products: products,
              )
            : Order(
                products: [orderProduct],
                shopReference: shopReference,
                status: 'pending',
              ),
      ),
    );
  }

  void updateProductQuantity(OrderProduct orderProduct, int newQuantity) {
    emit(
      state.copyWith(
        status: OrderStatus.loading,
      ),
    );

    final orderInProgress = state.orderInProgress!;
    final orderProductToUpdateIndex = orderInProgress.products.indexWhere(
        (element) => element.product.ref == orderProduct.product.ref);

    final orderProducts = [...orderInProgress.products];
    orderProducts[orderProductToUpdateIndex!].quantity = newQuantity;

    emit(
      state.copyWith(
        status: OrderStatus.newOrderInProgress,
        orderInProgress: orderInProgress.copyWith(
          products: orderProducts,
        ),
      ),
    );
  }

  void removeProduct(OrderProduct orderProduct) {
    final orderInProgress = state.orderInProgress ?? Order();
    final updatedOrderProducts = state.orderInProgress?.products
        .where((element) => element.product.ref != orderProduct.product.ref)
        .toList();

    emit(
      state.copyWith(
        status: OrderStatus.newOrderInProgress,
        orderInProgress: orderInProgress.copyWith(
          products: updatedOrderProducts,
        ),
      ),
    );
  }

  Future<void> confirmOrder({
    required double totalAmount,
    required String userId,
  }) async {
    final order = state.orderInProgress!.copyWith(total: totalAmount);

    await _ordersRepository.newOrder(order, userId);

    emit(
      state.copyWith(
        status: OrderStatus.newOrderSuccess,
        orders: [
          ...state.orders,
          order,
        ],
      ),
    );
  }

  @override
  void onChange(Change<OrderState> change) {
    super.onChange(change);
  }
}
