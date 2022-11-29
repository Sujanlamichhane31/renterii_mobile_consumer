import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/shops/data/data_providers/product_data_provider.dart';
import 'package:renterii/shops/data/models/product.dart';

class ProductRepository {
  final ProductDataProvider _productDataProvider;
  ProductRepository({
    required ProductDataProvider productDataProvider,
  }) : _productDataProvider = productDataProvider;

  Future<List<Product>> getShopProducts(String id) async {
    try {
      final QuerySnapshot documentsSnapshot =
          await _productDataProvider.getShopProducts(id);
      final List<Product> allProducts = [];
      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        DocumentReference data = docData['shop'];
        if (data.id == id) {
          allProducts.add(Product(
              id: docSnapshot.id,
              ref: docSnapshot.reference,
              title: docData['listingName'] ?? '',
              price: docData['rentalPrice'] ?? 0.0,
              imageUrl: docData['imageUrl'] ?? '',
              category: docData['listingCategory'] ?? '',
              rentalDuration: docData['rentalDuration'] ?? '',
              pickup: docData['pickup'] ?? -1,
              rentalFor: docData['rentalFor'] ?? '',
              typeOfRental: docData['typeOfRental'] ?? '',
              description: docData['description'] ?? '',
              rentingRules: docData['rentalRules'] ?? '',
              shop: docData['shop']));
        }
      }
      return allProducts;
    } catch (error) {
      rethrow;
    }
  }
}
