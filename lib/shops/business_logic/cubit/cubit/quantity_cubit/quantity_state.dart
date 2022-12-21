part of 'quantity_cubit.dart';

abstract class QuantityState extends Equatable {
  const QuantityState();

  @override
  List<Object?> get props => [];
}

class QuantityInitial extends QuantityState {}

class ButtonVisibility extends QuantityState {
  final bool? visible;

  const ButtonVisibility({this.visible});
  @override
  List<Object?> get props => [visible];
}
