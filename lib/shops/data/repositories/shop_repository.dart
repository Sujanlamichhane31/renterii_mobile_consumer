import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/rentals/presentation/screens/rating_screen.dart';
import 'package:renterii/shops/data/data_providers/shop_data_provider.dart';
import 'package:renterii/shops/data/models/product.dart';
import 'package:renterii/shops/data/models/shop.dart';

class ShopRepository {
  final ShopDataProvider shopDataProvider;

  ShopRepository({required ShopDataProvider shopDataProvider})
      : shopDataProvider = shopDataProvider;

  Future<List<Shop>> getShops() async {
    try {
      final QuerySnapshot documentsSnapshot =
          await shopDataProvider.fetchShops();
      final List<Shop> allShops = [];
      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;

        final categoryData = (await docData['category'].get()).data();
        if (docData['ratings'] != null) {
          for (dynamic rate in docData['ratings']) {
            final rateResp =
                (await (rate['userId'] as DocumentReference).get()).data();
            if (rateResp != null) {
              dynamic rateData = rateResp as Map<String, dynamic>;
              print(rateData);
              rate['username'] = rateData['name'];
            }
          }
        }

        allShops.add(Shop(
            id: docSnapshot.id,
            reference: docSnapshot.reference,
            title: docData['name'] ?? '',
            description: docData['description'] ?? '',
            imageUrl: docData['imageUrl'] ?? '',
            address: docData['address'] ?? '',
            price: docData['price'] ?? 0,
            lat: docData['latitude'] ?? 0,
            lng: docData['longitude'] ?? 0,
            category: docData['category'] ?? '',
            isPopular: docData['isPopular'] ?? false,
            categoryName: categoryData['name'],
            rating: docData['ratings'] ?? ''));
      }
      print('shop: ${allShops[0]}');
      return allShops;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Shop>> getShopsWithProducts() async {
    try {
      final QuerySnapshot documentsSnapshot =
          await shopDataProvider.fetchShops();
      final List<Shop> allShops = [];
      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        final categoryData = (await docData['category'].get()).data();
        if (docData['rating'] != null) {
          for (dynamic rate in docData['rating']) {
            final rateResp =
                (await (rate['userId'] as DocumentReference).get()).data();
            if (rateResp != null) {
              dynamic rateData = rateResp as Map<String, dynamic>;
              // print(rateData);
              rate['username'] = rateData['name'];
            }
          }
        }

        dynamic shop = Shop(
            id: docSnapshot.id,
            reference: docSnapshot.reference,
            title: docData['name'] ?? '',
            description: docData['description'] ?? '',
            imageUrl: docData['imageUrl'] ?? '',
            address: docData['address'] ?? '',
            price: docData['price'] ?? 0,
            lat: docData['latitude'] ?? 0,
            lng: docData['longitude'] ?? 0,
            category: docData['category'] ?? '',
            isPopular: docData['isPopular'] ?? false,
            categoryName: categoryData['name'],
            rating: docData['ratings'] ?? '',
            products: []);
        print(shop.id);
        final QuerySnapshot shopsDocumentsSnapshot =
            await shopDataProvider.fetchProductsByShopId(shop.id);
        final List<dynamic> products = [];
        for (QueryDocumentSnapshot shopsDocSnapshot
            in shopsDocumentsSnapshot.docs) {
          Map<String, dynamic> shopsDocData =
              shopsDocSnapshot.data() as Map<String, dynamic>;
          shop.products.add({
            'description': shopsDocData['description'],
            'title': shopsDocData['title']
          });
        }

        allShops.add(shop);
      }
      // print(allShops);
      return allShops;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Shop>> getShopsByCategory(DocumentReference categoryId) async {
    try {
      final QuerySnapshot documentsSnapshot =
          await shopDataProvider.fetchShopsByCategory(categoryId);
      final List<Shop> allShops = [];
      for (QueryDocumentSnapshot docSnapshot in documentsSnapshot.docs) {
        Map<String, dynamic> docData =
            docSnapshot.data() as Map<String, dynamic>;
        final categoryData = (await docData['category'].get()).data();
        print('docData: ${docSnapshot}');
        dynamic shop = Shop(
            id: docSnapshot.id,
            reference: docSnapshot.reference,
            title: docData['name'] ?? '',
            description: docData['description'] ?? '',
            imageUrl: docData['imageUrl'] ?? '',
            address: docData['address'] ?? '',
            price: docData['price'] ?? 0,
            lat: docData['latitude'] ?? 0,
            lng: docData['longitude'] ?? 0,
            category: docData['category'] ?? '',
            isPopular: docData['isPopular'] ?? false,
            categoryName: categoryData['name'],
            rating: docData['ratings'] ?? '',
            products: []);
        final QuerySnapshot shopsDocumentsSnapshot =
            await shopDataProvider.fetchProductsByShopId(shop.id);
        final List<dynamic> products = [];
        for (QueryDocumentSnapshot shopsDocSnapshot
            in shopsDocumentsSnapshot.docs) {
          Map<String, dynamic> shopsDocData =
              shopsDocSnapshot.data() as Map<String, dynamic>;
          shop.products.add({
            'description': shopsDocData['description'],
            'name': shopsDocData['name']
          });
        }
        allShops.add(shop);
      }
      return allShops;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> newRating(String shopId, Rating rating) async {
    await shopDataProvider.newRating(shopId, rating);
  }
}
