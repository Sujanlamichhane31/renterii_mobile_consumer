import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:renterii/rentals/presentation/screens/rating_screen.dart';
import 'package:renterii/shops/data/models/shop.dart';
import 'package:renterii/shops/data/repositories/shop_repository.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepository _shopRepository;
  ShopCubit(
    this._shopRepository,
  ) : super(ShopInitial());

  Future<void> getAllShops() async {
    final List<Shop> allShops = await _shopRepository.getShops();
    emit(ShopLoaded(shops: allShops));
  }

  Future<void> getShopsWithProducts() async {
    final List<Shop> allShops = await _shopRepository.getShopsWithProducts();
    emit(ShopLoaded(shops: allShops));
  }

  Future<void> getShopsByCategory(DocumentReference categoryId) async {
    emit(ShopsLoading());
    final List<Shop> shops =
        await _shopRepository.getShopsByCategory(categoryId);
    emit(ShopsByCategoryLoaded(shops: shops));
    print('GET SHOPS BY CATEGORY');
  }

  newRating(String shopId, Rating rating) {
    RatingState.loading();
    _shopRepository
        .newRating(shopId, rating)
        .then((value) => {RatingState.success()})
        .catchError((error) => {RatingState.failure()});
  }

  @override
  void onChange(Change<ShopState> change) {
    super.onChange(change);
    print(change);
  }
}
