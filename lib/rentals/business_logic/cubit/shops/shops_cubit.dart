import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:renterii/rentals/data/repositories/shops_repository.dart';

import '../../../../shops/data/models/shop.dart';

part 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  final ShopsRepository _shopsRepository;
  ShopsCubit({required ShopsRepository shopsRepository})
      : _shopsRepository = shopsRepository,
        super(ShopsInitial());

  Future<void> getShops() async {
    emit(ShopsLoading());
    final shops = await _shopsRepository.getShops();
    print('bonjour: $shops');
    emit(ShopsLoaded(shops: shops));
  }
}
