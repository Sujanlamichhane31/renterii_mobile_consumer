part of 'deals_cubit.dart';

@immutable
abstract class DealsState extends Equatable {}

class DealsInitial extends DealsState {
  @override
  List<Object?> get props => [];
}

class DealsLoaded extends DealsState {
  final List<Deal> deals;

  DealsLoaded({required this.deals});

  @override
  List<Object?> get props => [];
}

class DealLoading extends DealsState {
  @override
  List<Object?> get props => [];
}

class DealLoaded extends DealsState {
  final List<Deal> deals;
  final Deal deal;

  DealLoaded({required this.deal, required this.deals});

  @override
  List<Object?> get props => [];
}

class DealFailure extends DealsState {
  final String message;
  DealFailure({required this.message});
  @override
  List<Object?> get props => [];
}
