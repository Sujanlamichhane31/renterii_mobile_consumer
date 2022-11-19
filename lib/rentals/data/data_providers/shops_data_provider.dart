import 'package:cloud_firestore/cloud_firestore.dart';

class ShopsDataProvider {
  ShopsDataProvider();


  Future<dynamic> fetchShops() async {
    final response = await FirebaseFirestore.instance.collection('shops').get();
    List<Map<String, dynamic>> data = [];
    for (var queryDocumentSnapshot in response.docs) {
      Map<String, dynamic> newData = queryDocumentSnapshot.data();
      data.add(queryDocumentSnapshot.data());
    }
    return response.docs;
  }
}