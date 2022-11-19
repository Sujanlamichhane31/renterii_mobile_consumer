import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:renterii/home/data/models/category.dart';
import 'package:renterii/home/data/repositories/home_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final HomeRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(CategoryInitial());

  getAllCategories() {
    _categoryRepository
        .getCategories()
        .then((categories) => {emit(CategoryLoaded(categories: categories))});
  }
}
