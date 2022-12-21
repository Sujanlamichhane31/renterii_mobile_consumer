import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quantity_state.dart';

class QuantityCubit extends Cubit<QuantityState> {
  QuantityCubit() : super(QuantityInitial());

  makeVisible(bool visibility) {
    emit(ButtonVisibility(visible: visibility));
  }
}
