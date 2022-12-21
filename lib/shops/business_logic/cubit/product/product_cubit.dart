import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:renterii/shops/data/models/product.dart';
import 'package:renterii/shops/data/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  ProductCubit({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ProductInitial());

  Future<void> getAllProducts(String id) async {
    emit(ProductLoading());
    final List<Product> allProducts =
        await _productRepository.getShopProducts(id);
    emit(ProductLoaded(products: allProducts));
  }
}
