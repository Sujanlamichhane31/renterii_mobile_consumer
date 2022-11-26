import 'package:cloud_firestore/cloud_firestore.dart';

class RentalDataProvider {
  RentalDataProvider();

  Future<dynamic> fetchRentals() async {
    final response = await FirebaseFirestore.instance.collection('shops').get();
    for (var queryDocumentSnapshot in response.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      //print(data);
    }

    return response.docs.toList();
  }
}