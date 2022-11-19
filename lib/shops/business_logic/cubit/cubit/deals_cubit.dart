import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:renterii/shops/data/models/deal.dart';
import 'package:renterii/shops/data/repositories/deal_repository.dart';

part 'deals_state.dart';

class DealsCubit extends Cubit<DealsState> {
  final DealRepository _dealsRepository;

  DealsCubit({required DealRepository dealRepository})
      : _dealsRepository = dealRepository,
        super(DealsInitial());

  Future<void> getAllDeals() async {
    try {
      final deals = await _dealsRepository.getDeals();

      emit(DealsLoaded(deals: deals));
    } catch (error, stackTrace) {
      print('$error $stackTrace');
    }
  }

  Future<void> getDeal(String promoCode) async {
    emit(DealLoading());

    try {
      if (state is! DealsLoaded || state is! DealLoaded) {
        await getAllDeals();
      }

      final allDeals = (state as dynamic).deals as List<Deal>;
      final deal = allDeals.firstWhere((element) =>
          element.promoCode.toUpperCase() == promoCode.toUpperCase());

      emit(
        DealLoaded(deal: deal, deals: [...allDeals]),
      );
    } catch (e) {
      emit(DealFailure(message: e.toString()));
    }
  }
}
