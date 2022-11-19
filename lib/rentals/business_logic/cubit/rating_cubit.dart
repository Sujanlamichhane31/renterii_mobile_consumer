import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:renterii/rentals/presentation/screens/rating_screen.dart';
import 'package:renterii/shops/data/repositories/shop_repository.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {

  final ShopRepository _shopRepository;

  RatingCubit(this._shopRepository) : super(RatingState());

  newRating(String shopId, Rating rating) {
    RatingState.loading();
    _shopRepository.newRating(shopId, rating).then((value) => {
      RatingState.success()
    }).catchError((error) => {
      RatingState.failure()
    });
  }
}

