import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/orders/data/models/order.dart';

import '../data_providers/order_data_provider.dart';

class OrderRepository {
  final OrderDataProvider _orderDataProvider;

  OrderRepository({
    required orderDataProvider,
  }) : _orderDataProvider = orderDataProvider;

  Future<List<Order>> getOrders(String userId) async {
    try {
      final QuerySnapshot documentsSnapshot =
          await _orderDataProvider.getOrders(userId);
      log("${documentsSnapshot.docs}");
      final List<Order> orders = [];

      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        orders.add(Order(
            createdAt: docData['createdAt'],
            rating: docData['rating'],
            shop: docData['shop'],
            status: docData['status'],
            products: docData['products'],
            total: docData['total'],
            shopId: (await docData['shop'].get()).id,
            shopReference: (await docData['shop'].get()).reference));
        log('shop: ${docData['shop']}');
      }
      for (Order order in orders) {
        order.shop = (await order.shop.get()).data();
        log(order.shop);
        for (dynamic product in order.products) {
          product['product'] =
              (await Map<String, dynamic>.from(product)['product'].get())
                  .data();
        }
      }
      return orders;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> newOrder(Order order, String userId) async {
    try {
      await _orderDataProvider.newOrder(order, userId);
    } catch (error) {
      rethrow;
    }
  }
}
