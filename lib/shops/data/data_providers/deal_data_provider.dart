import 'package:cloud_firestore/cloud_firestore.dart';

class DealDataProvider {

  // get deals from firebase
  Future<dynamic> getDeals() async {
    final response = await FirebaseFirestore.instance.collection("deals").get();
    return response;
  }
  Future<dynamic> getDeal(String promoCode) async {
    final response = await FirebaseFirestore.instance.collection('deals').where(
      'promoCode', isEqualTo: promoCode).get();
    return response;
  }
}