import 'package:cloud_firestore/cloud_firestore.dart';

class HomeDataProvider {
  // get Categories from firebase
  Future<QuerySnapshot> getCategories() async {
    final QuerySnapshot response =
        await FirebaseFirestore.instance.collection("categories").get();

    return response;
  }

  // // get Shops from firebase
  // Future<void> getShops() async {
  //   final response = await FirebaseFirestore.instance.collection("shops").get();
  //   for (var queryDocumentSnapshot in response.docs) {
  //     Map<String, dynamic> data = queryDocumentSnapshot.data();
  //     print(data);
  //   }
  // }
}
