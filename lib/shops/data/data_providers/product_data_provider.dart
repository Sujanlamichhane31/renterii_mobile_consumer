import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDataProvider {
  ProductDataProvider();

  Future<dynamic> fetchShopProducts(String id) async {
    final response = await FirebaseFirestore.instance.collection("shops").doc(id).collection("produits").get();
    return response;
  }
}