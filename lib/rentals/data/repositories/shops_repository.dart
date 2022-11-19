import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renterii/rentals/data/data_providers/shops_data_provider.dart';

import '../../../shops/data/models/shop.dart';

class ShopsRepository {
  final ShopsDataProvider _shopsDataProvider;

  const ShopsRepository({required ShopsDataProvider shopsDataProvider})
      : _shopsDataProvider = shopsDataProvider;

  Future<List<Shop>> getShops() async {
    final shops = await _shopsDataProvider.fetchShops();
    final List<Shop> shopsList = [];
    for (var shop in shops) {
      shopsList.add(fromSnapshot(shop));
    }
    print(shopsList);
    return shops;
  }

  fromSnapshot(DocumentSnapshot snapshot) {
    return Shop(
      rating: (snapshot.data as DocumentSnapshot)['rating'],
      title: (snapshot.data as DocumentSnapshot)['title'],
      description: (snapshot.data as DocumentSnapshot)['description'],
      imageUrl: (snapshot.data as DocumentSnapshot)['image'],
      price: (snapshot.data as DocumentSnapshot)['price'],
      address: (snapshot.data as DocumentSnapshot)['address'],
      lat: (snapshot.data as DocumentSnapshot)['lat'],
      lng: (snapshot.data as DocumentSnapshot)['lng'],
      categoryName: '',
      id: snapshot.id,
      category: (snapshot.data as DocumentSnapshot)['category'],
      isPopular: (snapshot.data as DocumentSnapshot)['isPopular'],
      reference: (snapshot.data as DocumentSnapshot)['reference'],
    );
  }
}
