part of 'category_cubit.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<ShopCategory> categories;

  CategoryLoaded({required this.categories});
}
