import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/rentals/presentation/screens/rating_screen.dart';

class ShopDataProvider {

  Future<dynamic> fetchShops() async {
    final response = await FirebaseFirestore.instance.collection("shops").get();
    
    return response;
  }

  Future<dynamic> fetchShopsWithProducts() async {
    final response = await FirebaseFirestore.instance.collectionGroup("shops").get();
    // print("======= =========");
    // print((await response).docs);

    // print("======= =========");
    // print(response.docs[0]['produits']);
    // print(response.docs[0]['shops']);
    return response;
  }

  Future<dynamic> fetchShop(String id) async {
    final response = await FirebaseFirestore.instance.collection("shops").doc(id).get();
    return response;
  }

  Future<dynamic> fetchShopsByCategory(DocumentReference categoryId) async {
    final response = await FirebaseFirestore.instance.collection('shops').where('category', isEqualTo: categoryId).get();
    return response;
  }

  Future<dynamic> fetchShopsNearUser(double latitude) async {

  }
  Future<void> newRating(String shopId, Rating rating) async{
    final userResp = await FirebaseFirestore.instance.collection("users").doc(rating.userId).get();
    final userReference = userResp.reference;
    print(userReference);
    Map<String, dynamic> newRating = {
      'description': rating.description,
      'userId': userReference,
      'start': rating.start
    };
    try{
      await FirebaseFirestore
          .instance
          .collection('shops')
          .doc(shopId).update({
        'rating': FieldValue.arrayUnion([newRating])
      });
    }catch(e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> fetchProductsByShopId(String id) async {
    final response = await FirebaseFirestore.instance.collection("shops").doc(id).collection("produits").get();
    return response;
  }

}