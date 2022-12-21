part of 'shop_cubit.dart';

@immutable
abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoaded extends ShopState {
  final List<Shop> shops;
  ShopLoaded({required this.shops});
}

class ShopWithProductsLoaded extends ShopState {
  final List<Map<String, dynamic>> shops;
  ShopWithProductsLoaded({required this.shops});
}

class ShopsByCategoryLoaded extends ShopState {
  final List<Shop> shops;
  ShopsByCategoryLoaded({required this.shops});
}

class ShopsLoading extends ShopState{
}

class RatingState extends ShopState {
  final bool isSuccess;
  final bool isFailure;

  RatingState({required this.isSuccess, required this.isFailure});
  factory RatingState.loading() {
    return RatingState(isSuccess: true, isFailure: false);
  }

  factory RatingState.failure() {
    return RatingState(isSuccess: false, isFailure: true);
  }
  factory RatingState.success() {
    return RatingState(isSuccess: true, isFailure: false);
  }
}
