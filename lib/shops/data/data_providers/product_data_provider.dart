import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDataProvider {
  ProductDataProvider();

  Future<dynamic> fetchShopProducts(String id) async {
    final response = await FirebaseFirestore.instance
        .collection("shops")
        .doc(id)
        .collection("products")
        .get();
    return response;
  }

  Future<dynamic> getShopProducts(String id) async {
    final response =
        await FirebaseFirestore.instance.collection('products').get();
    return response;
  }
}
