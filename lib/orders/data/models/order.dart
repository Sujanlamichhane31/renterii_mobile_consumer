import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  Timestamp? createdAt;
  dynamic? rating;
  String? status;
  List<dynamic> products;
  dynamic shop;
  dynamic user;
  double? total;
  String? shopId;
  dynamic shopReference;

  Order({
    this.createdAt,
    this.rating,
    this.status,
    this.shop,
    this.user,
    this.products = const [],
    this.total,
    this.shopId,
    this.shopReference,
  });

  Map<String, dynamic> toMap(Order order) {
    return {
      'createdAt': order.createdAt,
      'rating': order.rating,
      'status': order.status,
      'shop': order.shop,
      'user': order.user,
      'products': order.products,
      'total': order.total,
      'shopId': order.shopId,
      'shopReference': order.shopReference,
    };
  }

  Order copyWith({
    Timestamp? createdAt,
    int? rating,
    String? status,
    List<dynamic>? products,
    dynamic shop,
    dynamic user,
    double? total,
    String? shopId,
    dynamic shopReference,
  }) {
    return Order(
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      products: products ?? this.products,
      shop: shop ?? this.shop,
      user: user ?? this.user,
      total: total ?? this.total,
      shopId: shopId ?? this.shopId,
      shopReference: shopReference ?? this.shopReference,
    );
  }

  @override
  List<Object> get props => [
        products,
        shopReference,
      ];
}

class OrderProduct extends Equatable {
  dynamic product;
  int quantity;
  dynamic nbrPersons;
  String? note;
  dynamic timeStart;
  dynamic dateStart;

  OrderProduct({
    required this.product,
    this.quantity = 1,
    this.nbrPersons,
    this.note,
    this.timeStart,
    this.dateStart,
  });

  @override
  List<Object?> get props => [quantity];

  Map<String, dynamic> toMap() {
    return {
      'product': product,
      'quantity': quantity,
      'nbrPersons': nbrPersons,
      'note': note,
      'timeStart': timeStart,
      'dateStart': dateStart,
    };
  }

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      product: map['product'] as dynamic,
      quantity: map['quantity'] as int,
      nbrPersons: map['nbrPersons'] as dynamic,
      note: map['note'] as String,
      timeStart: map['timeStart'] as dynamic,
      dateStart: map['dateStart'] as dynamic,
    );
  }

  @override
  String toString() {
    return 'OrderProduct{product: $product, quantity: $quantity, nbrPersons: $nbrPersons, note: $note, timeStart: $timeStart, dateStart: $dateStart}';
  }
}
