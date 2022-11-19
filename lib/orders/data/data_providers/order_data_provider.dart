import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/orders/data/models/order.dart';

class OrderDataProvider {
  Future<dynamic> getOrders(String userId) async {
    final userResp =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    final userReference = userResp.reference;
    print('USER REFERENCE $userReference');
    final response = await FirebaseFirestore.instance
        .collection("orders")
        .where('user', whereIn: [userReference]).get();
    return response;
  }

  // add new order to firebase
  Future<void> newOrder(Order order, String userId) async {
    final userReference =
        FirebaseFirestore.instance.collection("users").doc(userId);
    print("DATATATATATAT PRPRPRPRPROOOVIDER");

    List<Map<String, dynamic>> products = [];

    for (OrderProduct product in order.products) {
      products.add({
        'dateStart': product.dateStart,
        'timeStart': product.timeStart,
        'nbrPersons': product.nbrPersons,
        'product': product.product.ref,
        'quantity': product.quantity,
      });
    }

    // Map<String, dynamic> product = {
    //   'dateStart': order.products[0].dateStart,
    //   'nbrPersons': order.products[0].nbrPersons,
    //   'product': order.products[0].product.ref
    // };

    Map<String, dynamic> orderMap = {
      'createdAt': Timestamp.now(),
      'rating': order.rating ?? [],
      'status': order.status,
      'shop': order.shopReference,
      'user': userReference,
      'products': FieldValue.arrayUnion([...products]),
      'total': order.total,
    };
    await FirebaseFirestore.instance.collection("orders").add(orderMap);
  }
}
