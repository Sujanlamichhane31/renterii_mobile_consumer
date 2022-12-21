part of 'order_cubit.dart';

enum OrderStatus {
  initial,
  loading,
  ordersFetchSuccess,
  ordersFetchFailure,
  newOrderInProgress,
  newOrderSuccess,
  newOrderFailure,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<Order> orders;
  final Order? orderInProgress;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.orderInProgress,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<Order>? orders,
    Order? orderInProgress,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      orderInProgress: orderInProgress ?? this.orderInProgress,
    );
  }

  @override
  String toString() {
    return 'OrderState{status: $status, orders: $orders, orderInProgress: $orderInProgress}';
  }

  @override
  List<Object?> get props => [status, orders, orderInProgress];
}
