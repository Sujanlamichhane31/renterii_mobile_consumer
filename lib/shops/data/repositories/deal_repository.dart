import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:renterii/shops/data/data_providers/deal_data_provider.dart';
import 'package:renterii/shops/data/models/deal.dart';

class DealRepository {

  final DealDataProvider _dealDataProvider;

  DealRepository({
    required dealDataProvider,
  }) : _dealDataProvider = dealDataProvider;

  Future<List<Deal>> getDeals() async {
     try {
      final QuerySnapshot documentsSnapshot =
          await _dealDataProvider.getDeals();

      final List<Deal> allDeals = [];

      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        allDeals.add(Deal(
            title: docData['title'],
            description: docData['description'],
            promoCode: docData['promoCode'],
            percentage: docData['percentage']
        ));
      }
      print(allDeals);
      return allDeals;
    } catch (error) {
      rethrow;
    }
  }
  Future<Deal> getDeal(String promoCode) async{

    final QuerySnapshot documentSnapshot =
    await _dealDataProvider.getDeal(promoCode);
    print('documentSnapshot deal: ${documentSnapshot.docs}');
    Deal deal = Deal(
        title: '',
        description: '',
        promoCode: '',
        percentage: 0.0);
    for (QueryDocumentSnapshot docSnapshot in documentSnapshot.docs) {
      Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
      print(docData);
      deal = Deal(
        title: docData['title'],
        description: docData['description'],
        promoCode: docData['promoCode'],
        percentage: docData['percentage'],
      );
    }

    return deal;
  }
}