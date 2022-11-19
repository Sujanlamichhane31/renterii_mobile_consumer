import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/home/data/data_provider/home_data_provider.dart';
import 'package:renterii/home/data/models/category.dart';

class HomeRepository {
  final HomeDataProvider _homeDataProvider;

  HomeRepository({
    required homeDataProvider,
  }) : _homeDataProvider = homeDataProvider;

  Future<List<ShopCategory>> getCategories() async {
    try {
      final QuerySnapshot documentsSnapshot =
          await _homeDataProvider.getCategories();

      final List<ShopCategory> allCategories = [];

      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        allCategories.add(ShopCategory(name: docData['name'], id: docSnapshot.reference));
      }

      return allCategories;
    } catch (error) {
      rethrow;
    }
  }
}
