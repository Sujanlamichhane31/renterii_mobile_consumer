part of 'shops_cubit.dart';

@immutable
abstract class ShopsState {}

class ShopsInitial extends ShopsState {}

class ShopsLoading extends ShopsState {}

class ShopsLoaded extends ShopsState {
  final List<Shop> shops;

  ShopsLoaded({required this.shops});
}
