part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded({required this.products});
}
class ProductLoading extends ProductState {}