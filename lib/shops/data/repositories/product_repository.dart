import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/shops/data/data_providers/product_data_provider.dart';
import 'package:renterii/shops/data/models/product.dart';

class ProductRepository {
  final ProductDataProvider _productDataProvider;
  ProductRepository({
    required ProductDataProvider productDataProvider,
  })  : _productDataProvider = productDataProvider;

  Future<List<Product>> getShopProducts(String id) async {
    try {
      final QuerySnapshot documentsSnapshot = await _productDataProvider.fetchShopProducts(id);
      final List<Product> allProducts = [];
      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
        print('docProductData: $docData');
        allProducts.add(Product(
          id: docSnapshot.id,
          ref: docSnapshot.reference,
          title: docData['title']??'',
          description: docData['description']??'',
          price: docData['price'].toDouble()??0.0,
          imageUrl: docData['imageUrl']??'',
          category: docData['category'],
          rentDuration: docData['rentDuration']??1
        ));
      }
      return allProducts;
    } catch (error) {
      rethrow;
    }
  }
}